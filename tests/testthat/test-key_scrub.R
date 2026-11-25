# The Odds API can echo the API key back in an error message (the 401 for an
# invalid key does). Neither error path may pass it on: not the non-2xx check
# in toa_api_request(), not the 200-with-an-error-body check in the
# single-event odds wrappers. The keys here are fake; nothing reaches the
# network.

# Reserved characters, so the URL-encoded copy differs from the key itself.
.scrub_key <- "fake/key+0dds=apiR"
.scrub_key_enc <- utils::URLencode(.scrub_key, reserved = TRUE)

.echo_message <- paste(
  "API key", .scrub_key, "is not valid; sent as", .scrub_key_enc
)

.expect_no_key <- function(msgs, label) {
  expect_false(any(grepl(.scrub_key, msgs, fixed = TRUE)), label = label)
  expect_false(any(grepl(.scrub_key_enc, msgs, fixed = TRUE)), label = label)
}

# Every message a wrapper emits while it handles the error.
.collect_messages <- function(code) {
  msgs <- character()
  withCallingHandlers(
    code,
    message = function(m) {
      msgs <<- c(msgs, conditionMessage(m))
      invokeRestart("muffleMessage")
    }
  )
  msgs
}

test_that("the key and its URL-encoded copy are scrubbed from any text", {
  withr::local_envvar(ODDS_API_KEY = .scrub_key)
  out <- .oddsapiR_scrub_key(.echo_message)
  .expect_no_key(out, "scrubbed message")
  expect_match(out, "API key <apiKey> is not valid; sent as <apiKey>", fixed = TRUE)
  # No key set: the text comes back as it was.
  withr::local_envvar(ODDS_API_KEY = "")
  expect_identical(.oddsapiR_scrub_key(.echo_message), .echo_message)
})

test_that("a key holding a literal %XX escape has its URL-encoded copy scrubbed", {
  # curl encodes the `%` itself, so this key goes out as fake%252Fkey%2B.
  withr::local_envvar(ODDS_API_KEY = "fake%2Fkey+")
  out <- .oddsapiR_scrub_key("sent fake%2Fkey+ as fake%252Fkey%2B")
  expect_identical(out, "sent <apiKey> as <apiKey>")
})

test_that("a 200 error body does not leak the key (toa_event_odds)", {
  withr::local_envvar(ODDS_API_KEY = .scrub_key)
  err <- list(message = .echo_message, error_code = "INVALID_KEY")

  cnd <- expect_error(.toa_stop_if_error_payload(err), "is not valid")
  .expect_no_key(conditionMessage(cnd), ".toa_stop_if_error_payload()")

  local_mocked_bindings(toa_api_call = function(url, query = NULL, ...) err)
  msgs <- .collect_messages(
    toa_event_odds(sport_key = "basketball_nba", event_id = "abc", regions = "us")
  )
  expect_true(any(grepl("is not valid", msgs, fixed = TRUE)))
  .expect_no_key(msgs, "toa_event_odds() alerts")
})

test_that("a 200 error body does not leak the key (toa_event_odds_history)", {
  withr::local_envvar(ODDS_API_KEY = .scrub_key)
  err <- list(message = .echo_message, error_code = "INVALID_KEY")
  local_mocked_bindings(toa_api_call = function(url, query = NULL, ...) err)
  msgs <- .collect_messages(
    toa_event_odds_history(
      sport_key = "basketball_nba", event_id = "abc",
      date = "2024-01-15T12:15:00Z", regions = "us"
    )
  )
  expect_true(any(grepl("is not valid", msgs, fixed = TRUE)))
  .expect_no_key(msgs, "toa_event_odds_history() alerts")
})

test_that(".oddsapiR_stop_for_http_status() scrubs the key and its URL-encoded copy", {
  # Built directly, so this runs on httr2 < 1.1.0 too (no response mocking).
  resp <- httr2::response(
    status_code = 401L,
    url = paste0("https://api.the-odds-api.com/v4/sports?apiKey=", .scrub_key_enc),
    headers = list(`Content-Type` = "application/json"),
    body = charToRaw(as.character(jsonlite::toJSON(
      list(message = .echo_message), auto_unbox = TRUE
    )))
  )
  cnd <- expect_error(.oddsapiR_stop_for_http_status(resp), class = "oddsapiR_http_error")
  expect_match(conditionMessage(cnd), "API key <apiKey> is not valid; sent as <apiKey>", fixed = TRUE)
  .expect_no_key(c(conditionMessage(cnd), cnd$url), "oddsapiR_http_error")
})

test_that("a non-2xx answer does not leak the key or its URL-encoded copy", {
  skip_if_not(
    exists("local_mocked_responses", envir = asNamespace("httr2")),
    "httr2 >= 1.1.0 is needed to mock responses"
  )
  withr::local_envvar(ODDS_API_KEY = .scrub_key)
  httr2::local_mocked_responses(function(req) {
    httr2::response(
      status_code = 401L, url = req$url,
      headers = list(`Content-Type` = "application/json"),
      body = charToRaw(as.character(jsonlite::toJSON(
        list(message = .echo_message, error_code = "INVALID_KEY"),
        auto_unbox = TRUE
      )))
    )
  })
  cnd <- expect_error(
    toa_api_call("https://api.the-odds-api.com/v4/sports", query = list(apiKey = .scrub_key)),
    class = "oddsapiR_http_error"
  )
  expect_match(conditionMessage(cnd), "HTTP 401", fixed = TRUE)
  .expect_no_key(c(conditionMessage(cnd), cnd$url), "oddsapiR_http_error")

  msgs <- .collect_messages(toa_sports_odds(sport_key = "basketball_nba"))
  expect_true(any(grepl("HTTP 401", msgs, fixed = TRUE)))
  .expect_no_key(msgs, "toa_sports_odds() alerts")
})
