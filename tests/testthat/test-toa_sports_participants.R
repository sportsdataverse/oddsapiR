
cols <- c(
  "sport_key",
  "id",
  "full_name"
)

test_that("The Odds API - Participants", {
  skip_on_cran()
  skip_if_not(has_toa_key(), "ODDS_API_KEY not set")

  x <- toa_sports_participants(sport_key = 'basketball_nba')

  if (!is.data.frame(x) || nrow(x) == 0) {
    skip("No participants returned from endpoint at test time")
  }

  expect_in(sort(cols), sort(colnames(x)))
  expect_s3_class(x, "data.frame")
})
