#' @name toa_sports_scores
#' @title
#' **Find scores for the sports which are accessible through the Odds API**
#' @description
#' **Get the scores for the sports which The Odds API provides coverage.**
#'
#' Returns live and recently completed games for a sport, including scores for
#' games completed within the last 3 days. Live scores update roughly every 30
#' seconds.
#'
#' **Usage quota cost:** 1 credit when `days_from` is not supplied; 2 credits
#' when `days_from` is supplied.
#' @param sport_key (*string*, required): The `sport_key` to look up scores for.
#'  See [toa_sports()] for a full lookup of `sport_key` values.
#' @param days_from (*integer*, optional): Number of days in the past from which
#'  to return completed games, an integer from 1 to 3. If `NULL` (default), only
#'  live and upcoming games are returned.
#' @param date_format (*string*, optional): Format of returned timestamps.
#'  Options are:
#'  * `iso` (ISO 8601, the default)
#'  * `unix` (epoch seconds)
#' @return A tibble of scores for the sport The Odds API provides coverage for:
#'
#'    |col_name      |types     |description                                                |
#'    |:-------------|:---------|:----------------------------------------------------------|
#'    |id            |character |Unique event id.                                           |
#'    |sport_key     |character |Sport key, e.g. `basketball_nba`.                          |
#'    |sport_title   |character |Human-readable sport title, e.g. `NBA`.                    |
#'    |commence_time |character |Game start time (ISO 8601 string or unix seconds).         |
#'    |completed     |logical   |`TRUE` if the game has finished.                           |
#'    |home_team     |character |Home team name.                                            |
#'    |away_team     |character |Away team name.                                            |
#'    |scores        |list      |Per-team `name`/`score` pairs; `NULL`/`NA` before scores post. |
#'    |last_update   |character |Time the scores were last updated; `NA` until a game is live. |
#'
#' @keywords Scores
#' @importFrom jsonlite fromJSON
#' @importFrom cli cli_alert_danger
#' @importFrom glue glue
#' @importFrom rlang .data
#' @export
#' @family The Odds API: Sports & Events
#' @seealso [toa_sports()] to discover `sport_key` values, [toa_sports_events()]
#'   to list upcoming events, and [toa_sports_odds()] for live/upcoming betting
#'   lines. Part of the \href{https://sportsdataverse.org/}{SportsDataverse}.
#' @examplesIf has_toa_key()
#' \donttest{
#'    try(toa_sports_scores(sport_key = 'basketball_nba',
#'                          days_from = NULL,
#'                          date_format = 'iso'))
#' }
toa_sports_scores <- function(sport_key,
                              days_from = NULL,
                              date_format = 'iso'){
  base_url <- glue::glue('https://api.the-odds-api.com/v4/sports/{sport_key}/scores')
  query_params <- list(
    apiKey = as.character(toa_key()),
    daysFrom = days_from,
    dateFormat = date_format
  )

  scores <- data.frame()

  tryCatch(
    expr = {
      scores <- toa_api_call(base_url, query = query_params) %>%
        make_toa_data("Sports scores data from the-odds-api.com", Sys.time())
    },
    error = function(e) {
      cli::cli_alert_danger("{Sys.time()}: Invalid arguments or no scores data available for {sport_key}!")
      cli::cli_alert_danger("Error:\n{e}")
    },
    warning = function(w) {
      cli::cli_alert_warning("{Sys.time()}: Warning:\n{w}")
    },
    finally = {
    }
  )
  return(scores)
}
