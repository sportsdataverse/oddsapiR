#' @name toa_event_odds_history
#' @title
#' **Find historical odds for a single event through the Odds API**
#' @description
#' **Get bookmaker odds for a single event as they appeared at a point in time.**
#'
#' Like [toa_event_odds()] but for a historical snapshot: accepts any available
#' market key (including player props and alternate lines) and returns the odds
#' at the snapshot closest to (and at or before) the requested `date`. Look up a
#' historical `event_id` with [toa_sports_events_history()]. The returned
#' `timestamp`, `previous_timestamp` and `next_timestamp` columns let you page
#' through snapshots.
#'
#' Historical odds for additional markets are available from 2023-05-03 at
#' 5-minute intervals; featured markets reach back to June 2020 on paid plans.
#'
#' **Usage quota cost:** `[number of unique markets returned] x [number of
#' regions]` (the standard rate, not the 10x historical multiplier). Snapshots
#' with no data do not count against the quota.
#' @param sport_key (*string*, required): The `sport_key` to look up odds for.
#'  See [toa_sports()] for a full lookup of `sport_key` values.
#' @param event_id (*string*, required): The `event_id` to look up odds for.
#'  See [toa_sports_events_history()] for a full lookup of `event_id` values.
#' @param date (*string*, required): The timestamp of the data snapshot to
#'  return, in ISO 8601 format (e.g. `2023-10-10T12:15:00Z`). The API returns
#'  the closest snapshot equal to or earlier than this value.
#' @param regions (*string*, required): The region(s) to pull bookmakers from.
#'  Multiple can be specified if comma delimited. Options include:
#'  * `us`
#'  * `us2`
#'  * `uk`
#'  * `eu`
#'  * `au`
#' @param markets (*string*, optional): The markets to return. Multiple can be
#'  specified if comma delimited. In addition to `h2h`, `spreads`, `totals` and
#'  `outrights`, this endpoint accepts additional markets such as alternate
#'  lines and player props. See the
#'  [betting markets documentation](https://the-odds-api.com/sports-odds-data/betting-markets.html).
#' @param odds_format (*string*, optional): Format in which to return odds.
#'  Options are `decimal` (default) or `american`.
#' @param date_format (*string*, optional): Format of returned timestamps.
#'  Options are `iso` (default) or `unix`.
#' @param bookmakers (*string*, optional): Comma-separated list of bookmakers to
#'  be returned. If both `bookmakers` and `regions` are specified, `bookmakers`
#'  takes precedence. Every group of 10 bookmakers counts as 1 region against
#'  the usage quota.
#' @return A long-format tibble with one row per bookmaker market outcome:
#'
#'    |col_name              |types     |description                                              |
#'    |:---------------------|:---------|:--------------------------------------------------------|
#'    |timestamp             |character |Snapshot timestamp returned (closest at/before `date`).  |
#'    |previous_timestamp    |character |Preceding available snapshot; use as `date` to page back. |
#'    |next_timestamp        |character |Next available snapshot; use as `date` to page forward.  |
#'    |id                    |character |Unique event id (echoes `event_id`).                     |
#'    |sport_key             |character |Sport key, e.g. `basketball_nba`.                        |
#'    |sport_title           |character |Human-readable sport title, e.g. `NBA`.                  |
#'    |commence_time         |character |Game start time (ISO 8601 string or unix seconds).       |
#'    |home_team             |character |Home team name.                                          |
#'    |away_team             |character |Away team name.                                          |
#'    |bookmaker_key         |character |Bookmaker slug, e.g. `draftkings`.                       |
#'    |bookmaker             |character |Bookmaker display title, e.g. `DraftKings`.              |
#'    |bookmaker_last_update |character |When this bookmaker's odds were last updated.            |
#'    |market_key            |character |Market key, e.g. `player_points`.                        |
#'    |market_last_update    |character |When this market's odds were last updated.               |
#'    |outcomes_name         |character |Outcome label (team, `Over`/`Under`, player name, etc.). |
#'    |outcomes_description  |character |Outcome description (player name for props); absent for featured markets. |
#'    |outcomes_price        |numeric   |The price/odds for the outcome.                          |
#'    |outcomes_point        |numeric   |The handicap/total/prop line, when applicable.           |
#'
#' If the event exists at the requested snapshot but no bookmaker odds were
#' posted for the requested markets/regions, a zero-row tibble with the same
#' columns is returned.
#' @keywords Betting Lines
#' @importFrom jsonlite fromJSON
#' @importFrom cli cli_alert_danger
#' @importFrom glue glue
#' @importFrom dplyr rename
#' @importFrom rlang .data
#' @import tidyr
#' @export
#' @family The Odds API: Historical
#' @seealso [toa_sports_events_history()] to look up historical `event_id`
#'   values, [toa_sports_odds_history()] for featured-market odds across all
#'   events at a snapshot, and [toa_event_odds()] for current event odds. Part
#'   of the \href{https://sportsdataverse.org/}{SportsDataverse}.
#' @examplesIf has_toa_key()
#' \donttest{
#'    try(toa_event_odds_history(sport_key = 'basketball_nba',
#'                               event_id = '93af4b300a4c0dded909234ea32e9abd',
#'                               date = '2024-01-15T12:15:00Z',
#'                               regions = 'us',
#'                               markets = 'h2h',
#'                               odds_format = 'decimal',
#'                               date_format = 'iso'))
#' }
toa_event_odds_history <- function(sport_key,
                                   event_id,
                                   date,
                                   regions = 'us',
                                   markets = 'h2h',
                                   odds_format = 'decimal',
                                   date_format = 'iso',
                                   bookmakers = NULL){
  base_url <- glue::glue('https://api.the-odds-api.com/v4/historical/sports/{sport_key}/events/{event_id}/odds')
  query_params <- list(
    apiKey = as.character(toa_key()),
    date = date,
    regions = regions,
    markets = markets,
    oddsFormat = odds_format,
    dateFormat = date_format,
    bookmakers = bookmakers
  )

  event_odds_history <- data.frame()

  tryCatch(
    expr = {
      raw <- toa_api_call(base_url, query = query_params)
      event <- raw$data
      .toa_stop_if_error_payload(event, raw)
      # A valid snapshot can ship an empty bookmakers array (no lines were
      # posted at that timestamp for the requested markets/regions). Return a
      # typed zero-row tibble instead of falling through to the rename/unnest
      # error path (#4).
      if (length(event$bookmakers) == 0) {
        cli::cli_alert_info(
          "{Sys.time()}: Event {event_id} found at {date}, but no bookmaker odds were available for markets '{markets}' in regions '{regions}'.")
        event_odds_history <- .toa_empty_event_odds(history = TRUE) %>%
          make_toa_data("Historical Event Odds data from the-odds-api.com", Sys.time())
        return(event_odds_history)
      }
      event_odds_history <- tibble::tibble(
        timestamp = raw$timestamp,
        previous_timestamp = raw$previous_timestamp,
        next_timestamp = raw$next_timestamp,
        id = event$id,
        sport_key = event$sport_key,
        sport_title = event$sport_title,
        commence_time = event$commence_time,
        home_team = event$home_team,
        away_team = event$away_team,
        bookmakers = list(event$bookmakers)
      ) %>%
        tidyr::unnest("bookmakers") %>%
        dplyr::rename(
          "bookmaker_key" = "key",
          "bookmaker" = "title",
          "bookmaker_last_update" = "last_update") %>%
        tidyr::unnest("markets") %>%
        dplyr::rename(
          "market_key" = "key",
          "market_last_update" = "last_update") %>%
        tidyr::unnest("outcomes", names_sep = "_") %>%
        make_toa_data("Historical Event Odds data from the-odds-api.com", Sys.time())
    },
    error = function(e) {
      cli::cli_alert_danger("{Sys.time()}: Invalid arguments or no historical odds available for event {event_id} at {date}!")
      cli::cli_alert_danger("Error:\n{e}")
    },
    warning = function(w) {
      cli::cli_alert_warning("{Sys.time()}: Warning:\n{w}")
    },
    finally = {
    }
  )
  return(event_odds_history)
}
