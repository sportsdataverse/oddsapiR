#' @name toa_sports_events_history
#' @title
#' **Find historical events for a sport through the Odds API**
#' @description
#' **Get the list of events for a sport as they appeared at a point in time.**
#'
#' Returns the events (without odds) that existed at the snapshot closest to
#' (and at or before) the requested `date`. The returned `timestamp`,
#' `previous_timestamp` and `next_timestamp` columns let you page through
#' snapshots. The `id` returned here is the `event_id` consumed by
#' [toa_event_odds_history()].
#'
#' Historical data is available on paid usage plans from June 2020.
#'
#' **Usage quota cost:** 1 credit (0 if no events are found at the snapshot).
#' @param sport_key (*string*, required): The `sport_key` to look up events for.
#'  See [toa_sports()] for a full lookup of `sport_key` values.
#' @param date (*string*, required): The timestamp of the data snapshot to
#'  return, in ISO 8601 format (e.g. `2023-10-10T12:15:00Z`). The API returns
#'  the closest snapshot equal to or earlier than this value.
#' @param date_format (*string*, optional): Format of returned timestamps.
#'  Options are `iso` (default) or `unix`.
#' @param event_ids (*string*, optional): Comma-separated list of event ids to
#'  filter the response to. Defaults to `NULL` (all events).
#' @param commence_time_from (*string*, optional): Filter to events that
#'  commence on and after this ISO 8601 timestamp.
#' @param commence_time_to (*string*, optional): Filter to events that commence
#'  on and before this ISO 8601 timestamp.
#' @param include_rotation_numbers (*logical*, optional): If `TRUE`, include the
#'  `home_rotation` and `away_rotation` columns when available. Defaults to
#'  `FALSE`.
#' @return A tibble with one row per historical event:
#'
#'    |col_name           |types     |description                                          |
#'    |:------------------|:---------|:----------------------------------------------------|
#'    |timestamp          |character |Snapshot timestamp returned (closest at/before `date`). |
#'    |previous_timestamp |character |Preceding available snapshot; use as `date` to page back. |
#'    |next_timestamp     |character |Next available snapshot; use as `date` to page forward. |
#'    |id                 |character |Unique event id. Use as `event_id` elsewhere.        |
#'    |sport_key          |character |Sport key, e.g. `basketball_nba`.                    |
#'    |sport_title        |character |Human-readable sport title, e.g. `NBA`.              |
#'    |commence_time      |character |Event start time (ISO 8601 string or unix seconds).  |
#'    |home_team          |character |Home team name.                                      |
#'    |away_team          |character |Away team name.                                      |
#'    |home_rotation      |integer   |Home rotation number (only when `include_rotation_numbers = TRUE`). |
#'    |away_rotation      |integer   |Away rotation number (only when `include_rotation_numbers = TRUE`). |
#'
#' @keywords Events
#' @importFrom jsonlite fromJSON
#' @importFrom cli cli_alert_danger
#' @importFrom glue glue
#' @importFrom dplyr as_tibble mutate
#' @importFrom rlang .data
#' @export
#' @family The Odds API: Historical
#' @seealso [toa_event_odds_history()] to pull odds for a historical event by
#'   its `id`, [toa_sports_odds_history()] for featured-market odds at a
#'   historical snapshot, and [toa_sports_events()] for current events. Part of
#'   the \href{https://sportsdataverse.org/}{SportsDataverse}.
#' @examplesIf has_toa_key()
#' \donttest{
#'    try(toa_sports_events_history(sport_key = 'basketball_nba',
#'                                  date = '2024-01-15T12:15:00Z'))
#' }
toa_sports_events_history <- function(sport_key,
                                      date,
                                      date_format = 'iso',
                                      event_ids = NULL,
                                      commence_time_from = NULL,
                                      commence_time_to = NULL,
                                      include_rotation_numbers = FALSE){
  base_url <- glue::glue('https://api.the-odds-api.com/v4/historical/sports/{sport_key}/events')
  query_params <- list(
    apiKey = as.character(toa_key()),
    date = date,
    dateFormat = date_format,
    eventIds = event_ids,
    commenceTimeFrom = commence_time_from,
    commenceTimeTo = commence_time_to,
    includeRotationNumbers = if (isTRUE(include_rotation_numbers)) "true" else NULL
  )

  events_history <- data.frame()

  tryCatch(
    expr = {
      raw <- toa_api_call(base_url, query = query_params)
      events_history <- raw$data %>%
        dplyr::as_tibble() %>%
        dplyr::mutate(
          timestamp = raw$timestamp,
          previous_timestamp = raw$previous_timestamp,
          next_timestamp = raw$next_timestamp,
          .before = 1
        ) %>%
        make_toa_data("Historical Sports Events data from the-odds-api.com", Sys.time())
    },
    error = function(e) {
      cli::cli_alert_danger("{Sys.time()}: Invalid arguments or no historical events available for {sport_key} at {date}!")
      cli::cli_alert_danger("Error:\n{e}")
    },
    warning = function(w) {
      cli::cli_alert_warning("{Sys.time()}: Warning:\n{w}")
    },
    finally = {
    }
  )
  return(events_history)
}
