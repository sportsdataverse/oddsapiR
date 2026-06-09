# Getting started with oddsapiR

Welcome folks,

I’m Saiem Gilani, one of the
[authors](https://saiemgilani.github.io/oddsapiR/authors.html "Authors and contributors to oddsapiR")
of [`oddsapiR`](https://saiemgilani.github.io/oddsapiR/), and I hope to
give the community a high-quality resource for accessing
[**`The Odds API`**](https://the-odds-api.com/).

## **Install** [**`oddsapiR`**](https://saiemgilani.github.io/oddsapiR/)

``` r

# You can install using the pacman package using the following code:
if (!requireNamespace('pacman', quietly = TRUE)){
  install.packages('pacman')
}
pacman::p_load_current_gh("sportsdataverse/oddsapiR", dependencies = TRUE, update = TRUE)
pacman::p_load_current_gh("jthomasmock/gtExtras", dependencies = TRUE, update = TRUE)
pacman::p_load(dplyr, knitr, gt)
```

#### **Odds API Keys**

The [Odds API](https://the-odds-api.com) requires an API key, here’s a
quick run-down:

- Using the key: You can save the key for consistent usage by adding
  `ODDS_API_KEY=XXXX-YOUR-API-KEY-HERE-XXXXX` to your .Renviron file
  (easily accessed via
  [**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html)).
  Run
  [**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html),
  a new script will pop open named `.Renviron`, **THEN** paste the
  following in the new script that pops up (with**out** quotations)

``` r

ODDS_API_KEY = XXXX-YOUR-API-KEY-HERE-XXXXX
```

Save the script and **restart your RStudio session**, by clicking
`Session` (in between `Plots` and `Build`) and click `Restart R` (there
also exists the shortcut `Ctrl + Shift + F10` to restart your session).
If set correctly, from then on you should be able to use any of the
functions without any other changes.

- For less consistent usage: At the beginning of every session or within
  an R environment, save your API key as the environment variable
  `ODDS_API_KEY` (with quotations) using a command like the following.

``` r

Sys.setenv(ODDS_API_KEY = "XXXX-YOUR-API-KEY-HERE-XXXXX")
```

### **The included data**

`toa_sports_keys` - The sports for which `The Odds API` provides
coverage

``` r

oddsapiR::toa_sports_keys %>%
  gt() %>% 
  gtExtras::gt_theme_538(table.width = px(650))
#> Table has no assigned ID, using random ID 'mwlefoodfi' to apply `gt::opt_css()`
#> Avoid this message by assigning an ID: `gt(id = '')` or `gt_theme_538(quiet = TRUE)`
```

| key | group | title | description | has_outrights |
|----|----|----|----|----|
| americanfootball_ncaaf | American Football | NCAAF | US College Football | FALSE |
| americanfootball_nfl | American Football | NFL | US Football | FALSE |
| americanfootball_nfl_super_bowl_winner | American Football | NFL Super Bowl Winner | Super Bowl Winner 2022/2023 | TRUE |
| aussierules_afl | Aussie Rules | AFL | Aussie Football | FALSE |
| baseball_mlb | Baseball | MLB | Major League Baseball | FALSE |
| baseball_mlb_world_series_winner | Baseball | MLB World Series Winner | World Series Winner 2022 | TRUE |
| basketball_euroleague | Basketball | Basketball Euroleague | Basketball Euroleague | FALSE |
| basketball_nba | Basketball | NBA | US Basketball | FALSE |
| basketball_nba_championship_winner | Basketball | NBA Championship Winner | Championship Winner 2021/2022 | TRUE |
| basketball_ncaab | Basketball | NCAAB | US College Basketball | FALSE |
| basketball_wnba | Basketball | WNBA | US Basketball | FALSE |
| cricket_big_bash | Cricket | Big Bash | Big Bash League | FALSE |
| cricket_icc_world_cup | Cricket | ICC World Cup | ICC World Cup | FALSE |
| cricket_ipl | Cricket | IPL | Indian Premier League | FALSE |
| cricket_odi | Cricket | One Day Internationals | One Day Internationals | FALSE |
| cricket_test_match | Cricket | Test Matches | International Test Matches | FALSE |
| golf_masters_tournament_winner | Golf | Masters Tournament Winner | 2023 Winner | TRUE |
| golf_pga_championship_winner | Golf | PGA Championship Winner | 2022 Winner | TRUE |
| golf_the_open_championship_winner | Golf | The Open Winner | 2022 Winner | TRUE |
| golf_us_open_winner | Golf | US Open Winner | 2022 Winner | TRUE |
| icehockey_nhl | Ice Hockey | NHL | US Ice Hockey | FALSE |
| icehockey_nhl_championship_winner | Ice Hockey | NHL Championship Winner | Stanley Cup Winner 2021/2022 | TRUE |
| icehockey_sweden_allsvenskan | Ice Hockey | HockeyAllsvenskan | Swedish Hockey Allsvenskan | FALSE |
| icehockey_sweden_hockey_league | Ice Hockey | SHL | Swedish Hockey League | FALSE |
| mma_mixed_martial_arts | Mixed Martial Arts | MMA | Mixed Martial Arts | FALSE |
| politics_us_presidential_election_winner | Politics | US Presidential Elections Winner | 2024 US Presidential Election Winner | TRUE |
| rugbyleague_nrl | Rugby League | NRL | Aussie Rugby League | FALSE |
| soccer_africa_cup_of_nations | Soccer | Africa Cup of Nations | Africa Cup of Nations | FALSE |
| soccer_argentina_primera_division | Soccer | Primera División - Argentina | Argentine Primera División | FALSE |
| soccer_australia_aleague | Soccer | A-League | Aussie Soccer | FALSE |
| soccer_belgium_first_div | Soccer | Belgium First Div | Belgian First Division A | FALSE |
| soccer_brazil_campeonato | Soccer | Brazil Série A | Brasileirão Série A | FALSE |
| soccer_china_superleague | Soccer | Super League - China |  | FALSE |
| soccer_conmebol_copa_libertadores | Soccer | Copa Libertadores | CONMEBOL Copa Libertadores | FALSE |
| soccer_denmark_superliga | Soccer | Denmark Superliga |  | FALSE |
| soccer_efl_champ | Soccer | Championship | EFL Championship | FALSE |
| soccer_england_efl_cup | Soccer | EFL Cup | League Cup | FALSE |
| soccer_england_league1 | Soccer | League 1 | EFL League 1 | FALSE |
| soccer_england_league2 | Soccer | League 2 | EFL League 2 | FALSE |
| soccer_epl | Soccer | EPL | English Premier League | FALSE |
| soccer_fa_cup | Soccer | FA Cup | Football Association Challenge Cup | FALSE |
| soccer_fifa_world_cup | Soccer | FIFA World Cup | FIFA World Cup 2022 | FALSE |
| soccer_fifa_world_cup_winner | Soccer | FIFA World Cup Winner | FIFA World Cup Winner 2022 | TRUE |
| soccer_finland_veikkausliiga | Soccer | Veikkausliiga - Finland |  | FALSE |
| soccer_france_ligue_one | Soccer | Ligue 1 - France |  | FALSE |
| soccer_france_ligue_two | Soccer | Ligue 2 - France | French Soccer | FALSE |
| soccer_germany_bundesliga | Soccer | Bundesliga - Germany | German Soccer | FALSE |
| soccer_germany_bundesliga2 | Soccer | Bundesliga 2 - Germany | German Soccer | FALSE |
| soccer_italy_serie_a | Soccer | Serie A - Italy | Italian Soccer | FALSE |
| soccer_italy_serie_b | Soccer | Serie B - Italy | Italian Soccer | FALSE |
| soccer_japan_j_league | Soccer | J League | Japan Soccer League | FALSE |
| soccer_korea_kleague1 | Soccer | K League 1 | Korean Soccer | FALSE |
| soccer_league_of_ireland | Soccer | League of Ireland | Airtricity League Premier Division | FALSE |
| soccer_mexico_ligamx | Soccer | Liga MX | Mexican Soccer | FALSE |
| soccer_netherlands_eredivisie | Soccer | Dutch Eredivisie | Dutch Soccer | FALSE |
| soccer_norway_eliteserien | Soccer | Eliteserien - Norway | Norwegian Soccer | FALSE |
| soccer_portugal_primeira_liga | Soccer | Primeira Liga - Portugal | Portugese Soccer | FALSE |
| soccer_russia_premier_league | Soccer | Premier League - Russia | Russian Soccer | FALSE |
| soccer_spain_la_liga | Soccer | La Liga - Spain | Spanish Soccer | FALSE |
| soccer_spain_segunda_division | Soccer | La Liga 2 - Spain | Spanish Soccer | FALSE |
| soccer_spl | Soccer | Premiership - Scotland | Scottish Premiership | FALSE |
| soccer_sweden_allsvenskan | Soccer | Allsvenskan - Sweden | Swedish Soccer | FALSE |
| soccer_sweden_superettan | Soccer | Superettan - Sweden | Swedish Soccer | FALSE |
| soccer_switzerland_superleague | Soccer | Swiss Superleague | Swiss Soccer | FALSE |
| soccer_turkey_super_league | Soccer | Turkey Super League | Turkish Soccer | FALSE |
| soccer_uefa_champs_league | Soccer | UEFA Champions | European Champions League | FALSE |
| soccer_uefa_europa_league | Soccer | UEFA Europa | European Europa League | FALSE |
| soccer_uefa_nations_league | Soccer | UEFA Nations League | UEFA Nations League | FALSE |
| soccer_usa_mls | Soccer | MLS | Major League Soccer | FALSE |
| tennis_atp_aus_open_singles | Tennis | ATP Australian Open | Men's Singles | FALSE |
| tennis_atp_french_open | Tennis | ATP French Open | Men's Singles | FALSE |
| tennis_atp_us_open | Tennis | ATP US Open | Men's Singles | FALSE |
| tennis_atp_wimbledon | Tennis | ATP Wimbledon | Men's Singles | FALSE |
| tennis_wta_aus_open_singles | Tennis | WTA Australian Open | Women's Singles | FALSE |
| tennis_wta_french_open | Tennis | WTA French Open | Women's Singles | FALSE |
| tennis_wta_us_open | Tennis | WTA US Open | Women's Singles | FALSE |
| tennis_wta_wimbledon | Tennis | WTA Wimbledon | Women's Singles | FALSE |

### **Three core functions**

One endpoint for looking up the sports the API provides (including
currently `active` status): `toa_sports`

``` r


oddsapiR::toa_sports(all_sports = TRUE) %>%
  head(n=10) %>% 
  gt() %>% 
  gtExtras::gt_theme_538(table.width = px(550))
#> Table has no assigned ID, using random ID 'eexombwkke' to apply `gt::opt_css()`
#> Avoid this message by assigning an ID: `gt(id = '')` or `gt_theme_538(quiet = TRUE)`
```

| key | group | title | description | active | has_outrights |
|----|----|----|----|----|----|
| americanfootball_cfl | American Football | CFL | Canadian Football League | TRUE | FALSE |
| americanfootball_ncaaf | American Football | NCAAF | US College Football | TRUE | FALSE |
| americanfootball_ncaaf_championship_winner | American Football | NCAAF Championship Winner | US College Football Championship Winner | TRUE | TRUE |
| americanfootball_nfl | American Football | NFL | US Football | TRUE | FALSE |
| americanfootball_nfl_preseason | American Football | NFL Preseason | US Football | TRUE | FALSE |
| americanfootball_nfl_super_bowl_winner | American Football | NFL Super Bowl Winner | Super Bowl Winner 2026/2027 | TRUE | TRUE |
| americanfootball_ufl | American Football | UFL | United Football League | TRUE | FALSE |
| aussierules_afl | Aussie Rules | AFL | Aussie Football | TRUE | FALSE |
| baseball_kbo | Baseball | KBO | KBO League | TRUE | FALSE |
| baseball_milb | Baseball | MiLB | Minor League Baseball | FALSE | FALSE |

One endpoint for looking up the current odds from the API:
`toa_sports_odds`

``` r

oddsapiR::toa_sports_odds(sport_key = 'basketball_nba', 
                          regions = 'us', 
                          markets = 'spreads', 
                          odds_format = 'decimal',
                          date_format = 'iso') %>% 
  dplyr::select(c("bookmaker","market_key", "outcomes_name","outcomes_price","outcomes_point","home_team","away_team","commence_time")) %>% 
  head(n=20) %>% 
  knitr::kable()
```

| bookmaker | market_key | outcomes_name | outcomes_price | outcomes_point | home_team | away_team | commence_time |
|:---|:---|:---|---:|---:|:---|:---|:---|
| FanDuel | spreads | New York Knicks | 1.85 | -1.5 | New York Knicks | San Antonio Spurs | 2026-06-11T00:40:00Z |
| FanDuel | spreads | San Antonio Spurs | 1.96 | 1.5 | New York Knicks | San Antonio Spurs | 2026-06-11T00:40:00Z |
| BetRivers | spreads | New York Knicks | 1.87 | -1.5 | New York Knicks | San Antonio Spurs | 2026-06-11T00:40:00Z |
| BetRivers | spreads | San Antonio Spurs | 1.93 | 1.5 | New York Knicks | San Antonio Spurs | 2026-06-11T00:40:00Z |
| DraftKings | spreads | New York Knicks | 1.87 | -1.5 | New York Knicks | San Antonio Spurs | 2026-06-11T00:40:00Z |
| DraftKings | spreads | San Antonio Spurs | 1.95 | 1.5 | New York Knicks | San Antonio Spurs | 2026-06-11T00:40:00Z |
| BetOnline.ag | spreads | New York Knicks | 1.91 | -2.0 | New York Knicks | San Antonio Spurs | 2026-06-11T00:40:00Z |
| BetOnline.ag | spreads | San Antonio Spurs | 1.91 | 2.0 | New York Knicks | San Antonio Spurs | 2026-06-11T00:40:00Z |
| LowVig.ag | spreads | New York Knicks | 1.94 | -2.0 | New York Knicks | San Antonio Spurs | 2026-06-11T00:40:00Z |
| LowVig.ag | spreads | San Antonio Spurs | 1.94 | 2.0 | New York Knicks | San Antonio Spurs | 2026-06-11T00:40:00Z |
| MyBookie.ag | spreads | New York Knicks | 1.91 | -2.0 | New York Knicks | San Antonio Spurs | 2026-06-11T00:40:00Z |
| MyBookie.ag | spreads | San Antonio Spurs | 1.91 | 2.0 | New York Knicks | San Antonio Spurs | 2026-06-11T00:40:00Z |
| BetMGM | spreads | New York Knicks | 1.87 | -1.5 | New York Knicks | San Antonio Spurs | 2026-06-11T00:40:00Z |
| BetMGM | spreads | San Antonio Spurs | 1.95 | 1.5 | New York Knicks | San Antonio Spurs | 2026-06-11T00:40:00Z |
| Bovada | spreads | New York Knicks | 1.95 | -2.0 | New York Knicks | San Antonio Spurs | 2026-06-11T00:40:00Z |
| Bovada | spreads | San Antonio Spurs | 1.87 | 2.0 | New York Knicks | San Antonio Spurs | 2026-06-11T00:40:00Z |

Note: There are two entries per event per bookmaker for the spreads for
both sides of the event.

One endpoint for looking up the current scores from the API:
`toa_sports_scores`

``` r

oddsapiR::toa_sports_scores(sport_key = 'basketball_nba', 
                            days_from = NULL,
                            date_format = 'iso') %>% 
  head(n=20) %>% 
  knitr::kable()
```

| id | sport_key | sport_title | commence_time | completed | home_team | away_team | scores | last_update |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| 9ea306ebbe68ff94dfa5b88d1e250b37 | basketball_nba | NBA | 2026-06-11T00:40:00Z | FALSE | New York Knicks | San Antonio Spurs | NA | NA |

## **Our Authors**

- [Saiem Gilani](https://twitter.com/saiemgilani)  
  [![@saiemgilani](https://img.shields.io/twitter/follow/saiemgilani?color=blue&label=%40saiemgilani&logo=twitter&style=for-the-badge)](https://twitter.com/saiemgilani)
  [![@saiemgilani](https://img.shields.io/github/followers/saiemgilani?color=eee&logo=Github&style=for-the-badge)](https://github.com/saiemgilani)

## **Citations**

To cite the [**`oddsapiR`**](https://oddsapiR.sportsdataverse.org) R
package in publications, use:

BibTex Citation

``` bibtex
@misc{gilani_2022_oddsapiR,
  author = {Gilani, Saiem},
  title = {oddsapiR: The SportsDataverse's R Package for The Odds API.},
  url = {https://oddsapiR.sportsdataverse.org},
  year = {2022}
}
```
