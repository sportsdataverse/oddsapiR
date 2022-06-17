
cols <- c(
  "key",
  "group",
  "title",
  "description",
  "active",
  "has_outrights"
)

test_that("The Odds API - Sports", {
  skip_on_cran()
  # skip_on_ci()
  x <- toa_sports(all_sports = TRUE)
  # expect_equal(nrow(x), 77)
  expect_equal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
