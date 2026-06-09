
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
  "market_last_update"
)

test_that("The Odds API - Event Markets", {
  skip_on_cran()
  skip_if_not(has_toa_key(), "ODDS_API_KEY not set")

  events <- toa_sports_events(sport_key = 'basketball_nba')
  if (!is.data.frame(events) || nrow(events) == 0) {
    skip("No events available to look up event markets at test time")
  }

  x <- toa_event_markets(
    sport_key = 'basketball_nba',
    event_id = events$id[1],
    regions = 'us'
  )

  if (!is.data.frame(x) || nrow(x) == 0) {
    skip("No event markets returned from endpoint at test time")
  }

  expect_in(sort(cols), sort(colnames(x)))
  expect_s3_class(x, "data.frame")
})
