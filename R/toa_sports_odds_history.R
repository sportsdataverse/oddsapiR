#' @name toa_sports_odds_history
#' @title
#' **Find historical featured-market odds through the Odds API**
#' @description
#' **Get historical featured-market odds for a sport which The Odds API covers.**
#'
#' Returns the list of events and featured bookmaker odds (`h2h`, `spreads`,
#' `totals`) as they appeared at the snapshot closest to (and at or before) the
#' requested `date`. The response is wrapped in a snapshot envelope; the
#' returned `timestamp`, `previous_timestamp` and `next_timestamp` columns let
#' you page backward/forward in time. This endpoint was previously
#' `/v4/sports/{sport}/odds-history`, which has been deprecated in favour of
#' `/v4/historical/sports/{sport}/odds`.
#'
#' Historical data is available on paid usage plans from June 2020.
#'
#' **Usage quota cost:** `10 x [number of markets] x [number of regions]`.
#' Snapshots with no events do not count against the quota.
#' @param sport_key (*string*, required): The `sport_key` to look up odds for.
#'  See [toa_sports()] for a full lookup of `sport_key` values.
#' @param date (*string*, required): The timestamp of the data snapshot to
#'  return, in ISO 8601 format (e.g. `2023-03-18T12:15:00Z`). The API returns
#'  the closest snapshot equal to or earlier than this value.
#' @param regions (*string*, required): The region(s) to pull bookmakers from.
#'  Multiple can be specified if comma delimited. Options include:
#'  * `us`
#'  * `us2`
#'  * `uk`
#'  * `eu`
#'  * `au`
#' @param markets (*string*, optional): The featured markets to return. Multiple
#'  can be specified if comma delimited. Options include `h2h`, `spreads`,
#'  `totals`.
#' @param odds_format (*string*, optional): Format in which to return odds.
#'  Options are `decimal` (default) or `american`.
#' @param date_format (*string*, optional): Format of returned timestamps.
#'  Options are `iso` (default) or `unix`.
#' @param event_ids (*string*, optional): Comma-separated list of event ids to
#'  filter the snapshot to. Defaults to `NULL` (all events).
#' @param bookmakers (*string*, optional): Comma-separated list of bookmakers to
#'  be returned. If both `bookmakers` and `regions` are specified, `bookmakers`
#'  takes precedence. Every group of 10 bookmakers counts as 1 region against
#'  the usage quota.
#' @return A long-format tibble with one row per bookmaker market outcome:
#'
#'    |col_name              |types     |description                                       |
#'    |:---------------------|:---------|:-------------------------------------------------|
#'    |timestamp             |character |Snapshot timestamp returned (closest at/before `date`). |
#'    |previous_timestamp    |character |Preceding available snapshot; use as `date` to page back. |
#'    |next_timestamp        |character |Next available snapshot; use as `date` to page forward. |
#'    |id                    |character |Unique event id.                                  |
#'    |sport_key             |character |Sport key, e.g. `basketball_nba`.                 |
#'    |sport_title           |character |Human-readable sport title, e.g. `NBA`.           |
#'    |commence_time         |character |Game start time (ISO 8601 string or unix seconds).|
#'    |home_team             |character |Home team name.                                   |
#'    |away_team             |character |Away team name.                                   |
#'    |bookmaker_key         |character |Bookmaker slug, e.g. `draftkings`.                |
#'    |bookmaker             |character |Bookmaker display title, e.g. `DraftKings`.       |
#'    |bookmaker_last_update |character |When this bookmaker's odds were last updated.     |
#'    |market_key            |character |Market key, e.g. `spreads`.                       |
#'    |market_last_update    |character |When this market's odds were last updated.        |
#'    |outcomes_name         |character |Outcome label (team name, `Over`/`Under`, etc.).  |
#'    |outcomes_price        |numeric   |The price/odds for the outcome.                   |
#'    |outcomes_point        |numeric   |The handicap/total line (`spreads`/`totals` only).|
#'
#' @keywords Betting Lines
#' @importFrom jsonlite fromJSON
#' @importFrom cli cli_alert_danger
#' @importFrom glue glue
#' @importFrom dplyr rename mutate as_tibble
#' @importFrom rlang .data
#' @import tidyr
#' @export
#' @family The Odds API: Historical
#' @seealso [toa_event_odds_history()] for historical odds on a single event
#'   (including player props), [toa_sports_events_history()] to list events at a
#'   historical snapshot, and [toa_sports_odds()] for current featured-market
#'   odds. Part of the \href{https://sportsdataverse.org/}{SportsDataverse}.
#' @examplesIf has_toa_key()
#' \donttest{
#'    try(toa_sports_odds_history(sport_key = 'basketball_nba',
#'                                date = '2024-01-15T12:15:00Z',
#'                                regions = 'us',
#'                                markets = 'spreads',
#'                                odds_format = 'decimal',
#'                                date_format = 'iso'))
#' }
toa_sports_odds_history <- function(sport_key,
                                    date,
                                    regions = 'us',
                                    markets = 'spreads',
                                    odds_format = 'decimal',
                                    date_format = 'iso',
                                    event_ids = NULL,
                                    bookmakers = NULL){
  base_url <- glue::glue('https://api.the-odds-api.com/v4/historical/sports/{sport_key}/odds')
  query_params <- list(
    apiKey = as.character(toa_key()),
    date = date,
    regions = regions,
    markets = markets,
    oddsFormat = odds_format,
    dateFormat = date_format,
    eventIds = event_ids,
    bookmakers = bookmakers
  )

  odds_history <- data.frame()

  tryCatch(
    expr = {
      raw <- toa_api_call(base_url, query = query_params)
      odds_history <- raw$data %>%
        dplyr::as_tibble() %>%
        dplyr::mutate(
          timestamp = raw$timestamp,
          previous_timestamp = raw$previous_timestamp,
          next_timestamp = raw$next_timestamp,
          .before = 1
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
        make_toa_data("Historical Sports Odds data from the-odds-api.com", Sys.time())
    },
    error = function(e) {
      cli::cli_alert_danger("{Sys.time()}: Invalid arguments or no historical odds available for {sport_key} at {date}!")
      cli::cli_alert_danger("Error:\n{e}")
    },
    warning = function(w) {
      cli::cli_alert_warning("{Sys.time()}: Warning:\n{w}")
    },
    finally = {
    }
  )
  return(odds_history)
}
