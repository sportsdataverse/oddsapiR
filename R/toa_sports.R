#' @name toa_sports
#' @title
#' **Find sports for which odds are accessible through the Odds API**
#' @description
#' **Get the sports for which The Odds API provides coverage.**
#'
#' Returns a list of in-season sports. The `key` returned here is the
#' `sport_key` consumed by every other `toa_*()` endpoint.
#'
#' **Usage quota cost:** Free. This endpoint does not count against your quota.
#' @param all_sports (*Logical*, optional): If `TRUE`, returns all sports
#'  (including out-of-season). If `FALSE`, returns only in-season sports.
#'  Defaults to `TRUE`.
#' @return A tibble of the sports for which The Odds API provides coverage:
#'
#'    |col_name      |types     |description                                            |
#'    |:-------------|:---------|:------------------------------------------------------|
#'    |key           |character |Sport key, e.g. `americanfootball_nfl`. Use as `sport_key` elsewhere. |
#'    |group         |character |Sport group / category, e.g. `American Football`.      |
#'    |title         |character |Human-readable sport title, e.g. `NFL`.                |
#'    |description   |character |Description of the sport or competition.               |
#'    |active        |logical   |`TRUE` if the sport is currently in season.            |
#'    |has_outrights |logical   |`TRUE` if the sport offers outright (futures) markets. |
#'
#' @keywords Sports
#' @importFrom jsonlite fromJSON
#' @importFrom cli cli_alert_danger
#' @importFrom glue glue
#' @importFrom rlang .data
#' @export
#' @family The Odds API: Sports & Events
#' @seealso [toa_sports_events()] to list upcoming events for a sport,
#'   [toa_sports_scores()] for live/recent scores, and [toa_sports_odds()]
#'   to pull featured-market odds. Part of the
#'   \href{https://sportsdataverse.org/}{SportsDataverse}.
#' @examplesIf has_toa_key()
#' \donttest{
#'   try(toa_sports(all_sports = TRUE))
#' }
toa_sports <- function(all_sports = TRUE){
  base_url <- "https://api.the-odds-api.com/v4/sports"
  query_params <- list(
    apiKey = as.character(toa_key()),
    all = ifelse(is.logical(all_sports), tolower(as.character(all_sports)), all_sports)
  )

  sports <- data.frame()

  tryCatch(
    expr = {
      sports <- toa_api_call(base_url, query = query_params) %>%
        make_toa_data("Sports coverage data from the-odds-api.com", Sys.time())
    },
    error = function(e) {
      cli::cli_alert_danger("{Sys.time()}: Invalid arguments or no sports data available!")
      cli::cli_alert_danger("Error:\n{e}")
    },
    warning = function(w) {
      cli::cli_alert_warning("{Sys.time()}: Warning:\n{w}")
    },
    finally = {
    }
  )
  return(sports)
}
