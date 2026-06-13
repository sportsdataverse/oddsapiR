# **Find sports for which odds are accessible through the Odds API**

**Get the sports for which The Odds API provides coverage.**

Returns a list of in-season sports. The `key` returned here is the
`sport_key` consumed by every other `toa_*()` endpoint.

**Usage quota cost:** Free. This endpoint does not count against your
quota.

## Usage

``` r
toa_sports(all_sports = TRUE)
```

## Arguments

- all_sports:

  (*Logical*, optional): If `TRUE`, returns all sports (including
  out-of-season). If `FALSE`, returns only in-season sports. Defaults to
  `TRUE`.

## Value

A tibble of the sports for which The Odds API provides coverage:

|  |  |  |
|----|----|----|
| col_name | types | description |
| key | character | Sport key, e.g. `americanfootball_nfl`. Use as `sport_key` elsewhere. |
| group | character | Sport group / category, e.g. `American Football`. |
| title | character | Human-readable sport title, e.g. `NFL`. |
| description | character | Description of the sport or competition. |
| active | logical | `TRUE` if the sport is currently in season. |
| has_outrights | logical | `TRUE` if the sport offers outright (futures) markets. |

## See also

[`toa_sports_events()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_events.md)
to list upcoming events for a sport,
[`toa_sports_scores()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_scores.md)
for live/recent scores, and
[`toa_sports_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_odds.md)
to pull featured-market odds. Part of the
[SportsDataverse](https://sportsdataverse.org/).

Other The Odds API: Sports & Events:
[`toa_sports_events()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_events.md),
[`toa_sports_participants()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_participants.md),
[`toa_sports_scores()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_scores.md)

## Examples

``` r
# \donttest{
  try(toa_sports(all_sports = TRUE))
#> ── Sports coverage data from the-odds-api.com ──────── oddsapiR 1.0.0 ──
#> ℹ Data updated: 2026-06-13 04:17:25 UTC
#> ℹ Odds API quota: 2221 used, 17779 remaining (last call cost 0)
#> # A tibble: 165 × 6
#>    key                      group title description active has_outrights
#>    <chr>                    <chr> <chr> <chr>       <lgl>  <lgl>        
#>  1 americanfootball_cfl     Amer… CFL   Canadian F… TRUE   FALSE        
#>  2 americanfootball_ncaaf   Amer… NCAAF US College… TRUE   FALSE        
#>  3 americanfootball_ncaaf_… Amer… NCAA… US College… TRUE   TRUE         
#>  4 americanfootball_nfl     Amer… NFL   US Football TRUE   FALSE        
#>  5 americanfootball_nfl_pr… Amer… NFL … US Football TRUE   FALSE        
#>  6 americanfootball_nfl_su… Amer… NFL … Super Bowl… TRUE   TRUE         
#>  7 americanfootball_ufl     Amer… UFL   United Foo… TRUE   FALSE        
#>  8 aussierules_afl          Auss… AFL   Aussie Foo… TRUE   FALSE        
#>  9 baseball_kbo             Base… KBO   KBO League  TRUE   FALSE        
#> 10 baseball_milb            Base… MiLB  Minor Leag… FALSE  FALSE        
#> # ℹ 155 more rows
# }
```
