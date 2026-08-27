#' @name toa_event_markets
#' @title
#' **Find the available market keys for a single event through the Odds API**
#' @description
#' **Get the available market keys for each bookmaker for a single event.**
#'
#' Returns the recently seen market keys per bookmaker for an event (no odds).
#' This is not a comprehensive list of all supported markets -- more keys are
#' returned as bookmakers open more markets approaching commence time. Use the
#' returned `market_key` values to request odds via [toa_event_odds()].
#'
#' **Usage quota cost:** 1 credit.
#' @param sport_key (*string*, required): The `sport_key` to look up markets for.
#'  See [toa_sports()] for a full lookup of `sport_key` values.
#' @param event_id (*string*, required): The `event_id` to look up markets for.
#'  See [toa_sports_events()] for a full lookup of `event_id` values.
#' @param regions (*string*, required): The region(s) that determine which
#'  bookmakers appear. Multiple can be specified if comma delimited. Options
#'  include:
#'  * `us`
#'  * `us2`
#'  * `uk`
#'  * `eu`
#'  * `au`
#' @param bookmakers (*string*, optional): Comma-separated list of bookmakers to
#'  be returned. If both `bookmakers` and `regions` are specified, `bookmakers`
#'  takes precedence.
#' @param date_format (*string*, optional): Format of returned timestamps.
#'  Options are `iso` (default) or `unix`.
#' @return A tibble with one row per bookmaker market available for the event:
#'
#'    |col_name           |types     |description                                       |
#'    |:------------------|:---------|:-------------------------------------------------|
#'    |id                 |character |Unique event id (echoes `event_id`).              |
#'    |sport_key          |character |Sport key, e.g. `basketball_nba`.                 |
#'    |sport_title        |character |Human-readable sport title, e.g. `NBA`.           |
#'    |commence_time      |character |Event start time (ISO 8601 string or unix seconds).|
#'    |home_team          |character |Home team name.                                   |
#'    |away_team          |character |Away team name.                                   |
#'    |bookmaker_key      |character |Bookmaker slug, e.g. `draftkings`.                |
#'    |bookmaker          |character |Bookmaker display title, e.g. `DraftKings`.       |
#'    |market_key         |character |Available market key, e.g. `player_points`.       |
#'    |market_last_update |character |When this market was last seen for the bookmaker. |
#'
#' @keywords Markets
#' @importFrom jsonlite fromJSON
#' @importFrom cli cli_alert_danger
#' @importFrom glue glue
#' @importFrom dplyr rename
#' @importFrom rlang .data
#' @import tidyr
#' @export
#' @family The Odds API: Odds & Markets
#' @seealso [toa_event_odds()] to pull odds for the market keys discovered here,
#'   [toa_sports_odds()] for featured-market odds across all events, and
#'   [toa_sports_events()] to look up `event_id` values. Part of the
#'   \href{https://sportsdataverse.org/}{SportsDataverse}.
#' @examplesIf has_toa_key()
#' \donttest{
#'    try(toa_event_markets(sport_key = 'basketball_nba',
#'                          event_id = '48db9c3293a52baab881d95d38f37a98',
#'                          regions = 'us'))
#' }
toa_event_markets <- function(sport_key,
                              event_id,
                              regions = 'us',
                              bookmakers = NULL,
                              date_format = 'iso'){
  base_url <- glue::glue('https://api.the-odds-api.com/v4/sports/{sport_key}/events/{event_id}/markets')
  query_params <- list(
    apiKey = as.character(toa_key()),
    regions = regions,
    bookmakers = bookmakers,
    dateFormat = date_format
  )

  event_markets <- data.frame()

  tryCatch(
    expr = {
      raw <- toa_api_call(base_url, query = query_params)
      event_markets <- tibble::tibble(
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
        make_toa_data("Event Markets data from the-odds-api.com", Sys.time())
    },
    error = function(e) {
      cli::cli_alert_danger("{Sys.time()}: Invalid arguments or no markets data available for event {event_id}!")
      cli::cli_alert_danger("Error:\n{e}")
    },
    warning = function(w) {
      cli::cli_alert_warning("{Sys.time()}: Warning:\n{w}")
    },
    finally = {
    }
  )
  return(event_markets)
}
