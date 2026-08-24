#' @name toa_event_odds
#' @title
#' **Find odds for a single event, including player props and other markets**
#' @description
#' **Get bookmaker odds for a single event from The Odds API.**
#'
#' Unlike [toa_sports_odds()] (featured markets only), this endpoint accepts any
#' available market key, including player props and alternate lines. Look up an
#' `event_id` with [toa_sports_events()].
#'
#' **Usage quota cost:** `[number of unique markets returned] x [number of regions]`.
#' @param sport_key (*string*, required): The `sport_key` to look up odds for.
#'  See [toa_sports()] for a full lookup of `sport_key` values.
#' @param event_id (*string*, required): The `event_id` to look up odds for.
#'  See [toa_sports_events()] for a full lookup of `event_id` values.
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
#'  lines and player props (e.g. `player_points`, `player_pass_tds`,
#'  `player_shots_on_goal`). See the
#'  [betting markets documentation](https://the-odds-api.com/sports-odds-data/betting-markets.html)
#'  for the full list.
#' @param odds_format (*string*, optional): Format in which to return odds.
#'  Options are `decimal` (default) or `american`.
#' @param date_format (*string*, optional): Format of returned timestamps.
#'  Options are `iso` (default) or `unix`.
#' @param bookmakers (*string*, optional): Comma-separated list of bookmakers to
#'  be returned. If both `bookmakers` and `regions` are specified, `bookmakers`
#'  takes precedence. Bookmakers can be from any region. Every group of 10
#'  bookmakers counts as 1 region against the usage quota.
#' @return A long-format tibble with one row per bookmaker market outcome:
#'
#'    |col_name             |types     |description                                              |
#'    |:--------------------|:---------|:--------------------------------------------------------|
#'    |id                   |character |Unique event id (echoes `event_id`).                     |
#'    |sport_key            |character |Sport key, e.g. `basketball_nba`.                        |
#'    |sport_title          |character |Human-readable sport title, e.g. `NBA`.                  |
#'    |commence_time        |character |Game start time (ISO 8601 string or unix seconds).       |
#'    |home_team            |character |Home team name.                                          |
#'    |away_team            |character |Away team name.                                          |
#'    |bookmaker_key        |character |Bookmaker slug, e.g. `draftkings`.                       |
#'    |bookmaker            |character |Bookmaker display title, e.g. `DraftKings`.              |
#'    |market_key           |character |Market key, e.g. `player_points`.                        |
#'    |market_last_update   |character |When this market's odds were last updated.               |
#'    |outcomes_name        |character |Outcome label (team, `Over`/`Under`, player name, etc.). |
#'    |outcomes_description |character |Outcome description (player name for props); absent for featured markets. |
#'    |outcomes_price       |numeric   |The price/odds for the outcome.                          |
#'    |outcomes_point       |numeric   |The handicap/total/prop line, when applicable.           |
#'
#' If the event exists but no bookmaker odds are posted yet for the requested
#' markets/regions, a zero-row tibble with the same columns is returned.
#' @keywords Betting Lines
#' @importFrom jsonlite fromJSON
#' @importFrom cli cli_alert_danger
#' @importFrom glue glue
#' @importFrom dplyr rename
#' @importFrom rlang .data
#' @import tidyr
#' @export
#' @family The Odds API: Odds & Markets
#' @seealso [toa_sports_odds()] for featured-market odds across all upcoming
#'   events, [toa_event_markets()] to discover available market keys for an
#'   event, and [toa_sports_events()] to look up `event_id` values. Part of
#'   the \href{https://sportsdataverse.org/}{SportsDataverse}.
#' @examples \donttest{
#'    try(toa_event_odds(sport_key = 'basketball_nba',
#'                       event_id = '48db9c3293a52baab881d95d38f37a98',
#'                       regions = 'us',
#'                       markets = 'player_points',
#'                       odds_format = 'decimal',
#'                       date_format = 'iso'))
#' }
toa_event_odds <- function(sport_key,
                           event_id,
                           regions = 'us',
                           markets = 'spreads',
                           odds_format = 'decimal',
                           date_format = 'iso',
                           bookmakers = NULL){
  base_url <- glue::glue('https://api.the-odds-api.com/v4/sports/{sport_key}/events/{event_id}/odds')
  query_params <- list(
    apiKey = as.character(toa_key()),
    regions = regions,
    markets = markets,
    oddsFormat = odds_format,
    dateFormat = date_format,
    bookmakers = bookmakers
  )

  event_odds <- data.frame()

  tryCatch(
    expr = {
      raw <- toa_api_call(base_url, query = query_params)
      # A valid event can ship an empty bookmakers array (no lines posted yet
      # for the requested markets/regions). Return a typed zero-row tibble
      # instead of falling through to the rename/unnest error path (#4).
      if (length(raw$bookmakers) == 0) {
        cli::cli_alert_info(
          "{Sys.time()}: Event {event_id} found, but no bookmaker odds are available yet for markets '{markets}' in regions '{regions}'.")
        event_odds <- .toa_empty_event_odds() %>%
          make_toa_data("Event Odds data from the-odds-api.com", Sys.time())
        return(event_odds)
      }
      event_odds <- tibble::tibble(
        id = raw$id,
        sport_key = raw$sport_key,
        sport_title = raw$sport_title,
        commence_time = raw$commence_time,
        home_team = raw$home_team,
        away_team = raw$away_team,
        bookmakers = list(raw$bookmakers)
      ) %>%
        tidyr::unnest("bookmakers") %>%
        dplyr::rename(
          "bookmaker_key" = "key",
          "bookmaker" = "title") %>%
        tidyr::unnest("markets") %>%
        dplyr::rename(
          "market_key" = "key",
          "market_last_update" = "last_update") %>%
        tidyr::unnest("outcomes", names_sep = "_") %>%
        make_toa_data("Event Odds data from the-odds-api.com", Sys.time())
    },
    error = function(e) {
      cli::cli_alert_danger("{Sys.time()}: Invalid arguments or no odds data available for event {event_id}!")
      cli::cli_alert_danger("Error:\n{e}")
    },
    warning = function(w) {
      cli::cli_alert_warning("{Sys.time()}: Warning:\n{w}")
    },
    finally = {
    }
  )
  return(event_odds)
}
