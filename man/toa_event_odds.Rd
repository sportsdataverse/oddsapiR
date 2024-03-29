% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/toa_events_odds.R
\name{toa_event_odds}
\alias{toa_event_odds}
\title{\strong{Find odds for the sports which are accessible through the Odds API}}
\usage{
toa_event_odds(
  sport_key,
  event_id,
  regions = "us",
  markets = "spreads",
  odds_format = "decimal",
  date_format = "iso",
  bookmakers = NULL
)
}
\arguments{
\item{sport_key}{The \code{sport_key} to look up odds for. See \code{toa_sports()} for a full lookup of \code{sport_key} values.}

\item{event_id}{The \code{event_id} to look up odds for. See \code{toa_sports_odds()} for a full lookup of \code{event_id} values.}

\item{regions}{The region to pull odds from. Options include:
\itemize{
\item us
\item uk
\item us
\item eu
\item au
Multiple can be specified if comma delimited.
}}

\item{markets}{The type of odds to return. Multiple can be specified if comma delimited. Options include:
\itemize{
\item h2h
\item spreads
\item totals
\item outrights
\item h2h_lay
\item outrights_lay
\item alternate_spreads
\item alternate_totals
\item btts
\item draw_no_bet
\item h2h_3_way
}

NFL Player Props:
\itemize{
\item player_pass_tds
\item player_pass_yds
\item player_pass_completions
\item player_pass_attempts
\item player_pass_interceptions
\item player_pass_longest_completion
\item player_rush_yds
\item player_rush_attempts
\item player_rush_longest
\item player_receptions
\item player_reception_yds
\item player_reception_longest
}

NBA + NCAAB Player Props:
\itemize{
\item player_points
\item player_rebounds
\item player_assists
\item player_threes
\item player_double_double
\item player_blocks
\item player_steals
\item player_turnovers
\item player_points_rebounds_assists
\item player_points_rebounds
\item player_points_assists
\item player_rebounds_assists
}

NHL Player Props:
\itemize{
\item player_points
\item player_power_play_points
\item player_assists
\item player_blocked_shots
\item player_shots_on_goal
}

\href{https://the-odds-api.com/sports-odds-data/betting-markets.html#player-props-api-markets}{Player Props Documentation}}

\item{odds_format}{The format in which to return odds. Options include:
\itemize{
\item decimal
\item american
}}

\item{date_format}{Date format. Options include:
\itemize{
\item iso
\item unix
}}

\item{bookmakers}{Comma-separated list of bookmakers to be returned. If both bookmakers and
regions are specified, bookmakers takes precendence. Bookmakers can be from any region.
Every group of 10 bookmakers counts as 1 request. For example for a single market,
specifying up to 10 bookmakers counts as 1 request.
Specifying between 11 and 20 bookmakers counts as 2 requests}
}
\value{
Sports for which The Odds API provides betting information for as a tibble:\tabular{ll}{
   col_name \tab types \cr
   id \tab character \cr
   sport_key \tab character \cr
   sport_title \tab character \cr
   commence_time \tab character \cr
   home_team \tab character \cr
   away_team \tab character \cr
   bookmaker_key \tab character \cr
   bookmaker \tab character \cr
   last_update \tab character \cr
   market_key \tab character \cr
   outcomes_name \tab character \cr
   outcomes_price \tab numeric \cr
   outcomes_point \tab numeric \cr
}
}
\description{
\strong{Get the odds for the sports which the Odds API provides coverage}

\if{html}{\out{<div class="sourceCode r">}}\preformatted{   try(toa_sports_odds(sport_key = 'baseball_mlb', 
                       regions = 'us', 
                       markets = 'spreads', 
                       odds_format = 'decimal',
                       date_format = 'iso'))
}\if{html}{\out{</div>}}
}
\details{
\if{html}{\out{<div class="sourceCode r">}}\preformatted{   try(toa_event_odds(sport_key = 'basketball_ncaab', 
                      event_id = '48db9c3293a52baab881d95d38f37a98',
                      regions = 'us', 
                      markets = 'player_points', 
                      odds_format = 'decimal',
                      date_format = 'iso'))
}\if{html}{\out{</div>}}
}
\keyword{Betting}
\keyword{Lines}
