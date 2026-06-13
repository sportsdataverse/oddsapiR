# **Find odds for a single event, including player props and other markets**

**Get bookmaker odds for a single event from The Odds API.**

Unlike
[`toa_sports_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_odds.md)
(featured markets only), this endpoint accepts any available market key,
including player props and alternate lines. Look up an `event_id` with
[`toa_sports_events()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_events.md).

**Usage quota cost:**
`[number of unique markets returned] x [number of regions]`.

## Usage

``` r
toa_event_odds(
  sport_key,
  event_id,
  regions = "us",
  markets = "spreads",
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
  [`toa_sports_events()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_events.md)
  for a full lookup of `event_id` values.

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
  alternate lines and player props (e.g. `player_points`,
  `player_pass_tds`, `player_shots_on_goal`). See the [betting markets
  documentation](https://the-odds-api.com/sports-odds-data/betting-markets.html)
  for the full list.

- odds_format:

  (*string*, optional): Format in which to return odds. Options are
  `decimal` (default) or `american`.

- date_format:

  (*string*, optional): Format of returned timestamps. Options are `iso`
  (default) or `unix`.

- bookmakers:

  (*string*, optional): Comma-separated list of bookmakers to be
  returned. If both `bookmakers` and `regions` are specified,
  `bookmakers` takes precedence. Bookmakers can be from any region.
  Every group of 10 bookmakers counts as 1 region against the usage
  quota.

## Value

A long-format tibble with one row per bookmaker market outcome:

|  |  |  |
|----|----|----|
| col_name | types | description |
| id | character | Unique event id (echoes `event_id`). |
| sport_key | character | Sport key, e.g. `basketball_nba`. |
| sport_title | character | Human-readable sport title, e.g. `NBA`. |
| commence_time | character | Game start time (ISO 8601 string or unix seconds). |
| home_team | character | Home team name. |
| away_team | character | Away team name. |
| bookmaker_key | character | Bookmaker slug, e.g. `draftkings`. |
| bookmaker | character | Bookmaker display title, e.g. `DraftKings`. |
| market_key | character | Market key, e.g. `player_points`. |
| market_last_update | character | When this market's odds were last updated. |
| outcomes_name | character | Outcome label (team, `Over`/`Under`, player name, etc.). |
| outcomes_description | character | Outcome description (player name for props); absent for featured markets. |
| outcomes_price | numeric | The price/odds for the outcome. |
| outcomes_point | numeric | The handicap/total/prop line, when applicable. |

## See also

[`toa_sports_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_odds.md)
for featured-market odds across all upcoming events,
[`toa_event_markets()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_markets.md)
to discover available market keys for an event, and
[`toa_sports_events()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_events.md)
to look up `event_id` values. Part of the
[SportsDataverse](https://sportsdataverse.org/).

Other The Odds API: Odds & Markets:
[`toa_event_markets()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_markets.md),
[`toa_sports_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_odds.md)

## Examples

``` r
# \donttest{
   try(toa_event_odds(sport_key = 'basketball_nba',
                      event_id = '48db9c3293a52baab881d95d38f37a98',
                      regions = 'us',
                      markets = 'player_points',
                      odds_format = 'decimal',
                      date_format = 'iso'))
#> ✖ 2026-06-13 02:04:09.973091: Invalid arguments or no odds data available for event 48db9c3293a52baab881d95d38f37a98!
#> ✖ Error:
#> Error in `dplyr::rename()`:
#> ! Can't rename columns that don't exist.
#> ✖ Column `key` doesn't exist.
#> data frame with 0 columns and 0 rows
# }
```
