#' @name toa_sports
#' @title
#' **Find sports for which odds are accessible through the Odds API**
#' @description
#' **Get the Sports for which the Odds API provides coverage**
#' ```r
#'  toa_sports(all_sports=TRUE)
#' ```
#' @param all_sports (*Logical* required): If true, returns all sports and if false, returns only active sports. Defaults to true.
#' @return Sports for which The Odds API provides betting information for as a tibble:
#'   
#'    |col_name      |types     |
#'    |:-------------|:---------|
#'    |key           |character |
#'    |group         |character |
#'    |title         |character |
#'    |description   |character |
#'    |active        |logical   |
#'    |has_outrights |logical   |
#'   
#' @keywords Betting Lines
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY modify_url
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @importFrom tidyr unnest
#' @importFrom rlang .data
#' @export
#' @examples \donttest{
#'   try(toa_sports(all_sports = TRUE))
#' }
#' 
toa_sports <- function(all_sports=TRUE){
  base_url = glue::glue('https://api.the-odds-api.com/v4/sports')
  query_params <- list(
    apiKey = as.character(toa_key()),
    all = ifelse(is.logical(all_sports),tolower(as.character(all_sports)), all_sports)
  )
  
  toa_endpoint <- httr::modify_url(base_url, query = query_params)
  
  tryCatch(
    expr = {
      
      resp <- toa_endpoint %>% 
        toa_api_call() %>%
        make_toa_data("Sports coverage data from the-odds-api.com", Sys.time())
      
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