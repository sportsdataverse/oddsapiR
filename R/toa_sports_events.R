#' @name toa_sports_events
#' @title
#' **Find in-play and upcoming events for a sport through the Odds API**
#' @description
#' **Get the list of in-play and pre-match events for a sport.**
#'
#' Returns a list of events without odds. The `id` returned here is the
#' `event_id` consumed by [toa_event_odds()] and [toa_event_markets()].
#'
#' **Usage quota cost:** Free. This endpoint does not count against your quota.
#' @param sport_key (*string*, required): The `sport_key` to look up events for.
#'  See [toa_sports()] for a full lookup of `sport_key` values.
#' @param date_format (*string*, optional): Format of returned timestamps.
#'  Options are `iso` (default) or `unix`.
#' @param event_ids (*string*, optional): Comma-separated list of event ids to
#'  filter the response to. Defaults to `NULL` (all events).
#' @param commence_time_from (*string*, optional): Filter to events that
#'  commence on and after this ISO 8601 timestamp (e.g. `2023-09-09T00:00:00Z`).
#' @param commence_time_to (*string*, optional): Filter to events that commence
#'  on and before this ISO 8601 timestamp (e.g. `2023-09-09T00:00:00Z`).
#' @param include_rotation_numbers (*logical*, optional): If `TRUE`, include the
#'  `home_rotation` and `away_rotation` columns when available. Defaults to
#'  `FALSE`.
#' @return A tibble with one row per event:
#'
#'    |col_name      |types     |description                                          |
#'    |:-------------|:---------|:----------------------------------------------------|
#'    |id            |character |Unique event id. Use as `event_id` elsewhere.        |
#'    |sport_key     |character |Sport key, e.g. `basketball_nba`.                    |
#'    |sport_title   |character |Human-readable sport title, e.g. `NBA`.              |
#'    |commence_time |character |Event start time (ISO 8601 string or unix seconds).  |
#'    |home_team     |character |Home team name.                                      |
#'    |away_team     |character |Away team name.                                      |
#'    |home_rotation |integer   |Home rotation number (only when `include_rotation_numbers = TRUE`). |
#'    |away_rotation |integer   |Away rotation number (only when `include_rotation_numbers = TRUE`). |
#'
#' @keywords Events
#' @importFrom jsonlite fromJSON
#' @importFrom cli cli_alert_danger
#' @importFrom glue glue
#' @importFrom dplyr as_tibble
#' @importFrom rlang .data
#' @export
#' @family The Odds API: Sports & Events
#' @seealso [toa_sports()] to discover `sport_key` values, [toa_event_odds()]
#'   to pull odds for a specific event by its `id`, and [toa_event_markets()]
#'   to see available market keys per bookmaker. Part of the
#'   \href{https://sportsdataverse.org/}{SportsDataverse}.
#' @examplesIf has_toa_key()
#' \donttest{
#'    try(toa_sports_events(sport_key = 'basketball_nba'))
#' }
toa_sports_events <- function(sport_key,
                              date_format = 'iso',
                              event_ids = NULL,
                              commence_time_from = NULL,
                              commence_time_to = NULL,
                              include_rotation_numbers = FALSE){
  base_url <- glue::glue('https://api.the-odds-api.com/v4/sports/{sport_key}/events')
  query_params <- list(
    apiKey = as.character(toa_key()),
    dateFormat = date_format,
    eventIds = event_ids,
    commenceTimeFrom = commence_time_from,
    commenceTimeTo = commence_time_to,
    includeRotationNumbers = if (isTRUE(include_rotation_numbers)) "true" else NULL
  )

  events <- data.frame()

  tryCatch(
    expr = {
      events <- toa_api_call(base_url, query = query_params) %>%
        dplyr::as_tibble() %>%
        make_toa_data("Sports Events data from the-odds-api.com", Sys.time())
    },
    error = function(e) {
      cli::cli_alert_danger("{Sys.time()}: Invalid arguments or no events data available for {sport_key}!")
      cli::cli_alert_danger("Error:\n{e}")
    },
    warning = function(w) {
      cli::cli_alert_warning("{Sys.time()}: Warning:\n{w}")
    },
    finally = {
    }
  )
  return(events)
}
