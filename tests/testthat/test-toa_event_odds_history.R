
cols <- c(
  "timestamp",
  "previous_timestamp",
  "next_timestamp",
  "id",
  "sport_key",
  "sport_title",
  "commence_time",
  "home_team",
  "away_team",
  "bookmaker_key",
  "bookmaker",
  "bookmaker_last_update",
  "market_key",
  "market_last_update",
  "outcomes_name",
  "outcomes_price"
)

test_that("The Odds API - Historical Event Odds", {
  skip_on_cran()
  skip_if_not(has_toa_key(), "ODDS_API_KEY not set")

  events <- toa_sports_events_history(
    sport_key = 'basketball_nba',
    date = '2024-01-15T12:00:00Z'
  )
  if (!is.data.frame(events) || nrow(events) == 0) {
    skip("No historical events available (requires paid plan) at test time")
  }

  x <- toa_event_odds_history(
    sport_key = 'basketball_nba',
    event_id = events$id[1],
    date = '2024-01-15T12:00:00Z',
    regions = 'us',
    markets = 'h2h',
    odds_format = 'decimal',
    date_format = 'iso'
  )

  if (!is.data.frame(x) || nrow(x) == 0) {
    skip("No historical event odds returned (requires paid plan) at test time")
  }

  expect_in(sort(cols), sort(colnames(x)))
  expect_s3_class(x, "data.frame")
})
