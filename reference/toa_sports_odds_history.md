# **Find historical featured-market odds through the Odds API**

**Get historical featured-market odds for a sport which The Odds API
covers.**

Returns the list of events and featured bookmaker odds (`h2h`,
`spreads`, `totals`) as they appeared at the snapshot closest to (and at
or before) the requested `date`. The response is wrapped in a snapshot
envelope; the returned `timestamp`, `previous_timestamp` and
`next_timestamp` columns let you page backward/forward in time. This
endpoint was previously `/v4/sports/{sport}/odds-history`, which has
been deprecated in favour of `/v4/historical/sports/{sport}/odds`.

Historical data is available on paid usage plans from June 2020.

**Usage quota cost:** `10 x [number of markets] x [number of regions]`.
Snapshots with no events do not count against the quota.

## Usage

``` r
toa_sports_odds_history(
  sport_key,
  date,
  regions = "us",
  markets = "spreads",
  odds_format = "decimal",
  date_format = "iso",
  event_ids = NULL,
  bookmakers = NULL
)
```

## Arguments

- sport_key:

  (*string*, required): The `sport_key` to look up odds for. See
  [`toa_sports()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports.md)
  for a full lookup of `sport_key` values.

- date:

  (*string*, required): The timestamp of the data snapshot to return, in
  ISO 8601 format (e.g. `2023-03-18T12:15:00Z`). The API returns the
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

  (*string*, optional): The featured markets to return. Multiple can be
  specified if comma delimited. Options include `h2h`, `spreads`,
  `totals`.

- odds_format:

  (*string*, optional): Format in which to return odds. Options are
  `decimal` (default) or `american`.

- date_format:

  (*string*, optional): Format of returned timestamps. Options are `iso`
  (default) or `unix`.

- event_ids:

  (*string*, optional): Comma-separated list of event ids to filter the
  snapshot to. Defaults to `NULL` (all events).

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
| id | character | Unique event id. |
| sport_key | character | Sport key, e.g. `basketball_nba`. |
| sport_title | character | Human-readable sport title, e.g. `NBA`. |
| commence_time | character | Game start time (ISO 8601 string or unix seconds). |
| home_team | character | Home team name. |
| away_team | character | Away team name. |
| bookmaker_key | character | Bookmaker slug, e.g. `draftkings`. |
| bookmaker | character | Bookmaker display title, e.g. `DraftKings`. |
| bookmaker_last_update | character | When this bookmaker's odds were last updated. |
| market_key | character | Market key, e.g. `spreads`. |
| market_last_update | character | When this market's odds were last updated. |
| outcomes_name | character | Outcome label (team name, `Over`/`Under`, etc.). |
| outcomes_price | numeric | The price/odds for the outcome. |
| outcomes_point | numeric | The handicap/total line (`spreads`/`totals` only). |

## See also

[`toa_event_odds_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds_history.md)
for historical odds on a single event (including player props),
[`toa_sports_events_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_events_history.md)
to list events at a historical snapshot, and
[`toa_sports_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_odds.md)
for current featured-market odds. Part of the
[SportsDataverse](https://sportsdataverse.org/).

Other The Odds API: Historical:
[`toa_event_odds_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds_history.md),
[`toa_sports_events_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_events_history.md)

## Examples

``` r
# \donttest{
   try(toa_sports_odds_history(sport_key = 'basketball_nba',
                               date = '2024-01-15T12:15:00Z',
                               regions = 'us',
                               markets = 'spreads',
                               odds_format = 'decimal',
                               date_format = 'iso'))
#> ── Historical Sports Odds data from the-odds-api.com ───────────────────
#> ℹ Data updated: 2026-06-13 00:49:18 UTC
#> ℹ Odds API quota: 1277 used, 18723 remaining (last call cost 10)
#> # A tibble: 222 × 17
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
#> # ℹ 212 more rows
#> # ℹ 12 more variables: sport_title <chr>, commence_time <chr>,
#> #   home_team <chr>, away_team <chr>, bookmaker_key <chr>,
#> #   bookmaker <chr>, bookmaker_last_update <chr>, market_key <chr>,
#> #   market_last_update <chr>, outcomes_name <chr>,
#> #   outcomes_price <dbl>, outcomes_point <dbl>
# }
```
