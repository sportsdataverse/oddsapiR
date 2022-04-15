#' @name toa_sports_scores
#' @title
#' **Find scores for the sports which are accessible through the Odds API**
#' @description
#' **Get the scores for the sports which the Odds API provides coverage**
#' ```r
#'    try(toa_sports_scores(sport_key = 'baseball_mlb', 
#'                          days_from = NULL,
#'                          date_format = 'iso'))
#' ```
#' @param sport_key (*string*, required): The `sport_key` to look up odds for. See ```toa_sports()``` for a full lookup of `sport_key` values.
#' @param days_from (*integer*, optional): Integer from 1 to 3. Defaults to 1.
#' @param date_format (*string*, optional): Date format. Options include:
#'  * iso
#'  * unix
#' @return Sports scores which The Odds API provides scores information for as a tibble:
#'  
#'    |col_name      |types     |
#'    |:-------------|:---------|
#'    |id            |character |
#'    |sport_key     |character |
#'    |sport_title   |character |
#'    |commence_time |character |
#'    |completed     |logical   |
#'    |home_team     |character |
#'    |away_team     |character |
#'    |scores        |logical   |
#'    |last_update   |logical   |
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
#'    try(toa_sports_scores(sport_key = 'baseball_mlb', 
#'                          days_from = NULL,
#'                          date_format = 'iso'))
#' }
#' 
toa_sports_scores <- function(sport_key, 
                              days_from = 1, 
                              date_format = 'iso'){
  base_url = glue::glue('https://api.the-odds-api.com/v4/sports/{sport_key}/scores')
  query_params <- list(
    apiKey = as.character(toa_key()),
    daysFrom = days_from,
    dateFormat = date_format
  )
  
  toa_endpoint <- httr::modify_url(base_url, query = query_params)
  
  tryCatch(
    expr = {
      
      resp <- toa_endpoint %>% 
        toa_api_call() %>% 
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