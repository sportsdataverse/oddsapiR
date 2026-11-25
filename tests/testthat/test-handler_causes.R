# A wrapper's tryCatch() error handler must name the cause of a failure, not
# only "no data available": a 429, a 401 and a parse bug otherwise read like an
# empty result. Every request is made to fail offline (below the API-key
# lookup, with a fake key), and every function with a block tryCatch() error
# handler must pass that cause on, without the error escaping.

.handler_cause_args <- list(
  sport_key = "basketball_nba", event_id = "abc", date = "2024-01-15T12:15:00Z"
)

# Selected by handler shape, not by whether it already reports the cause, so a
# handler that loses conditionMessage() fails here instead of silently
# dropping out of the list.
.block_handler_fns <- function() {
  ns <- asNamespace("oddsapiR")
  has_block_handler <- function(nm) {
    f <- get(nm, envir = ns)
    if (!is.function(f) || is.primitive(f)) return(FALSE)
    b <- paste(deparse(body(f)), collapse = "\n")
    grepl("tryCatch", b, fixed = TRUE) && grepl("error = function(e) {", b, fixed = TRUE)
  }
  Filter(has_block_handler, ls(ns, all.names = TRUE))
}

# Call every wrapper with httr2::req_perform() failing with `cause`. Returns
# the messages each one emitted, by name, and the names whose error escaped.
.run_failing_wrappers <- function(cause) {
  ns <- asNamespace("oddsapiR")
  local_mocked_bindings(
    req_perform = function(...) stop(cause),
    .package = "httr2"
  )
  out <- list()
  escaped <- character()
  for (nm in .block_handler_fns()) {
    f <- get(nm, envir = ns)
    args <- .handler_cause_args[intersect(names(formals(f)), names(.handler_cause_args))]
    msgs <- character()
    withCallingHandlers(
      tryCatch(do.call(f, args), error = function(e) escaped <<- c(escaped, nm)),
      message = function(m) {
        msgs <<- c(msgs, conditionMessage(m))
        invokeRestart("muffleMessage")
      },
      warning = function(w) invokeRestart("muffleWarning")
    )
    out[[nm]] <- msgs
  }
  list(msgs = out, escaped = escaped)
}

test_that("error handlers report the cause of a failed request", {
  expect_length(.block_handler_fns(), 11L)
  withr::local_envvar(ODDS_API_KEY = "test-key")
  res <- .run_failing_wrappers("mock outage")
  silent <- names(Filter(function(m) !any(grepl("mock outage", m, fixed = TRUE)), res$msgs))
  expect_identical(res$escaped, character())
  expect_identical(setdiff(silent, res$escaped), character())
})

test_that("error handlers scrub the key from a cause raised below the status check", {
  # A curl-level failure (or a JSON parse error) never passes through
  # .oddsapiR_stop_for_http_status(), and its message can quote the request
  # URL, key included. Reserved characters, so the encoded copy differs.
  key <- "fake/key+0dds=apiR"
  key_enc <- utils::URLencode(key, reserved = TRUE)
  withr::local_envvar(ODDS_API_KEY = key)
  res <- .run_failing_wrappers(paste0(
    "Failed to perform HTTP request: https://api.the-odds-api.com/v4/sports?apiKey=",
    key_enc, " (key ", key, ")"
  ))
  expect_length(res$msgs, 11L)
  expect_identical(res$escaped, character())
  leaked <- names(Filter(
    function(m) any(grepl(key, m, fixed = TRUE)) || any(grepl(key_enc, m, fixed = TRUE)),
    res$msgs
  ))
  expect_identical(leaked, character())
  unscrubbed <- names(Filter(function(m) !any(grepl("apiKey=<apiKey>", m, fixed = TRUE)), res$msgs))
  expect_identical(unscrubbed, character())
})
