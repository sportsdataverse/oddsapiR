
cols <- c(
  "timestamp",
  "previous_timestamp",
  "next_timestamp",
  "id",
  "sport_key",
  "sport_title",
  "commence_time",
  "home_team",
  "away_team"
)

test_that("The Odds API - Historical Events", {
  skip_on_cran()
  skip_if_not(has_toa_key(), "ODDS_API_KEY not set")

  x <- toa_sports_events_history(
    sport_key = 'basketball_nba',
    date = '2024-01-15T12:00:00Z'
  )

  # Historical endpoints require a paid usage plan; skip cleanly otherwise.
  if (!is.data.frame(x) || nrow(x) == 0) {
    skip("No historical events returned (requires paid plan) at test time")
  }

  expect_in(sort(cols), sort(colnames(x)))
  expect_s3_class(x, "data.frame")
})
