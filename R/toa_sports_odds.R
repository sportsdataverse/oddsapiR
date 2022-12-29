#' @name toa_sports_odds
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
#' @param odds_format The format in which to return odds. Options include: 
#'  * decimal
#'  * american
#' @param date_format Date format. Options include:
#'  * iso
#'  * unix
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
#' @importFrom tidyr unnest
#' @importFrom rlang .data
#' @export
#' @examples \donttest{
#'    try(toa_sports_odds(sport_key = 'basketball_nba', 
#'                        regions = 'us', 
#'                        markets = 'spreads', 
#'                        odds_format = 'decimal',
#'                        date_format = 'iso'))
#' }
#' 
toa_sports_odds <- function(sport_key, 
                            regions='us', 
                            markets = 'spreads', 
                            odds_format = 'decimal', 
                            date_format = 'iso'){
  base_url = glue::glue('https://api.the-odds-api.com/v4/sports/{sport_key}/odds')
  query_params <- list(
    apiKey = as.character(toa_key()),
    regions = regions,
    markets = markets,
    oddsFormat = odds_format,
    dateFormat = date_format
  )
  
  toa_endpoint <- httr::modify_url(base_url, query = query_params)
  
  tryCatch(
    expr = {
      
      resp <- toa_endpoint %>% 
        toa_api_call() %>% 
        tidyr::unnest("bookmakers") %>% 
        dplyr::rename(
          "bookmaker_key" = "key",
          "bookmaker" = "title",
          "bookmaker_last_update" = "last_update") %>% 
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