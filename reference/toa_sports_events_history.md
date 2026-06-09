# **Find historical events for a sport through the Odds API**

**Get the list of events for a sport as they appeared at a point in
time.**

Returns the events (without odds) that existed at the snapshot closest
to (and at or before) the requested `date`. The returned `timestamp`,
`previous_timestamp` and `next_timestamp` columns let you page through
snapshots. The `id` returned here is the `event_id` consumed by
[`toa_event_odds_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds_history.md).

Historical data is available on paid usage plans from June 2020.

**Usage quota cost:** 1 credit (0 if no events are found at the
snapshot).

## Usage

``` r
toa_sports_events_history(
  sport_key,
  date,
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

- date:

  (*string*, required): The timestamp of the data snapshot to return, in
  ISO 8601 format (e.g. `2023-10-10T12:15:00Z`). The API returns the
  closest snapshot equal to or earlier than this value.

- date_format:

  (*string*, optional): Format of returned timestamps. Options are `iso`
  (default) or `unix`.

- event_ids:

  (*string*, optional): Comma-separated list of event ids to filter the
  response to. Defaults to `NULL` (all events).

- commence_time_from:

  (*string*, optional): Filter to events that commence on and after this
  ISO 8601 timestamp.

- commence_time_to:

  (*string*, optional): Filter to events that commence on and before
  this ISO 8601 timestamp.

- include_rotation_numbers:

  (*logical*, optional): If `TRUE`, include the `home_rotation` and
  `away_rotation` columns when available. Defaults to `FALSE`.

## Value

A tibble with one row per historical event:

|  |  |  |
|----|----|----|
| col_name | types | description |
| timestamp | character | Snapshot timestamp returned (closest at/before `date`). |
| previous_timestamp | character | Preceding available snapshot; use as `date` to page back. |
| next_timestamp | character | Next available snapshot; use as `date` to page forward. |
| id | character | Unique event id. Use as `event_id` elsewhere. |
| sport_key | character | Sport key, e.g. `basketball_nba`. |
| sport_title | character | Human-readable sport title, e.g. `NBA`. |
| commence_time | character | Event start time (ISO 8601 string or unix seconds). |
| home_team | character | Home team name. |
| away_team | character | Away team name. |
| home_rotation | integer | Home rotation number (only when `include_rotation_numbers = TRUE`). |
| away_rotation | integer | Away rotation number (only when `include_rotation_numbers = TRUE`). |

## See also

[`toa_event_odds_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds_history.md)
to pull odds for a historical event by its `id`,
[`toa_sports_odds_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_odds_history.md)
for featured-market odds at a historical snapshot, and
[`toa_sports_events()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_events.md)
for current events. Part of the
[SportsDataverse](https://sportsdataverse.org/).

Other The Odds API: Historical:
[`toa_event_odds_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds_history.md),
[`toa_sports_odds_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_odds_history.md)

## Examples

``` r
# \donttest{
   try(toa_sports_events_history(sport_key = 'basketball_nba',
                                 date = '2024-01-15T12:15:00Z'))
#> ✖ 2026-06-09 19:56:22.626281: Invalid arguments or no historical events available for basketball_nba at 2024-01-15T12:15:00Z!
#> ✖ Error:
#> Error in `vars_select_eval()`:
#> ! Can't select columns past the end.
#> ℹ Location 1 doesn't exist.
#> ℹ There are only 0 columns.
#> data frame with 0 columns and 0 rows
# }
```
