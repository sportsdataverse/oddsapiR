
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

test_that("The Odds API - Historical Odds", {
  skip_on_cran()
  skip_if_not(has_toa_key(), "ODDS_API_KEY not set")

  x <- toa_sports_odds_history(
    sport_key = 'basketball_nba',
    date = '2024-01-15T12:00:00Z',
    regions = 'us',
    markets = 'spreads',
    odds_format = 'decimal',
    date_format = 'iso'
  )

  # Historical endpoints require a paid usage plan; skip cleanly otherwise.
  if (!is.data.frame(x) || nrow(x) == 0) {
    skip("No historical odds returned (requires paid plan) at test time")
  }

  expect_in(sort(cols), sort(colnames(x)))
  expect_s3_class(x, "data.frame")
})
