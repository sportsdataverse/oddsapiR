# toa_api_request() turns off httr2's status errors, so without a status check
# a 401 / 422 / 429 error body was parsed as data and came back as a one-row
# frame. Every request is answered offline here, with a fake key; the key is in
# the query string, so no message may contain it.

.fake_key <- "fake-key-0ddsap1r-5f3a9c"

.http_status_args <- list(
  sport_key = "basketball_nba", event_id = "abc", date = "2024-01-15T12:15:00Z"
)

.toa_wrappers <- c(
  "toa_sports", "toa_sports_odds", "toa_sports_scores", "toa_sports_events",
  "toa_sports_participants", "toa_event_odds", "toa_event_markets",
  "toa_sports_odds_history", "toa_sports_events_history",
  "toa_event_odds_history", "toa_requests"
)

# The Odds API answers with a JSON {message, error_code, details_url} body.
# The 401 message echoes the key, so the redaction is exercised too.
.error_bodies <- list(
  "401" = list(message = paste("API key", .fake_key, "is not valid"), error_code = "INVALID_KEY"),
  "422" = list(message = "Invalid regions parameter", error_code = "INVALID_REGION"),
  "429" = list(message = "Usage quota has been reached", error_code = "OUT_OF_USAGE_CREDITS"),
  "500" = NULL
)

.mock_status <- function(status, body) {
  function(req) {
    httr2::response(
      status_code = status, url = req$url,
      headers = list(`Content-Type` = "application/json"),
      body = if (is.null(body)) charToRaw("Internal Server Error") else
        charToRaw(as.character(jsonlite::toJSON(body, auto_unbox = TRUE)))
    )
  }
}

.call_collecting <- function(nm) {
  f <- get(nm, envir = asNamespace("oddsapiR"))
  args <- .http_status_args[intersect(names(formals(f)), names(.http_status_args))]
  msgs <- character()
  x <- withCallingHandlers(
    do.call(f, args),
    message = function(m) {
      msgs <<- c(msgs, conditionMessage(m))
      invokeRestart("muffleMessage")
    }
  )
  list(x = x, msgs = msgs)
}

test_that("a non-2xx answer is reported by every wrapper, not returned as a row", {
  skip_if_not(
    exists("local_mocked_responses", envir = asNamespace("httr2")),
    "httr2 >= 1.1.0 is needed to mock responses"
  )
  withr::local_envvar(ODDS_API_KEY = .fake_key)
  for (status in names(.error_bodies)) {
    httr2::local_mocked_responses(.mock_status(as.integer(status), .error_bodies[[status]]))
    for (nm in .toa_wrappers) {
      res <- .call_collecting(nm)
      label <- paste0(nm, "() on HTTP ", status)
      expect_s3_class(res$x, "data.frame")
      expect_identical(nrow(res$x), 0L, label = label)
      expect_false(inherits(res$x, "oddsapiR_data"), label = label)
      expect_true(any(grepl(paste0("HTTP ", status), res$msgs, fixed = TRUE)), label = label)
      expect_false(any(grepl(.fake_key, res$msgs, fixed = TRUE)), label = label)
    }
  }
})

test_that("the API's message is the reported cause", {
  skip_if_not(exists("local_mocked_responses", envir = asNamespace("httr2")))
  withr::local_envvar(ODDS_API_KEY = .fake_key)
  httr2::local_mocked_responses(.mock_status(429L, .error_bodies[["429"]]))
  res <- .call_collecting("toa_sports_odds")
  expect_true(any(grepl("Usage quota has been reached", res$msgs, fixed = TRUE)))
})

test_that(".oddsapiR_stop_for_http_status() raises a classed error without the key", {
  url <- paste0("https://api.the-odds-api.com/v4/sports?apiKey=", .fake_key, "&all=true")
  resp <- .mock_status(401L, .error_bodies[["401"]])(list(url = url))
  cnd <- expect_error(.oddsapiR_stop_for_http_status(resp), class = "oddsapiR_http_error")
  expect_identical(cnd$status, 401L)
  expect_identical(cnd$url, "https://api.the-odds-api.com/v4/sports")
  expect_match(conditionMessage(cnd), "HTTP 401 Unauthorized from https://api.the-odds-api.com/v4/sports", fixed = TRUE)
  expect_match(conditionMessage(cnd), "is not valid", fixed = TRUE)
  expect_false(grepl(.fake_key, conditionMessage(cnd), fixed = TRUE))

  ok <- httr2::response(status_code = 200L, url = url)
  expect_identical(.oddsapiR_stop_for_http_status(ok), ok)
})

test_that("a 200 answer still gives the documented frame", {
  skip_if_not(exists("local_mocked_responses", envir = asNamespace("httr2")))
  withr::local_envvar(ODDS_API_KEY = .fake_key)
  body <- list(list(
    key = "basketball_nba", group = "Basketball", title = "NBA",
    description = "US Basketball", active = TRUE, has_outrights = FALSE
  ))
  httr2::local_mocked_responses(.mock_status(200L, body))
  x <- suppressMessages(toa_sports())
  expect_s3_class(x, "oddsapiR_data")
  expect_identical(nrow(x), 1L)
  expect_in(c("key", "group", "title", "description", "active", "has_outrights"), colnames(x))
})
