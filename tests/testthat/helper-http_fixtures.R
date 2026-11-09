# Offline replay of recorded HTTP responses for the test-*_offline.R files.
#
# Fixtures are recorded by data-raw/http_fixtures/record_fixtures.R and listed in
# fixtures/http/index.json by URL. Inside a test, every httr2 request is answered
# from that index; a URL that was never recorded gets a 404, so the test fails
# instead of reaching the network. The API key travels in the `apiKey` query
# parameter, so it is replaced by `REDACTED` before the lookup: recorded URLs are
# stored that way, and replay works with or without ODDS_API_KEY set.

http_fixture_url <- function(url) sub("([?&])apiKey=[^&]*", "\\1apiKey=REDACTED", url)

http_fixture_index <- local({
  index <- NULL
  function() {
    if (is.null(index)) {
      index <<- jsonlite::read_json(testthat::test_path("fixtures", "http", "index.json"))
    }
    index
  }
})

local_http_fixtures <- function(env = parent.frame()) {
  testthat::skip_if_not(
    exists("local_mocked_responses", envir = asNamespace("httr2")),
    "httr2 >= 1.1.0 is needed to replay recorded responses"
  )
  index <- http_fixture_index()
  dir <- testthat::test_path("fixtures", "http")
  httr2::local_mocked_responses(function(req) {
    url <- http_fixture_url(req$url)
    hit <- index[[url]]
    if (is.null(hit)) {
      return(httr2::response(status_code = 404L, url = url))
    }
    path <- file.path(dir, hit$file)
    httr2::response(
      status_code = hit$status, url = url,
      headers = c(list(`Content-Type` = hit$type), hit$headers),
      body = memDecompress(readBin(path, "raw", file.size(path)), "gzip")
    )
  }, env = env)
}

expect_recorded_data <- function(x) {
  testthat::expect_false(is.null(x))
  if (is.data.frame(x)) {
    testthat::expect_gt(nrow(x), 0)
  } else {
    testthat::expect_gt(length(x), 0)
  }
}
