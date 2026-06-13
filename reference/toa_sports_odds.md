# **Find odds for the sports which are accessible through the Odds API**

**Get the featured-market odds for a sport which The Odds API covers.**

Returns a list of upcoming and live games with featured bookmaker odds
for the specified markets and regions. For player props and other
additional markets, use
[`toa_event_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds.md)
instead.

**Usage quota cost:** `[number of markets] x [number of regions]`.

## Usage

``` r
toa_sports_odds(
  sport_key,
  regions = "us",
  markets = "spreads",
  odds_format = "decimal",
  date_format = "iso"
)
```

## Arguments

- sport_key:

  (*string*, required): The `sport_key` to look up odds for. See
  [`toa_sports()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports.md)
  for a full lookup of `sport_key` values.

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
  specified if comma delimited. Options include:

  - `h2h` (moneyline)

  - `spreads` (points handicaps)

  - `totals` (over/under)

  - `outrights` (futures, select sports only)

- odds_format:

  (*string*, optional): Format in which to return odds. Options are
  `decimal` (default) or `american`.

- date_format:

  (*string*, optional): Format of returned timestamps. Options are `iso`
  (default) or `unix`.

## Value

A long-format tibble with one row per bookmaker market outcome:

|  |  |  |
|----|----|----|
| col_name | types | description |
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
| outcomes_point | numeric | The handicap/total line, when applicable. |

## See also

[`toa_event_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds.md)
for a single event's odds (including player props and alternate lines),
[`toa_event_markets()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_markets.md)
to list a game's available market keys, and
[`toa_sports()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports.md)
to find `sport_key` values. Part of the
[SportsDataverse](https://sportsdataverse.org/).

Other The Odds API: Odds & Markets:
[`toa_event_markets()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_markets.md),
[`toa_event_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds.md)

## Examples

``` r
# \donttest{
   try(toa_sports_odds(sport_key = 'basketball_nba',
                       regions = 'us',
                       markets = 'spreads',
                       odds_format = 'decimal',
                       date_format = 'iso'))
#> ── Sports Odds data from the-odds-api.com ──────────── oddsapiR 1.0.0 ──
#> ℹ Data updated: 2026-06-13 03:12:06 UTC
#> ℹ Odds API quota: 1703 used, 18297 remaining (last call cost 1)
#> # A tibble: 22 × 14
#>    id            sport_key sport_title commence_time home_team away_team
#>    <chr>         <chr>     <chr>       <chr>         <chr>     <chr>    
#>  1 6cc5c3b9cfcb… basketba… NBA         2026-06-14T0… San Anto… New York…
#>  2 6cc5c3b9cfcb… basketba… NBA         2026-06-14T0… San Anto… New York…
#>  3 6cc5c3b9cfcb… basketba… NBA         2026-06-14T0… San Anto… New York…
#>  4 6cc5c3b9cfcb… basketba… NBA         2026-06-14T0… San Anto… New York…
#>  5 6cc5c3b9cfcb… basketba… NBA         2026-06-14T0… San Anto… New York…
#>  6 6cc5c3b9cfcb… basketba… NBA         2026-06-14T0… San Anto… New York…
#>  7 6cc5c3b9cfcb… basketba… NBA         2026-06-14T0… San Anto… New York…
#>  8 6cc5c3b9cfcb… basketba… NBA         2026-06-14T0… San Anto… New York…
#>  9 6cc5c3b9cfcb… basketba… NBA         2026-06-14T0… San Anto… New York…
#> 10 6cc5c3b9cfcb… basketba… NBA         2026-06-14T0… San Anto… New York…
#> # ℹ 12 more rows
#> # ℹ 8 more variables: bookmaker_key <chr>, bookmaker <chr>,
#> #   bookmaker_last_update <chr>, market_key <chr>,
#> #   market_last_update <chr>, outcomes_name <chr>,
#> #   outcomes_price <dbl>, outcomes_point <dbl>
# }
```
