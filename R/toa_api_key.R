#' @title 
#' **Odds API Key Registration**
#' @description Save your API Key as a system environment variable `ODDS_API_KEY`
#' @details To get access to an API key, follow the instructions at [https://the-odds-api.com](https://the-odds-api.com "Key Registration")\cr
#' \cr
#' **Using the key:** \cr
#' You can save the key for consistent usage by adding `ODDS_API_KEY=XXXX-YOUR-API-KEY-HERE-XXXXX` to your .Renviron file (easily accessed via [**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html)). \cr
#' Run [**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html), 
#' a new script will pop open named `.Renviron`, **THEN** \cr
#' paste the following in the new script that pops up (with**out** quotations)
#' ```r
#' ODDS_API_KEY = XXXX-YOUR-API-KEY-HERE-XXXXX
#' ```
#' Save the script and restart your RStudio session, by clicking `Session` (in between `Plots` and `Build`) and click `Restart R` \cr
#' (there also exists the shortcut `Ctrl + Shift + F10` to restart your session). 
#' 
#' If set correctly, from then on you should be able to use any of the `toa_` functions without any other changes.
#' 
#' **For less consistent usage:** \cr
#' At the beginning of every session or within an R environment, 
#' save your API key as the environment variable `ODDS_API_KEY` (**with** quotations) 
#' using a command like the following.
#' ```r
#' Sys.setenv(ODDS_API_KEY = "XXXX-YOUR-API-KEY-HERE-XXXXX")
#' ```
#' @name register_toa
NULL
#' @rdname register_toa
#' @return Called as a side-effect to ensure that a user has an API key stored in their environment
#' before making a call to the Odds API service.
#' @export
toa_key <- function() {
  key <- Sys.getenv("ODDS_API_KEY")
  
  if (key == "") {
    return(NA_character_)
  } else {
    return(key)
  }
}

#' @rdname register_toa
#' @export
has_toa_key <- function() !is.na(toa_key())


#' @rdname register_toa
#' @export
check_toa_key <- function(){
  # Check for The Odds API key
  if (!has_toa_key()) stop("the-odds-api.com requires an API key.", "\n       See ?register_toa for details.", call. = FALSE)
}