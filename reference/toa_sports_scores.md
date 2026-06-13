# **Find scores for the sports which are accessible through the Odds API**

**Get the scores for the sports which The Odds API provides coverage.**

Returns live and recently completed games for a sport, including scores
for games completed within the last 3 days. Live scores update roughly
every 30 seconds.

**Usage quota cost:** 1 credit when `days_from` is not supplied; 2
credits when `days_from` is supplied.

## Usage

``` r
toa_sports_scores(sport_key, days_from = NULL, date_format = "iso")
```

## Arguments

- sport_key:

  (*string*, required): The `sport_key` to look up scores for. See
  [`toa_sports()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports.md)
  for a full lookup of `sport_key` values.

- days_from:

  (*integer*, optional): Number of days in the past from which to return
  completed games, an integer from 1 to 3. If `NULL` (default), only
  live and upcoming games are returned.

- date_format:

  (*string*, optional): Format of returned timestamps. Options are:

  - `iso` (ISO 8601, the default)

  - `unix` (epoch seconds)

## Value

A tibble of scores for the sport The Odds API provides coverage for:

|  |  |  |
|----|----|----|
| col_name | types | description |
| id | character | Unique event id. |
| sport_key | character | Sport key, e.g. `basketball_nba`. |
| sport_title | character | Human-readable sport title, e.g. `NBA`. |
| commence_time | character | Game start time (ISO 8601 string or unix seconds). |
| completed | logical | `TRUE` if the game has finished. |
| home_team | character | Home team name. |
| away_team | character | Away team name. |
| scores | list | Per-team `name`/`score` pairs; `NULL`/`NA` before scores post. |
| last_update | character | Time the scores were last updated; `NA` until a game is live. |

## See also

[`toa_sports()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports.md)
to discover `sport_key` values,
[`toa_sports_events()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_events.md)
to list upcoming events, and
[`toa_sports_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_odds.md)
for live/upcoming betting lines. Part of the
[SportsDataverse](https://sportsdataverse.org/).

Other The Odds API: Sports & Events:
[`toa_sports()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports.md),
[`toa_sports_events()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_events.md),
[`toa_sports_participants()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_participants.md)

## Examples

``` r
# \donttest{
   try(toa_sports_scores(sport_key = 'basketball_nba',
                         days_from = NULL,
                         date_format = 'iso'))
#> ── Sports scores data from the-odds-api.com ────────── oddsapiR 1.0.0 ──
#> ℹ Data updated: 2026-06-13 03:21:11 UTC
#> ℹ Odds API quota: 2027 used, 17973 remaining (last call cost 1)
#> # A tibble: 1 × 9
#>   id             sport_key sport_title commence_time completed home_team
#>   <chr>          <chr>     <chr>       <chr>         <lgl>     <chr>    
#> 1 6cc5c3b9cfcb1… basketba… NBA         2026-06-14T0… FALSE     San Anto…
#> # ℹ 3 more variables: away_team <chr>, scores <lgl>, last_update <lgl>
# }
```
