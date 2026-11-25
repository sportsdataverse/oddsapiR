# A wrapper's tryCatch() error handler must name the cause of a failure, not
# only "no data available": a 429, a 401 and a parse bug otherwise read like an
# empty result. Every request is made to fail offline (below the API-key
# lookup, with a fake key), and every function with a block tryCatch() error
# handler must pass that cause on, without the error escaping.

.handler_cause_args <- list(
  sport_key = "basketball_nba", event_id = "abc", date = "2024-01-15T12:15:00Z"
)

test_that("error handlers report the cause of a failed request", {
  ns <- asNamespace("oddsapiR")
  # Selected by handler shape, not by whether it already reports the cause,
  # so a handler that loses conditionMessage() fails here instead of
  # silently dropping out of the list.
  has_block_handler <- function(nm) {
    f <- get(nm, envir = ns)
    if (!is.function(f) || is.primitive(f)) return(FALSE)
    b <- paste(deparse(body(f)), collapse = "\n")
    grepl("tryCatch", b, fixed = TRUE) && grepl("error = function(e) {", b, fixed = TRUE)
  }
  fns <- Filter(has_block_handler, ls(ns, all.names = TRUE))
  expect_length(fns, 11L)

  withr::local_envvar(ODDS_API_KEY = "test-key")
  local_mocked_bindings(
    req_perform = function(...) stop("mock outage"),
    .package = "httr2"
  )

  silent <- character()
  escaped <- character()
  for (nm in fns) {
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
    if (!any(grepl("mock outage", msgs, fixed = TRUE))) silent <- c(silent, nm)
  }
  expect_identical(escaped, character())
  expect_identical(setdiff(silent, escaped), character())
})
