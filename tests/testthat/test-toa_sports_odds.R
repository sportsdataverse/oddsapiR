
cols <- c(
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
  "outcomes_price",
  "outcomes_point"
)

test_that("The Odds API - Odds", {
  skip_on_cran()
  skip_if_not(has_toa_key(), "ODDS_API_KEY not set")

  x <- toa_sports_odds(sport_key = 'basketball_nba',
                       regions = 'us',
                       markets = 'spreads',
                       odds_format = 'decimal',
                       date_format = 'iso')

  # Out-of-season sports return no games; skip rather than fail.
  if (!is.data.frame(x) || nrow(x) == 0) {
    skip("No odds returned from endpoint at test time")
  }

  expect_in(sort(cols), sort(colnames(x)))
  expect_s3_class(x, "data.frame")
})
