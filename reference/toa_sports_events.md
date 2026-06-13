# **Find in-play and upcoming events for a sport through the Odds API**

**Get the list of in-play and pre-match events for a sport.**

Returns a list of events without odds. The `id` returned here is the
`event_id` consumed by
[`toa_event_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds.md)
and
[`toa_event_markets()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_markets.md).

**Usage quota cost:** Free. This endpoint does not count against your
quota.

## Usage

``` r
toa_sports_events(
  sport_key,
  date_format = "iso",
  event_ids = NULL,
  commence_time_from = NULL,
  commence_time_to = NULL,
  include_rotation_numbers = FALSE
)
```

## Arguments

- sport_key:

  (*string*, required): The `sport_key` to look up events for. See
  [`toa_sports()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports.md)
  for a full lookup of `sport_key` values.

- date_format:

  (*string*, optional): Format of returned timestamps. Options are `iso`
  (default) or `unix`.

- event_ids:

  (*string*, optional): Comma-separated list of event ids to filter the
  response to. Defaults to `NULL` (all events).

- commence_time_from:

  (*string*, optional): Filter to events that commence on and after this
  ISO 8601 timestamp (e.g. `2023-09-09T00:00:00Z`).

- commence_time_to:

  (*string*, optional): Filter to events that commence on and before
  this ISO 8601 timestamp (e.g. `2023-09-09T00:00:00Z`).

- include_rotation_numbers:

  (*logical*, optional): If `TRUE`, include the `home_rotation` and
  `away_rotation` columns when available. Defaults to `FALSE`.

## Value

A tibble with one row per event:

|  |  |  |
|----|----|----|
| col_name | types | description |
| id | character | Unique event id. Use as `event_id` elsewhere. |
| sport_key | character | Sport key, e.g. `basketball_nba`. |
| sport_title | character | Human-readable sport title, e.g. `NBA`. |
| commence_time | character | Event start time (ISO 8601 string or unix seconds). |
| home_team | character | Home team name. |
| away_team | character | Away team name. |
| home_rotation | integer | Home rotation number (only when `include_rotation_numbers = TRUE`). |
| away_rotation | integer | Away rotation number (only when `include_rotation_numbers = TRUE`). |

## See also

[`toa_sports()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports.md)
to discover `sport_key` values,
[`toa_event_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds.md)
to pull odds for a specific event by its `id`, and
[`toa_event_markets()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_markets.md)
to see available market keys per bookmaker. Part of the
[SportsDataverse](https://sportsdataverse.org/).

Other The Odds API: Sports & Events:
[`toa_sports()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports.md),
[`toa_sports_participants()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_participants.md),
[`toa_sports_scores()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_scores.md)

## Examples

``` r
# \donttest{
   try(toa_sports_events(sport_key = 'basketball_nba'))
#> ── Sports Events data from the-odds-api.com ────────── oddsapiR 1.0.0 ──
#> ℹ Data updated: 2026-06-13 04:17:26 UTC
#> ℹ Odds API quota: 2231 used, 17769 remaining (last call cost 0)
#> # A tibble: 1 × 6
#>   id             sport_key sport_title commence_time home_team away_team
#>   <chr>          <chr>     <chr>       <chr>         <chr>     <chr>    
#> 1 6cc5c3b9cfcb1… basketba… NBA         2026-06-14T0… San Anto… New York…
# }
```
