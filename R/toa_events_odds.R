#' @name toa_event_odds
#' @title
#' **Find odds for the sports which are accessible through the Odds API**
#' @description
#' **Get the odds for the sports which the Odds API provides coverage**
#' ```r
#'    try(toa_sports_odds(sport_key = 'baseball_mlb', 
#'                        regions = 'us', 
#'                        markets = 'spreads', 
#'                        odds_format = 'decimal',
#'                        date_format = 'iso'))
#' ```
#' @param sport_key The `sport_key` to look up odds for. See ```toa_sports()``` for a full lookup of `sport_key` values.
#' @param event_id The `event_id` to look up odds for. See ```toa_sports_odds()``` for a full lookup of `event_id` values.
#' @param regions The region to pull odds from. Options include: 
#'  * us  
#'  * uk
#'  * us 
#'  * eu 
#'  * au 
#' Multiple can be specified if comma delimited.
#' @param markets The type of odds to return. Multiple can be specified if comma delimited. Options include:
#'  * h2h
#'  * spreads
#'  * totals
#'  * outrights
#'  * h2h_lay
#'  * outrights_lay
#'  * alternate_spreads
#'  * alternate_totals
#'  * btts
#'  * draw_no_bet
#'  * h2h_3_way
#'  
#'  NFL Player Props:
#'   * player_pass_tds
#'   * player_pass_yds
#'   * player_pass_completions
#'   * player_pass_attempts
#'   * player_pass_interceptions
#'   * player_pass_longest_completion
#'   * player_rush_yds
#'   * player_rush_attempts
#'   * player_rush_longest
#'   * player_receptions
#'   * player_reception_yds
#'   * player_reception_longest
#'   
#'  NBA + NCAAB Player Props:
#'   * player_points
#'   * player_rebounds
#'   * player_assists
#'   * player_threes
#'   * player_double_double
#'   * player_blocks
#'   * player_steals
#'   * player_turnovers
#'   * player_points_rebounds_assists
#'   * player_points_rebounds
#'   * player_points_assists
#'   * player_rebounds_assists
#' 
#'  NHL Player Props:
#'    * player_points
#'    * player_power_play_points
#'    * player_assists
#'    * player_blocked_shots
#'    * player_shots_on_goal
#'  
#'  [Player Props Documentation](https://the-odds-api.com/sports-odds-data/betting-markets.html#player-props-api-markets)
#' @param odds_format The format in which to return odds. Options include: 
#'  * decimal
#'  * american
#' @param date_format Date format. Options include:
#'  * iso
#'  * unix
#' @param bookmakers Comma-separated list of bookmakers to be returned. If both bookmakers and
#'  regions are specified, bookmakers takes precendence. Bookmakers can be from any region. 
#'  Every group of 10 bookmakers counts as 1 request. For example for a single market, 
#'  specifying up to 10 bookmakers counts as 1 request. 
#'  Specifying between 11 and 20 bookmakers counts as 2 requests
#' @return Sports for which The Odds API provides betting information for as a tibble:
#'  
#'    |col_name       |types     |
#'    |:--------------|:---------|
#'    |id             |character |
#'    |sport_key      |character |
#'    |sport_title    |character |
#'    |commence_time  |character |
#'    |home_team      |character |
#'    |away_team      |character |
#'    |bookmaker_key  |character |
#'    |bookmaker      |character |
#'    |last_update    |character |
#'    |market_key     |character |
#'    |outcomes_name  |character |
#'    |outcomes_price |numeric   |
#'    |outcomes_point |numeric   |
#'    
#' @keywords Betting Lines
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY modify_url
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @importFrom dplyr rename
#' @importFrom rlang .data
#' @import tidyr
#' @export
#' @details 
#' ```r
#'    try(toa_event_odds(sport_key = 'basketball_ncaab', 
#'                       event_id = '48db9c3293a52baab881d95d38f37a98',
#'                       regions = 'us', 
#'                       markets = 'player_points', 
#'                       odds_format = 'decimal',
#'                       date_format = 'iso'))
#' ```
#' 
toa_event_odds <- function(sport_key, 
                           event_id,
                           regions = 'us', 
                           markets = 'spreads', 
                           odds_format = 'decimal', 
                           date_format = 'iso',
                           bookmakers = NULL){
  base_url = glue::glue('https://api.the-odds-api.com/v4/sports/{sport_key}/events/{event_id}/odds')
  query_params <- list(
    apiKey = as.character(toa_key()),
    regions = regions,
    markets = markets,
    oddsFormat = odds_format,
    dateFormat = date_format,
    bookmakers = bookmakers
  )
  
  toa_endpoint <- httr::modify_url(base_url, query = query_params)
  
  tryCatch(
    expr = {
      
      resp <- toa_endpoint %>% 
        toa_api_call() %>%
        dplyr::as_tibble(data = ".") %>% 
        tidyr::unnest("bookmakers") %>% 
        dplyr::rename(
          "bookmaker_key" = "key",
          "bookmaker" = "title") %>% 
        tidyr::unnest("markets") %>%
        dplyr::rename("market_key" = "key",
                      "market_last_update" = "last_update") %>% 
        tidyr::unnest("outcomes", names_sep = "_") %>% 
        make_toa_data("Sports Odds data from the-odds-api.com", Sys.time())
      
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments provided"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(resp)
}