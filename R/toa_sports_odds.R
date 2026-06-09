#' @name toa_sports_odds
#' @title
#' **Find odds for the sports which are accessible through the Odds API**
#' @description
#' **Get the featured-market odds for a sport which The Odds API covers.**
#'
#' Returns a list of upcoming and live games with featured bookmaker odds for
#' the specified markets and regions. For player props and other additional
#' markets, use [toa_event_odds()] instead.
#'
#' **Usage quota cost:** `[number of markets] x [number of regions]`.
#' @param sport_key (*string*, required): The `sport_key` to look up odds for.
#'  See [toa_sports()] for a full lookup of `sport_key` values.
#' @param regions (*string*, required): The region(s) to pull bookmakers from.
#'  Multiple can be specified if comma delimited. Options include:
#'  * `us`
#'  * `us2`
#'  * `uk`
#'  * `eu`
#'  * `au`
#' @param markets (*string*, optional): The featured markets to return. Multiple
#'  can be specified if comma delimited. Options include:
#'  * `h2h` (moneyline)
#'  * `spreads` (points handicaps)
#'  * `totals` (over/under)
#'  * `outrights` (futures, select sports only)
#' @param odds_format (*string*, optional): Format in which to return odds.
#'  Options are `decimal` (default) or `american`.
#' @param date_format (*string*, optional): Format of returned timestamps.
#'  Options are `iso` (default) or `unix`.
#' @return A long-format tibble with one row per bookmaker market outcome:
#'
#'    |col_name              |types     |description                                       |
#'    |:---------------------|:---------|:-------------------------------------------------|
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
#'    |outcomes_point        |numeric   |The handicap/total line, when applicable.         |
#'
#' @keywords Betting Lines
#' @importFrom jsonlite fromJSON
#' @importFrom cli cli_alert_danger
#' @importFrom glue glue
#' @importFrom dplyr rename
#' @importFrom rlang .data
#' @import tidyr
#' @export
#' @examples \donttest{
#'    try(toa_sports_odds(sport_key = 'basketball_nba',
#'                        regions = 'us',
#'                        markets = 'spreads',
#'                        odds_format = 'decimal',
#'                        date_format = 'iso'))
#' }
toa_sports_odds <- function(sport_key,
                            regions = 'us',
                            markets = 'spreads',
                            odds_format = 'decimal',
                            date_format = 'iso'){
  base_url <- glue::glue('https://api.the-odds-api.com/v4/sports/{sport_key}/odds')
  query_params <- list(
    apiKey = as.character(toa_key()),
    regions = regions,
    markets = markets,
    oddsFormat = odds_format,
    dateFormat = date_format
  )

  odds <- data.frame()

  tryCatch(
    expr = {
      odds <- toa_api_call(base_url, query = query_params) %>%
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
        make_toa_data("Sports Odds data from the-odds-api.com", Sys.time())
    },
    error = function(e) {
      cli::cli_alert_danger("{Sys.time()}: Invalid arguments or no odds data available for {sport_key}!")
      cli::cli_alert_danger("Error:\n{e}")
    },
    warning = function(w) {
      cli::cli_alert_warning("{Sys.time()}: Warning:\n{w}")
    },
    finally = {
    }
  )
  return(odds)
}
