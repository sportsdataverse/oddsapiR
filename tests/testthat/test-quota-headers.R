# Regression tests for the CRAN donttest ERROR (2026-08-25 check):
# a response carrying no x-requests-* headers stored integer(0) in the quota
# env, and print.oddsapiR_data's `!is.null(x) && !is.na(x)` guard then
# evaluated to NA -> "missing value where TRUE/FALSE needed".

test_that("print.oddsapiR_data survives absent quota attributes", {
  x <- make_toa_data(.toa_empty_event_odds(), "Test data", Sys.time())
  attr(x, "oddsapiR_requests_remaining") <- NULL
  expect_no_error(capture.output(print(x)))
})

test_that("print.oddsapiR_data survives zero-length quota attributes", {
  x <- make_toa_data(.toa_empty_event_odds(), "Test data", Sys.time())
  attr(x, "oddsapiR_requests_remaining") <- integer(0)
  expect_no_error(capture.output(print(x)))
})

test_that("print.oddsapiR_data survives NA quota attributes", {
  x <- make_toa_data(.toa_empty_event_odds(), "Test data", Sys.time())
  attr(x, "oddsapiR_requests_remaining") <- NA_integer_
  expect_no_error(capture.output(print(x)))
})

test_that(".toa_header_int returns NA for an absent header", {
  fake <- structure(list(), class = "httr2_response")
  local_mocked_bindings(resp_header = function(resp, name, ...) NULL, .package = "httr2")
  expect_identical(.toa_header_int(fake, "x-requests-remaining"), NA_integer_)
})

test_that(".toa_header_int parses a present header", {
  fake <- structure(list(), class = "httr2_response")
  local_mocked_bindings(resp_header = function(resp, name, ...) "417", .package = "httr2")
  expect_identical(.toa_header_int(fake, "x-requests-remaining"), 417L)
})

test_that("an API error payload is reported, not read as an empty slate", {
  # The Odds API answers an invalid key with {message, error_code, details_url}
  # and no event id; that must not be mistaken for "no odds posted yet".
  err <- list(
    message = "API key is not valid. Get an API key at https://the-odds-api.com",
    error_code = "INVALID_KEY",
    details_url = "https://the-odds-api.com/liveapi/guides/v4/api-error-codes.html#invalid-key"
  )
  expect_error(.toa_stop_if_error_payload(err), "API key is not valid")

  local_mocked_bindings(toa_api_call = function(url, query = NULL, ...) err)
  x <- suppressMessages(
    toa_event_odds(sport_key = "basketball_nba", event_id = "abc", regions = "us")
  )
  # The error path leaves the pre-initialized empty data.frame untouched, so a
  # failed call is structurally distinct from the typed empty-slate frame.
  expect_identical(nrow(x), 0L)
  expect_identical(ncol(x), 0L)
  expect_false(inherits(x, "oddsapiR_data"))
})

test_that("a genuine event with no bookmakers still reports the empty slate", {
  ok <- list(
    id = "44a92d22c85bbbf9347cf666a226ea4c",
    sport_key = "icehockey_nhl",
    sport_title = "NHL",
    commence_time = "2023-11-11T03:00:00Z",
    home_team = "Vegas Golden Knights",
    away_team = "San Jose Sharks",
    bookmakers = list()
  )
  expect_no_error(.toa_stop_if_error_payload(ok))

  local_mocked_bindings(toa_api_call = function(url, query = NULL, ...) ok)
  x <- suppressMessages(
    toa_event_odds(sport_key = "icehockey_nhl", event_id = ok$id, regions = "us")
  )
  # The empty-slate path returns the documented 14-column schema, tagged.
  expect_identical(nrow(x), 0L)
  expect_identical(ncol(x), 14L)
  expect_s3_class(x, "oddsapiR_data")
})
