
cols <- c(
  "id",
  "sport_key",
  "sport_title",
  "commence_time",
  "home_team",
  "away_team"
)

test_that("The Odds API - Events", {
  skip_on_cran()
  skip_if_not(has_toa_key(), "ODDS_API_KEY not set")

  x <- toa_sports_events(sport_key = 'basketball_nba')

  if (!is.data.frame(x) || nrow(x) == 0) {
    skip("No events returned from endpoint at test time")
  }

  expect_in(sort(cols), sort(colnames(x)))
  expect_s3_class(x, "data.frame")
})
