% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/toa_sports_odds_history.R
\name{toa_sports_odds_history}
\alias{toa_sports_odds_history}
\title{\strong{Find odds history for the sports which are accessible through the Odds API}}
\usage{
toa_sports_odds_history(
  sport_key,
  event_ids,
  date,
  regions = "us",
  markets = "spreads",
  odds_format = "decimal",
  date_format = "iso",
  bookmakers = NULL
)
}
\arguments{
\item{sport_key}{The \code{sport_key} to look up odds for. See \code{toa_sports()} for a full lookup of \code{sport_key} values.}

\item{event_ids}{The \code{event_id}'s to look up odds for. See \code{toa_sports_odds()} for a full lookup of \code{event_id} values.}

\item{date}{The timestamp of the data snapshot to be returned, specified in ISO8601 format. The historical odds API will return the closest snapshot equal to or earlier than the provided date parameter
Example : 2022-10-10T12:15:00Z}

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
}}

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
\strong{Get the odds history for the sports which the Odds API provides coverage}

\if{html}{\out{<div class="sourceCode r">}}\preformatted{   try(toa_sports_odds(sport_key = 'baseball_mlb', 
                       regions = 'us', 
                       markets = 'spreads', 
                       odds_format = 'decimal',
                       date_format = 'iso'))
}\if{html}{\out{</div>}}
}
\details{
\if{html}{\out{<div class="sourceCode r">}}\preformatted{try(toa_sports_odds_history(sport_key = 'basketball_ncaab', 
                               event_ids = '48db9c3293a52baab881d95d38f37a98',
                               date = '2023-03-18T12:15:00Z',
                               regions = 'us', 
                               markets = 'spreads', 
                               odds_format = 'decimal',
                               date_format = 'iso',
                               bookmakers = NULL))
}\if{html}{\out{</div>}}
}
\keyword{Betting}
\keyword{Lines}
