.datatable.aware <- TRUE

# Package-local store for the most recent Odds API usage-quota headers. Populated
# by every successful request and read by make_toa_data() / toa_quota().
.oddsapiR <- new.env(parent = emptyenv())

# Read the x-requests-* usage headers off a response and cache them for the
# session. Returns the parsed values invisibly.
.toa_store_quota <- function(resp){
  quota <- list(
    requests_remaining = suppressWarnings(as.integer(httr2::resp_header(resp, "x-requests-remaining"))),
    requests_used      = suppressWarnings(as.integer(httr2::resp_header(resp, "x-requests-used"))),
    requests_last      = suppressWarnings(as.integer(httr2::resp_header(resp, "x-requests-last")))
  )
  assign("quota", quota, envir = .oddsapiR)
  invisible(quota)
}

#' @title
#' **Build and perform a GET request against The Odds API (httr2)**
#' @description
#' Internal HTTP layer shared by every `toa_*()` wrapper. Builds an `httr2`
#' request from a base URL plus a named list of query parameters, applies the
#' standard user agent + transient-error retry policy, performs it, and caches
#' the `x-requests-*` usage-quota headers for [toa_quota()]. `NULL` query values
#' are dropped automatically by [httr2::req_url_query()], so optional parameters
#' can be threaded through unconditionally.
#' @param url Base endpoint URL (without query string).
#' @param query Named list of query parameters. `NULL` elements are omitted.
#' @param ... Reserved for forward compatibility.
#' @return An `httr2_response` object.
#' @keywords internal
#' @importFrom httr2 request req_url_query req_user_agent req_retry req_error req_perform
toa_api_request <- function(url, query = NULL, ...){
  resp <- httr2::request(url) %>%
    httr2::req_url_query(!!!query) %>%
    httr2::req_user_agent("oddsapiR (https://github.com/sportsdataverse/oddsapiR)") %>%
    httr2::req_retry(max_tries = 3) %>%
    # Do not raise on HTTP errors -- let the calling wrapper's tryCatch handle a
    # non-200 body (the API returns an error JSON object that fails downstream
    # parsing, which the wrapper reports via cli).
    httr2::req_error(is_error = function(resp) FALSE) %>%
    httr2::req_perform()
  .toa_store_quota(resp)
  resp
}

#' @name toa_quota
#' @title
#' **Inspect your Odds API usage quota**
#' @description
#' Returns the usage-quota headers reported by The Odds API on the **most
#' recent** `toa_*()` call made in this R session. The Odds API returns three
#' headers with every response:
#'
#'  * `x-requests-remaining` -- usage credits remaining until the quota resets
#'  * `x-requests-used` -- usage credits used since the last quota reset
#'  * `x-requests-last` -- the usage cost of the last API call
#'
#' These same values are attached as attributes (`oddsapiR_requests_remaining`,
#' `oddsapiR_requests_used`, `oddsapiR_requests_last`) to every tibble returned
#' by a `toa_*()` function, and are echoed when the tibble is printed.
#' @return A one-row tibble with columns `requests_remaining`, `requests_used`
#'  and `requests_last`, or `NULL` if no API call has been made yet this session.
#' @export
#' @examples \donttest{
#'   try(toa_sports())
#'   try(toa_quota())
#' }
toa_quota <- function(){
  quota <- tryCatch(get("quota", envir = .oddsapiR), error = function(e) NULL)
  if (is.null(quota)) return(NULL)
  dplyr::as_tibble(data.frame(
    requests_remaining = quota$requests_remaining,
    requests_used      = quota$requests_used,
    requests_last      = quota$requests_last
  ))
}

#' @title
#' **Perform a GET request and parse the JSON body**
#' @param url Base endpoint URL (without query string).
#' @param query Named list of query parameters. `NULL` elements are omitted.
#' @param ... Passed to [toa_api_request()].
#' @return The parsed JSON body (list / data.frame via [jsonlite::fromJSON()]).
#' @keywords internal
#' @importFrom httr2 resp_body_string
#' @importFrom jsonlite fromJSON
toa_api_call <- function(url, query = NULL, ...){
  resp <- toa_api_request(url, query = query, ...)
  httr2::resp_body_string(resp) %>%
    jsonlite::fromJSON(simplifyVector = TRUE)
}

#' @title
#' **Perform a GET request and return the quota usage headers**
#' @param url Base endpoint URL (without query string).
#' @param query Named list of query parameters. `NULL` elements are omitted.
#' @param ... Passed to [toa_api_request()].
#' @return A data.frame of `requests_remaining` / `requests_used`.
#' @keywords internal
#' @importFrom httr2 resp_header
toa_api_headers <- function(url, query = NULL, ...){
  resp <- toa_api_request(url, query = query, ...)
  data.frame(
    requests_remaining = as.integer(httr2::resp_header(resp, "x-requests-remaining")),
    requests_used      = as.integer(httr2::resp_header(resp, "x-requests-used"))
  )
}

#' **Progressively**
#'
#' This function helps add progress-reporting to any function - given function `f()` and progressor `p()`, it will return a new function that calls `f()` and then (on-exiting) will call `p()` after every iteration.
#'
#' This is inspired by purrr's `safely`, `quietly`, and `possibly` function decorators.
#'
#' @param f a function to add progressr functionality to.
#' @param p a progressor function as created by `progressr::progressor()`
#'
#' @return a function that does the same as `f` but it calls `p()` after iteration.
#' @keywords Internal
#'
progressively <- function(f, p = NULL){
  if(!is.null(p) && !inherits(p, "progressor")) stop("`p` must be a progressor function!")
  if(is.null(p)) p <- function(...) NULL
  force(f)
  
  function(...){
    on.exit(p("loading..."))
    f(...)
  }
  
}


#' @title
#' **Load .csv / .csv.gz file from a remote connection**
#' @description
#' This is a thin wrapper on data.table::fread
#' @param ... passed to data.table::fread
#' @keywords Internal
#' @importFrom data.table fread
#' @return a dataframe as created by [`data.table::fread()`]
csv_from_url <- function(...){
  data.table::fread(...)
}

#' @title
#' **Load .rds file from a remote connection**
#' @param url a character url
#' @return a dataframe as created by [`readRDS()`]
#' @keywords Internal
#' @importFrom data.table data.table setDT
#' @import rvest
rds_from_url <- function(url) {
  con <- url(url)
  on.exit(close(con))
  load <- try(readRDS(con), silent = TRUE)
  
  if (inherits(load, "try-error")) {
    warning(paste0("Failed to readRDS from <", url, ">"), call. = FALSE)
    return(data.table::data.table())
  }
  
  data.table::setDT(load)
  return(load)
}


# check if a package is installed
is_installed <- function(pkg) requireNamespace(pkg, quietly = TRUE)
# custom mode function from https://stackoverflow.com/questions/2547402/is-there-a-built-in-function-for-finding-the-mode/8189441
custom_mode <- function(x, na.rm = TRUE) {
  if (na.rm) {
    x <- x[!is.na(x)]
  }
  ux <- unique(x)
  return(ux[which.max(tabulate(match(x, ux)))])
}

year_to_season <- function(year){
  first_year <- substr(year,3,4)
  next_year <- as.numeric(first_year)+1
  next_year <- dplyr::case_when(
    next_year <10 & first_year > 0 ~ glue::glue("0{next_year}"),
    first_year == 99 ~ "00",
    TRUE ~ as.character(next_year))
  return(glue::glue("{year}-{next_year}"))
}


# The function `message_completed` to create the green "...completed" message
# only exists to hide the option `in_builder` in dots
message_completed <- function(x, in_builder = FALSE) {
  if (isFALSE(in_builder)) {
    str <- paste0(my_time(), " | ", x)
    cli::cli_alert_success("{{.field {str}}}")
  } else if (in_builder) {
    cli::cli_alert_success("{my_time()} | {x}")
  }
}

user_message <- function(x, type) {
  if (type == "done") {
    cli::cli_alert_success("{my_time()} | {x}")
  } else if (type == "todo") {
    cli::cli_ul("{my_time()} | {x}")
  } else if (type == "info") {
    cli::cli_alert_info("{my_time()} | {x}")
  } else if (type == "oops") {
    cli::cli_alert_danger("{my_time()} | {x}")
  }
}

my_time <- function() strftime(Sys.time(), format = "%H:%M:%S")

rule_header <- function(x) {
  rlang::inform(
    cli::rule(
      left = ifelse(is_installed("crayon"), crayon::bold(x), glue::glue("\033[1m{x}\033[22m")),
      right = paste0("oddsapiR version ", utils::packageVersion("oddsapiR")),
      width = getOption("width")
    )
  )
}

rule_footer <- function(x) {
  rlang::inform(
    cli::rule(
      left = ifelse(is_installed("crayon"), crayon::bold(x), glue::glue("\033[1m{x}\033[22m")),
      width = getOption("width")
    )
  )
}

#' @importFrom httr2 resp_status
check_status <- function(res) {
  x <- httr2::resp_status(res)
  if (x != 200) stop("The API returned an error", call. = FALSE)
}

#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

#' @import utils
utils::globalVariables(c("where"))


`%c%` <- function(x,y){
  ifelse(!is.na(x),x,y)
}


# Functions for custom class
# turn a data.frame into a tibble/oddsapiR_data
make_toa_data <- function(df,type,timestamp){
  out <- df %>%
    tidyr::as_tibble()

  class(out) <- c("oddsapiR_data","tbl_df","tbl","data.table","data.frame")
  attr(out,"oddsapiR_timestamp") <- timestamp
  attr(out,"oddsapiR_type") <- type

  # Attach the usage-quota headers cached from the most recent request so the
  # remaining/used/last credits travel with the returned data.
  quota <- tryCatch(get("quota", envir = .oddsapiR), error = function(e) NULL)
  if (!is.null(quota)) {
    attr(out,"oddsapiR_requests_remaining") <- quota$requests_remaining
    attr(out,"oddsapiR_requests_used")      <- quota$requests_used
    attr(out,"oddsapiR_requests_last")      <- quota$requests_last
  }
  return(out)
}

#' @export
#' @noRd
print.oddsapiR_data <- function(x,...) {
  cli::cli_rule(left = "{attr(x,'oddsapiR_type')}",right = "{.emph oddsapiR {utils::packageVersion('oddsapiR')}}")

  if(!is.null(attr(x,'oddsapiR_timestamp'))) {
    cli::cli_alert_info(
      "Data updated: {.field {format(attr(x,'oddsapiR_timestamp'), tz = Sys.timezone(), usetz = TRUE)}}"
    )
  }

  remaining <- attr(x, "oddsapiR_requests_remaining")
  if (!is.null(remaining) && !is.na(remaining)) {
    cli::cli_alert_info(
      "Odds API quota: {.field {attr(x,'oddsapiR_requests_used')}} used, {.field {remaining}} remaining (last call cost {.field {attr(x,'oddsapiR_requests_last')}})"
    )
  }

  NextMethod(print,x)
  invisible(x)
}


# rbindlist but maintain attributes of last file
rbindlist_with_attrs <- function(dflist){
  
  oddsapiR_timestamp <- attr(dflist[[length(dflist)]], "oddsapiR_timestamp")
  oddsapiR_type <- attr(dflist[[length(dflist)]], "oddsapiR_type")
  out <- data.table::rbindlist(dflist, use.names = TRUE, fill = TRUE)
  attr(out,"oddsapiR_timestamp") <- oddsapiR_timestamp
  attr(out,"oddsapiR_type") <- oddsapiR_type
  out
}