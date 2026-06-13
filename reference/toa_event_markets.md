# **Find the available market keys for a single event through the Odds API**

**Get the available market keys for each bookmaker for a single event.**

Returns the recently seen market keys per bookmaker for an event (no
odds). This is not a comprehensive list of all supported markets – more
keys are returned as bookmakers open more markets approaching commence
time. Use the returned `market_key` values to request odds via
[`toa_event_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds.md).

**Usage quota cost:** 1 credit.

## Usage

``` r
toa_event_markets(
  sport_key,
  event_id,
  regions = "us",
  bookmakers = NULL,
  date_format = "iso"
)
```

## Arguments

- sport_key:

  (*string*, required): The `sport_key` to look up markets for. See
  [`toa_sports()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports.md)
  for a full lookup of `sport_key` values.

- event_id:

  (*string*, required): The `event_id` to look up markets for. See
  [`toa_sports_events()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_events.md)
  for a full lookup of `event_id` values.

- regions:

  (*string*, required): The region(s) that determine which bookmakers
  appear. Multiple can be specified if comma delimited. Options include:

  - `us`

  - `us2`

  - `uk`

  - `eu`

  - `au`

- bookmakers:

  (*string*, optional): Comma-separated list of bookmakers to be
  returned. If both `bookmakers` and `regions` are specified,
  `bookmakers` takes precedence.

- date_format:

  (*string*, optional): Format of returned timestamps. Options are `iso`
  (default) or `unix`.

## Value

A tibble with one row per bookmaker market available for the event:

|  |  |  |
|----|----|----|
| col_name | types | description |
| id | character | Unique event id (echoes `event_id`). |
| sport_key | character | Sport key, e.g. `basketball_nba`. |
| sport_title | character | Human-readable sport title, e.g. `NBA`. |
| commence_time | character | Event start time (ISO 8601 string or unix seconds). |
| home_team | character | Home team name. |
| away_team | character | Away team name. |
| bookmaker_key | character | Bookmaker slug, e.g. `draftkings`. |
| bookmaker | character | Bookmaker display title, e.g. `DraftKings`. |
| market_key | character | Available market key, e.g. `player_points`. |
| market_last_update | character | When this market was last seen for the bookmaker. |

## See also

[`toa_event_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds.md)
to pull odds for the market keys discovered here,
[`toa_sports_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_odds.md)
for featured-market odds across all events, and
[`toa_sports_events()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_events.md)
to look up `event_id` values. Part of the
[SportsDataverse](https://sportsdataverse.org/).

Other The Odds API: Odds & Markets:
[`toa_event_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds.md),
[`toa_sports_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_odds.md)

## Examples

``` r
# \donttest{
   try(toa_event_markets(sport_key = 'basketball_nba',
                         event_id = '48db9c3293a52baab881d95d38f37a98',
                         regions = 'us'))
#> ✖ 2026-06-13 02:04:09.615936: Invalid arguments or no markets data available for event 48db9c3293a52baab881d95d38f37a98!
#> ✖ Error:
#> Error in `dplyr::rename()`:
#> ! Can't rename columns that don't exist.
#> ✖ Column `key` doesn't exist.
#> data frame with 0 columns and 0 rows
# }
```
