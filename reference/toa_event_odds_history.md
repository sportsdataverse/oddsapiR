# **Find historical odds for a single event through the Odds API**

**Get bookmaker odds for a single event as they appeared at a point in
time.**

Like
[`toa_event_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds.md)
but for a historical snapshot: accepts any available market key
(including player props and alternate lines) and returns the odds at the
snapshot closest to (and at or before) the requested `date`. Look up a
historical `event_id` with
[`toa_sports_events_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_events_history.md).
The returned `timestamp`, `previous_timestamp` and `next_timestamp`
columns let you page through snapshots.

Historical odds for additional markets are available from 2023-05-03 at
5-minute intervals; featured markets reach back to June 2020 on paid
plans.

**Usage quota cost:**
`[number of unique markets returned] x [number of regions]` (the
standard rate, not the 10x historical multiplier). Snapshots with no
data do not count against the quota.

## Usage

``` r
toa_event_odds_history(
  sport_key,
  event_id,
  date,
  regions = "us",
  markets = "h2h",
  odds_format = "decimal",
  date_format = "iso",
  bookmakers = NULL
)
```

## Arguments

- sport_key:

  (*string*, required): The `sport_key` to look up odds for. See
  [`toa_sports()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports.md)
  for a full lookup of `sport_key` values.

- event_id:

  (*string*, required): The `event_id` to look up odds for. See
  [`toa_sports_events_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_events_history.md)
  for a full lookup of `event_id` values.

- date:

  (*string*, required): The timestamp of the data snapshot to return, in
  ISO 8601 format (e.g. `2023-10-10T12:15:00Z`). The API returns the
  closest snapshot equal to or earlier than this value.

- regions:

  (*string*, required): The region(s) to pull bookmakers from. Multiple
  can be specified if comma delimited. Options include:

  - `us`

  - `us2`

  - `uk`

  - `eu`

  - `au`

- markets:

  (*string*, optional): The markets to return. Multiple can be specified
  if comma delimited. In addition to `h2h`, `spreads`, `totals` and
  `outrights`, this endpoint accepts additional markets such as
  alternate lines and player props. See the [betting markets
  documentation](https://the-odds-api.com/sports-odds-data/betting-markets.html).

- odds_format:

  (*string*, optional): Format in which to return odds. Options are
  `decimal` (default) or `american`.

- date_format:

  (*string*, optional): Format of returned timestamps. Options are `iso`
  (default) or `unix`.

- bookmakers:

  (*string*, optional): Comma-separated list of bookmakers to be
  returned. If both `bookmakers` and `regions` are specified,
  `bookmakers` takes precedence. Every group of 10 bookmakers counts as
  1 region against the usage quota.

## Value

A long-format tibble with one row per bookmaker market outcome:

|  |  |  |
|----|----|----|
| col_name | types | description |
| timestamp | character | Snapshot timestamp returned (closest at/before `date`). |
| previous_timestamp | character | Preceding available snapshot; use as `date` to page back. |
| next_timestamp | character | Next available snapshot; use as `date` to page forward. |
| id | character | Unique event id (echoes `event_id`). |
| sport_key | character | Sport key, e.g. `basketball_nba`. |
| sport_title | character | Human-readable sport title, e.g. `NBA`. |
| commence_time | character | Game start time (ISO 8601 string or unix seconds). |
| home_team | character | Home team name. |
| away_team | character | Away team name. |
| bookmaker_key | character | Bookmaker slug, e.g. `draftkings`. |
| bookmaker | character | Bookmaker display title, e.g. `DraftKings`. |
| bookmaker_last_update | character | When this bookmaker's odds were last updated. |
| market_key | character | Market key, e.g. `player_points`. |
| market_last_update | character | When this market's odds were last updated. |
| outcomes_name | character | Outcome label (team, `Over`/`Under`, player name, etc.). |
| outcomes_description | character | Outcome description (player name for props); absent for featured markets. |
| outcomes_price | numeric | The price/odds for the outcome. |
| outcomes_point | numeric | The handicap/total/prop line, when applicable. |

If the event exists at the requested snapshot but no bookmaker odds were
posted for the requested markets/regions, a zero-row tibble with the
same columns is returned.

## See also

[`toa_sports_events_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_events_history.md)
to look up historical `event_id` values,
[`toa_sports_odds_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_odds_history.md)
for featured-market odds across all events at a snapshot, and
[`toa_event_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds.md)
for current event odds. Part of the
[SportsDataverse](https://sportsdataverse.org/).

Other The Odds API: Historical:
[`toa_sports_events_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_events_history.md),
[`toa_sports_odds_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_odds_history.md)

## Examples

``` r
# \donttest{
   try(toa_event_odds_history(sport_key = 'basketball_nba',
                              event_id = '93af4b300a4c0dded909234ea32e9abd',
                              date = '2024-01-15T12:15:00Z',
                              regions = 'us',
                              markets = 'h2h',
                              odds_format = 'decimal',
                              date_format = 'iso'))
#> ── Historical Event Odds data from the-odds-api.com ── oddsapiR 1.0.0 ──
#> ℹ Data updated: 2026-08-27 04:13:57 UTC
#> ℹ Odds API quota: 14420 used, 4985580 remaining (last call cost 10)
#> # A tibble: 20 × 16
#>    timestamp           previous_timestamp next_timestamp id    sport_key
#>    <chr>               <chr>              <chr>          <chr> <chr>    
#>  1 2024-01-15T12:10:3… 2024-01-15T12:05:… 2024-01-15T12… 93af… basketba…
#>  2 2024-01-15T12:10:3… 2024-01-15T12:05:… 2024-01-15T12… 93af… basketba…
#>  3 2024-01-15T12:10:3… 2024-01-15T12:05:… 2024-01-15T12… 93af… basketba…
#>  4 2024-01-15T12:10:3… 2024-01-15T12:05:… 2024-01-15T12… 93af… basketba…
#>  5 2024-01-15T12:10:3… 2024-01-15T12:05:… 2024-01-15T12… 93af… basketba…
#>  6 2024-01-15T12:10:3… 2024-01-15T12:05:… 2024-01-15T12… 93af… basketba…
#>  7 2024-01-15T12:10:3… 2024-01-15T12:05:… 2024-01-15T12… 93af… basketba…
#>  8 2024-01-15T12:10:3… 2024-01-15T12:05:… 2024-01-15T12… 93af… basketba…
#>  9 2024-01-15T12:10:3… 2024-01-15T12:05:… 2024-01-15T12… 93af… basketba…
#> 10 2024-01-15T12:10:3… 2024-01-15T12:05:… 2024-01-15T12… 93af… basketba…
#> 11 2024-01-15T12:10:3… 2024-01-15T12:05:… 2024-01-15T12… 93af… basketba…
#> 12 2024-01-15T12:10:3… 2024-01-15T12:05:… 2024-01-15T12… 93af… basketba…
#> 13 2024-01-15T12:10:3… 2024-01-15T12:05:… 2024-01-15T12… 93af… basketba…
#> 14 2024-01-15T12:10:3… 2024-01-15T12:05:… 2024-01-15T12… 93af… basketba…
#> 15 2024-01-15T12:10:3… 2024-01-15T12:05:… 2024-01-15T12… 93af… basketba…
#> 16 2024-01-15T12:10:3… 2024-01-15T12:05:… 2024-01-15T12… 93af… basketba…
#> 17 2024-01-15T12:10:3… 2024-01-15T12:05:… 2024-01-15T12… 93af… basketba…
#> 18 2024-01-15T12:10:3… 2024-01-15T12:05:… 2024-01-15T12… 93af… basketba…
#> 19 2024-01-15T12:10:3… 2024-01-15T12:05:… 2024-01-15T12… 93af… basketba…
#> 20 2024-01-15T12:10:3… 2024-01-15T12:05:… 2024-01-15T12… 93af… basketba…
#> # ℹ 11 more variables: sport_title <chr>, commence_time <chr>,
#> #   home_team <chr>, away_team <chr>, bookmaker_key <chr>,
#> #   bookmaker <chr>, bookmaker_last_update <chr>, market_key <chr>,
#> #   market_last_update <chr>, outcomes_name <chr>, outcomes_price <dbl>
# }
```
