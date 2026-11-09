# Internal helpers in R/utils.R. Pure functions, run offline.

test_that("progressively() calls the progressor after each call", {
  ticks <- 0
  p <- structure(function(...) ticks <<- ticks + 1, class = "progressor")
  f <- progressively(function(x) x * 2, p)
  expect_identical(f(2), 4)
  expect_identical(ticks, 1)
  expect_identical(progressively(sqrt)(4), 2)
  expect_error(progressively(sqrt, p = function() NULL), "progressor")
})

file_url <- function(path) {
  path <- normalizePath(path, winslash = "/")
  paste0("file://", if (startsWith(path, "/")) "" else "/", path)
}

test_that("csv_from_url() and rds_from_url() read local files", {
  csv <- tempfile(fileext = ".csv")
  rds <- tempfile(fileext = ".rds")
  on.exit(unlink(c(csv, rds)))
  utils::write.csv(data.frame(a = 1:2), csv, row.names = FALSE)
  # url() on a file:// path is a file connection, which readRDS() does not gunzip
  saveRDS(data.frame(a = 1:2), rds, compress = FALSE)

  expect_identical(nrow(csv_from_url(csv)), 2L)
  out <- rds_from_url(file_url(rds))
  expect_s3_class(out, "data.table")
  expect_identical(out$a, 1:2)

  bad <- tempfile(fileext = ".rds")
  writeLines("not an rds", bad)
  on.exit(unlink(bad), add = TRUE)
  expect_warning(
    empty <- rds_from_url(file_url(bad)),
    "Failed to readRDS"
  )
  expect_identical(nrow(empty), 0L)
})

test_that("custom_mode() returns the most frequent value", {
  expect_identical(custom_mode(c(1, 2, 2, NA, NA, NA)), 2)
  expect_true(is.na(custom_mode(c(1, NA, NA), na.rm = FALSE)))
})

test_that("year_to_season() formats a season label", {
  expect_equal(as.character(year_to_season(2023)), "2023-24")
  expect_equal(as.character(year_to_season(2005)), "2005-06")
  expect_equal(as.character(year_to_season(1999)), "1999-00")
})

test_that("message helpers emit cli output", {
  expect_message(message_completed("done"), "done")
  expect_message(message_completed("done", in_builder = TRUE), "done")
  for (type in c("done", "todo", "info", "oops")) {
    expect_message(user_message("hello", type), "hello")
  }
  expect_match(my_time(), "^\\d{2}:\\d{2}:\\d{2}$")
  expect_message(rule_header("Header"), "Header")
  expect_message(rule_footer("Footer"), "Footer")
})

test_that("check_status() raises on a non-200 response", {
  expect_silent(check_status(httr2::response(status_code = 200L)))
  expect_error(check_status(httr2::response(status_code = 404L)), "returned an error")
})

test_that("%c% falls back where the left side is NA", {
  expect_identical(c(1, NA) %c% c(9, 9), c(1, 9))
})

test_that("rbindlist_with_attrs() keeps the last frame's attributes", {
  a <- data.frame(x = 1)
  b <- data.frame(x = 2, y = "b")
  attr(b, "oddsapiR_timestamp") <- "t"
  attr(b, "oddsapiR_type") <- "type"
  out <- rbindlist_with_attrs(list(a, b))
  expect_identical(nrow(out), 2L)
  expect_identical(attr(out, "oddsapiR_type"), "type")
  expect_identical(attr(out, "oddsapiR_timestamp"), "t")
})
