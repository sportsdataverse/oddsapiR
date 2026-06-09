
cols <- c(
  "id",
  "sport_key",
  "sport_title",
  "commence_time",
  "home_team",
  "away_team",
  "bookmaker_key",
  "bookmaker",
  "market_key",
  "market_last_update",
  "outcomes_name",
  "outcomes_price"
)

test_that("The Odds API - Event Odds", {
  skip_on_cran()
  skip_if_not(has_toa_key(), "ODDS_API_KEY not set")

  events <- toa_sports_events(sport_key = 'basketball_nba')
  if (!is.data.frame(events) || nrow(events) == 0) {
    skip("No events available to look up event odds at test time")
  }

  x <- toa_event_odds(
    sport_key = 'basketball_nba',
    event_id = events$id[1],
    regions = 'us',
    markets = 'h2h,spreads',
    odds_format = 'decimal',
    date_format = 'iso'
  )

  if (!is.data.frame(x) || nrow(x) == 0) {
    skip("No event odds returned from endpoint at test time")
  }

  expect_in(sort(cols), sort(colnames(x)))
  expect_s3_class(x, "data.frame")
})
