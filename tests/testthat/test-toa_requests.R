
cols <- c(
  "requests_remaining",
  "requests_used"
)

test_that("The Odds API - Requests", {
  skip_on_cran()
  skip_if_not(has_toa_key(), "ODDS_API_KEY not set")

  x <- toa_requests()

  if (!is.data.frame(x) || nrow(x) == 0) {
    skip("No usage data returned from endpoint at test time")
  }

  expect_in(sort(cols), sort(colnames(x)))
  expect_s3_class(x, "data.frame")
})
