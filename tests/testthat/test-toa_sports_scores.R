
cols <- c(
  "id",
  "sport_key",
  "sport_title",
  "commence_time",
  "completed",
  "home_team",
  "away_team",
  "scores",
  "last_update"
)

test_that("The Odds API - Scores", {
  skip_on_cran()
  skip_if_not(has_toa_key(), "ODDS_API_KEY not set")

  x <- toa_sports_scores(sport_key = 'basketball_nba',
                         days_from = NULL,
                         date_format = 'iso')

  # Out-of-season sports return no games; skip rather than fail.
  if (!is.data.frame(x) || nrow(x) == 0) {
    skip("No scores returned from endpoint at test time")
  }

  expect_in(sort(cols), sort(colnames(x)))
  expect_s3_class(x, "data.frame")
})
