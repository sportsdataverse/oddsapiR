# Regression tests for #4: a valid event whose bookmakers array is empty (no
# lines posted yet) must return a typed zero-row tibble, not an error about
# invalid arguments. Payload mirrors the real response reported in the issue.
issue4_event <- list(
  id = "44a92d22c85bbbf9347cf666a226ea4c",
  sport_key = "icehockey_nhl",
  sport_title = "NHL",
  commence_time = "2023-11-11T03:00:00Z",
  home_team = "Vegas Golden Knights",
  away_team = "San Jose Sharks",
  bookmakers = list()
)

test_that("toa_event_odds returns typed empty tibble when no bookmakers (#4)", {
  local_mocked_bindings(toa_api_call = function(url, query = NULL, ...) issue4_event)

  x <- toa_event_odds(
    sport_key = "icehockey_nhl",
    event_id = "44a92d22c85bbbf9347cf666a226ea4c",
    regions = "us"
  )

  expect_s3_class(x, "data.frame")
  expect_identical(nrow(x), 0L)
  cols <- c(
    "id", "sport_key", "sport_title", "commence_time", "home_team",
    "away_team", "bookmaker_key", "bookmaker", "market_key",
    "market_last_update", "outcomes_name", "outcomes_description",
    "outcomes_price", "outcomes_point"
  )
  expect_in(sort(cols), sort(colnames(x)))
})

test_that("toa_event_odds_history returns typed empty tibble when no bookmakers (#4)", {
  local_mocked_bindings(
    toa_api_call = function(url, query = NULL, ...) {
      list(
        timestamp = "2023-11-10T12:00:00Z",
        previous_timestamp = "2023-11-10T11:55:00Z",
        next_timestamp = "2023-11-10T12:05:00Z",
        data = issue4_event
      )
    }
  )

  x <- toa_event_odds_history(
    sport_key = "icehockey_nhl",
    event_id = "44a92d22c85bbbf9347cf666a226ea4c",
    date = "2023-11-10T12:00:00Z",
    regions = "us"
  )

  expect_s3_class(x, "data.frame")
  expect_identical(nrow(x), 0L)
  cols <- c(
    "timestamp", "previous_timestamp", "next_timestamp", "id",
    "bookmaker_key", "bookmaker", "bookmaker_last_update", "market_key",
    "market_last_update", "outcomes_name", "outcomes_price", "outcomes_point"
  )
  expect_in(sort(cols), sort(colnames(x)))
})
