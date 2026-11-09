# Every wrapper reports a failed request through cli and returns an empty frame
# instead of raising. These mock the HTTP layer, so they run offline.

wrapper_calls <- list(
  toa_sports = function() toa_sports(),
  toa_sports_events = function() toa_sports_events("basketball_nba"),
  toa_sports_events_history = function() toa_sports_events_history("basketball_nba", date = "2024-01-15T12:15:00Z"),
  toa_sports_odds = function() toa_sports_odds("basketball_nba"),
  toa_sports_odds_history = function() toa_sports_odds_history("basketball_nba", date = "2024-01-15T12:15:00Z"),
  toa_sports_participants = function() toa_sports_participants("basketball_nba"),
  toa_sports_scores = function() toa_sports_scores("basketball_nba"),
  toa_event_odds = function() toa_event_odds("basketball_nba", event_id = "abc"),
  toa_event_odds_history = function() toa_event_odds_history("basketball_nba", event_id = "abc", date = "2024-01-15T12:15:00Z"),
  toa_event_markets = function() toa_event_markets("basketball_nba", event_id = "abc")
)

test_that("a failed request is reported and returns an empty data.frame", {
  local_mocked_bindings(
    toa_api_call = function(url, query = NULL, ...) stop("HTTP 401"),
    toa_api_headers = function(url, query = NULL, ...) stop("HTTP 401")
  )
  for (nm in names(wrapper_calls)) {
    out <- NULL
    suppressMessages(expect_message(out <- wrapper_calls[[nm]](), "HTTP 401"))
    expect_identical(nrow(out), 0L, label = nm)
  }
  suppressMessages(expect_message(out <- toa_requests(), "HTTP 401"))
  expect_identical(nrow(out), 0L)
})

test_that("a warning during parsing is reported and returns an empty data.frame", {
  local_mocked_bindings(
    toa_api_call = function(url, query = NULL, ...) warning("odd payload"),
    toa_api_headers = function(url, query = NULL, ...) warning("odd payload")
  )
  for (nm in names(wrapper_calls)) {
    out <- NULL
    suppressMessages(expect_message(out <- wrapper_calls[[nm]](), "odd payload"))
    expect_identical(nrow(out), 0L, label = nm)
  }
  suppressMessages(expect_message(out <- toa_requests(), "odd payload"))
  expect_identical(nrow(out), 0L)
})

test_that("the key helpers read ODDS_API_KEY", {
  old <- Sys.getenv("ODDS_API_KEY", unset = NA)
  on.exit(if (is.na(old)) Sys.unsetenv("ODDS_API_KEY") else Sys.setenv(ODDS_API_KEY = old))

  Sys.setenv(ODDS_API_KEY = "")
  expect_identical(toa_key(), NA_character_)
  expect_false(has_toa_key())
  expect_error(check_toa_key(), "requires an API key")

  Sys.setenv(ODDS_API_KEY = "not-a-real-key")
  expect_identical(toa_key(), "not-a-real-key")
  expect_true(has_toa_key())
  expect_silent(check_toa_key())
})

test_that("toa_quota() is NULL before any call and a tibble after one", {
  had <- exists("quota", envir = .oddsapiR, inherits = FALSE)
  old <- if (had) get("quota", envir = .oddsapiR)
  on.exit(if (had) assign("quota", old, envir = .oddsapiR) else
    suppressWarnings(rm("quota", envir = .oddsapiR)))

  suppressWarnings(rm("quota", envir = .oddsapiR))
  expect_null(toa_quota())

  assign("quota", list(requests_remaining = 10L, requests_used = 5L, requests_last = 1L),
         envir = .oddsapiR)
  q <- toa_quota()
  expect_identical(q$requests_remaining, 10L)
  expect_identical(q$requests_last, 1L)

  x <- make_toa_data(data.frame(a = 1), "Test data", Sys.time())
  expect_identical(attr(x, "oddsapiR_requests_used"), 5L)
  expect_no_error(capture.output(print(x)))
})
