
cols <- c(
  "requests_remaining",
  "requests_used",
  "requests_last"
)

test_that("The Odds API - Quota usage", {
  skip_on_cran()
  skip_if_not(has_toa_key(), "ODDS_API_KEY not set")

  # Make a (free) call first so the quota headers are populated this session.
  sports <- toa_sports(all_sports = TRUE)

  x <- toa_quota()
  if (is.null(x)) {
    skip("No quota headers captured at test time")
  }

  expect_in(sort(cols), sort(colnames(x)))
  expect_s3_class(x, "data.frame")
  expect_equal(nrow(x), 1L)

  # The quota usage is also attached to returned tibbles as attributes.
  expect_false(is.null(attr(sports, "oddsapiR_requests_remaining")))
})
