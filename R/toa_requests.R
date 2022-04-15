#' @name toa_requests
#' @title
#' **Find out your usage and remaining calls for your key from The Odds API**
#' @description
#' **Get your usage and remaining calls for your key from The Odds API**
#' ```
#'  toa_requests()
#' ```
#' @return Returns a tibble of The Odds API key usage with the following columns:
#'   
#'    |col_name           |types   |
#'    |:------------------|:-------|
#'    |requests_remaining |integer |
#'    |requests_used      |integer |
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
#' 
toa_requests <- function(){
  base_url = glue::glue('https://api.the-odds-api.com/v4/sports')
  query_params <- list(
    apiKey = as.character(toa_key()),
    all = 'true'
  )
  
  toa_endpoint <- httr::modify_url(base_url, query = query_params)
  
  tryCatch(
    expr = {
      
      resp <- toa_endpoint %>% 
        toa_api_headers() %>% 
        make_toa_data("API Key Usage data from the-odds-api.com", Sys.time())
      
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