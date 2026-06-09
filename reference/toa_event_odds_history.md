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
#> ✖ 2026-06-09 08:16:23.584581: Invalid arguments or no historical odds available for event 93af4b300a4c0dded909234ea32e9abd at 2024-01-15T12:15:00Z!
#> ✖ Error:
#> Error in `dplyr::rename()`:
#> ! Can't rename columns that don't exist.
#> ✖ Column `key` doesn't exist.
#> data frame with 0 columns and 0 rows
# }
```
