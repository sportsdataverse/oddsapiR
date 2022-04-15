
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
  x <- toa_sports_scores(sport_key = 'baseball_mlb', 
                         days_from = NULL,
                         date_format = 'iso')
  
  expect_equal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
