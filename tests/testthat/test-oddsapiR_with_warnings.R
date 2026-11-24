test_that(".oddsapiR_with_warnings() names the wrapper and keeps the result", {
  f <- function() {
    df <- data.frame()
    tryCatch(
      expr = .oddsapiR_with_warnings("my_wrapper", {
        x <- as.integer("not a number") # warns: NAs introduced by coercion
        df <- data.frame(x = x, y = 1L)
      }),
      error = function(e) NULL
    )
    df
  }
  expect_warning(out <- f(), class = "oddsapiR_warning", regexp = "my_wrapper\\(\\): .*coercion")
  expect_equal(nrow(out), 1L)
  expect_identical(out$y, 1L)
})

test_that("nested .oddsapiR_with_warnings() raises one warning, named by the inner wrapper", {
  w <- testthat::capture_warnings(
    .oddsapiR_with_warnings("outer", .oddsapiR_with_warnings("inner", warning("boom")))
  )
  expect_length(w, 1L)
  expect_match(w, "inner\\(\\): boom")
})

test_that(".oddsapiR_with_warnings() keeps return(), error handling and the original class", {
  early <- function() {
    tryCatch(expr = .oddsapiR_with_warnings("early", {
      return("returned")
      "not reached"
    }), error = function(e) "error")
  }
  expect_identical(early(), "returned")

  expect_warning(caught <- tryCatch(
    expr = .oddsapiR_with_warnings("caught", {
      warning("first")
      stop("then failed")
    }),
    error = function(e) conditionMessage(e)
  ), class = "oddsapiR_warning")
  expect_identical(caught, "then failed")

  custom <- function() warning(warningCondition("deprecated thing", class = "my_deprecation"))
  expect_no_warning(suppressWarnings(.oddsapiR_with_warnings("cls", custom()), classes = "my_deprecation"))
})

test_that("a wrapper returns its rows when the request warns", {
  # Before this fix a tryCatch(warning =) handler stopped the body at the
  # first warning, printed it, and returned the empty frame. The warning comes
  # ahead of the assignment here, so the old behaviour returns 0 rows.
  skip_on_cran()
  local_http_fixtures()
  withr::local_envvar(ODDS_API_KEY = "test-key")
  real_call <- toa_api_call
  local_mocked_bindings(toa_api_call = function(url, query = NULL, ...) {
    warning("synthetic parse warning")
    real_call(url, query = query, ...)
  })
  expect_warning(out <- toa_sports(all_sports = TRUE), class = "oddsapiR_warning",
                 regexp = "toa_sports\\(\\): synthetic parse warning")
  expect_gt(nrow(out), 0L)
  expect_true("key" %in% colnames(out))
})
