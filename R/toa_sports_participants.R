#' @name toa_sports_participants
#' @title
#' **Find the participants (teams or players) for a sport through the Odds API**
#' @description
#' **Get the list of participants for a sport.**
#'
#' Depending on the sport a participant is either a team (e.g. NBA) or an
#' individual (e.g. tennis). The list is a whitelist used to define events and
#' may include participants that are no longer active. This endpoint does not
#' return individual players on a team.
#'
#' **Usage quota cost:** 1 credit.
#' @param sport_key (*string*, required): The `sport_key` to look up participants
#'  for. See [toa_sports()] for a full lookup of `sport_key` values.
#' @return A tibble with one row per participant:
#'
#'    |col_name  |types     |description                                        |
#'    |:---------|:---------|:--------------------------------------------------|
#'    |sport_key |character |Sport key the participants belong to (echoes the `sport_key` argument). |
#'    |id        |character |Unique participant id, e.g. `par_01hqmkq6fdf1pvq7jgdd7hdmpf`. |
#'    |full_name |character |Participant name -- a team name or player name depending on the sport. |
#'
#' @keywords Participants
#' @importFrom jsonlite fromJSON
#' @importFrom cli cli_alert_danger
#' @importFrom glue glue
#' @importFrom dplyr as_tibble mutate select any_of
#' @importFrom rlang .data .env
#' @export
#' @family The Odds API: Sports & Events
#' @seealso [toa_sports()] to discover `sport_key` values, [toa_sports_events()]
#'   to list upcoming events, and [toa_sports_scores()] for live/recent scores.
#'   Part of the \href{https://sportsdataverse.org/}{SportsDataverse}.
#' @examples \donttest{
#'    try(toa_sports_participants(sport_key = 'basketball_nba'))
#' }
toa_sports_participants <- function(sport_key){
  base_url <- glue::glue('https://api.the-odds-api.com/v4/sports/{sport_key}/participants')
  query_params <- list(
    apiKey = as.character(toa_key())
  )

  participants <- data.frame()

  tryCatch(
    expr = {
      participants <- toa_api_call(base_url, query = query_params) %>%
        dplyr::as_tibble() %>%
        dplyr::mutate(sport_key = .env$sport_key, .before = 1) %>%
        dplyr::select(dplyr::any_of(c("sport_key", "id", "full_name"))) %>%
        make_toa_data("Sports Participants data from the-odds-api.com", Sys.time())
    },
    error = function(e) {
      cli::cli_alert_danger("{Sys.time()}: Invalid arguments or no participants data available for {sport_key}!")
      cli::cli_alert_danger("Error:\n{e}")
    },
    warning = function(w) {
      cli::cli_alert_warning("{Sys.time()}: Warning:\n{w}")
    },
    finally = {
    }
  )
  return(participants)
}
