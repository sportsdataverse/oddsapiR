# **Find the participants (teams or players) for a sport through the Odds API**

**Get the list of participants for a sport.**

Depending on the sport a participant is either a team (e.g. NBA) or an
individual (e.g. tennis). The list is a whitelist used to define events
and may include participants that are no longer active. This endpoint
does not return individual players on a team.

**Usage quota cost:** 1 credit.

## Usage

``` r
toa_sports_participants(sport_key)
```

## Arguments

- sport_key:

  (*string*, required): The `sport_key` to look up participants for. See
  [`toa_sports()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports.md)
  for a full lookup of `sport_key` values.

## Value

A tibble with one row per participant:

|  |  |  |
|----|----|----|
| col_name | types | description |
| sport_key | character | Sport key the participants belong to (echoes the `sport_key` argument). |
| id | character | Unique participant id, e.g. `par_01hqmkq6fdf1pvq7jgdd7hdmpf`. |
| full_name | character | Participant name – a team name or player name depending on the sport. |

## See also

[`toa_sports()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports.md)
to discover `sport_key` values,
[`toa_sports_events()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_events.md)
to list upcoming events, and
[`toa_sports_scores()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_scores.md)
for live/recent scores. Part of the
[SportsDataverse](https://sportsdataverse.org/).

Other The Odds API: Sports & Events:
[`toa_sports()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports.md),
[`toa_sports_events()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_events.md),
[`toa_sports_scores()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_scores.md)

## Examples

``` r
# \donttest{
   try(toa_sports_participants(sport_key = 'basketball_nba'))
#> ── Sports Participants data from the-odds-api.com ──── oddsapiR 1.0.0 ──
#> ℹ Data updated: 2026-08-27 04:13:59 UTC
#> ℹ Odds API quota: 14433 used, 4985567 remaining (last call cost 1)
#> # A tibble: 32 × 3
#>    sport_key      id                             full_name            
#>    <chr>          <chr>                          <chr>                
#>  1 basketball_nba par_01hqmkq6fceknv7cwebesgrx03 Atlanta Hawks        
#>  2 basketball_nba par_01hqmkq6fdf1pvq7jgdd7hdmpf Boston Celtics       
#>  3 basketball_nba par_01hqmkq6fefp3r8597cv3wj3cr Brooklyn Nets        
#>  4 basketball_nba par_01hqmkq6fffqq9gze9hqf1fwn6 Charlotte Hornets    
#>  5 basketball_nba par_01hqmkq6fgf7krk5evvjfy9mr1 Chicago Bulls        
#>  6 basketball_nba par_01hqmkq6fhec0t7bezwtzqv0fq Cleveland Cavaliers  
#>  7 basketball_nba par_01hqmkq6fje5rrsbnbx97seg30 Dallas Mavericks     
#>  8 basketball_nba par_01hqmkq6fkf9r8wh7303b8hy40 Denver Nuggets       
#>  9 basketball_nba par_01hqmkq6fmfyjsnjtexnh7vdwm Detroit Pistons      
#> 10 basketball_nba par_01hqmkq6fne7nsfvf365y98r0h Golden State Warriors
#> # ℹ 22 more rows
# }
```
