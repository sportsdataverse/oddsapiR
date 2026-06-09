#' @name toa_requests
#' @title
#' **Find out your usage and remaining calls for your key from The Odds API**
#' @description
#' **Get your usage and remaining calls for your key from The Odds API.**
#'
#' The values are read from the `x-requests-remaining` and `x-requests-used`
#' response headers returned with every API call. This check is performed
#' against the free `/v4/sports` endpoint, so it does not consume any quota.
#'
#' **Usage quota cost:** Free.
#' @return A tibble of The Odds API key usage with the following columns:
#'
#'    |col_name           |types   |description                                          |
#'    |:------------------|:-------|:----------------------------------------------------|
#'    |requests_remaining |integer |Usage credits remaining until the monthly quota resets. |
#'    |requests_used      |integer |Usage credits consumed since the last quota reset.   |
#'
#' @keywords Usage
#' @importFrom cli cli_alert_danger
#' @importFrom glue glue
#' @importFrom rlang .data
#' @export
#' @family The Odds API: Account & Usage
#' @seealso [toa_quota()] to read cached usage from the most recent call without
#'   a network round-trip, [toa_key()] / [register_toa] to configure your API
#'   key, and [toa_sports()] to start pulling data. Part of the
#'   \href{https://sportsdataverse.org/}{SportsDataverse}.
#' @examples \donttest{
#'   try(toa_requests())
#' }
toa_requests <- function(){
  base_url <- "https://api.the-odds-api.com/v4/sports"
  query_params <- list(
    apiKey = as.character(toa_key()),
    all = "true"
  )

  usage <- data.frame()

  tryCatch(
    expr = {
      usage <- toa_api_headers(base_url, query = query_params) %>%
        make_toa_data("API Key Usage data from the-odds-api.com", Sys.time())
    },
    error = function(e) {
      cli::cli_alert_danger("{Sys.time()}: Invalid arguments or no usage data available!")
      cli::cli_alert_danger("Error:\n{e}")
    },
    warning = function(w) {
      cli::cli_alert_warning("{Sys.time()}: Warning:\n{w}")
    },
    finally = {
    }
  )
  return(usage)
}
