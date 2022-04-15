
cols <- c(
  "requests_remaining",
  "requests_used"
)

test_that("The Odds API - Requests", {
  skip_on_cran()
  x <- toa_requests()
  expect_equal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
