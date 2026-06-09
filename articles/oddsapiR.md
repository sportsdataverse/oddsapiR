# Getting started with oddsapiR

Welcome folks,

I’m Saiem Gilani, one of the
[authors](https://saiemgilani.github.io/oddsapiR/authors.html "Authors and contributors to oddsapiR")
of [`oddsapiR`](https://saiemgilani.github.io/oddsapiR/), and I hope to
give the community a high-quality resource for accessing
[**`The Odds API`**](https://the-odds-api.com/).

`oddsapiR` provides a tidy R interface to [The Odds
API](https://the-odds-api.com), covering sports discovery, events, live
and historical odds, scores, and quota management. All functions return
[`oddsapiR_data`](https://oddsapiR.sportsdataverse.org/reference/index.html)
tibbles with quota metadata attached as attributes.

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

## **Odds API Keys**

The [Odds API](https://the-odds-api.com) requires an API key, here’s a
quick run-down:

- **Persistent usage:** Save the key for consistent usage by adding
  `ODDS_API_KEY=XXXX-YOUR-API-KEY-HERE-XXXXX` to your `.Renviron` file
  (easily accessed via
  [**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html)).
  Run
  [`usethis::edit_r_environ()`](https://usethis.r-lib.org/reference/edit.html),
  a new script will pop open named `.Renviron`, **THEN** paste the
  following in the new script that pops up (with**out** quotations):

``` r

ODDS_API_KEY = XXXX-YOUR-API-KEY-HERE-XXXXX
```

Save the script and **restart your RStudio session**, by clicking
`Session` (in between `Plots` and `Build`) and click `Restart R` (there
also exists the shortcut `Ctrl + Shift + F10` to restart your session).
If set correctly, from then on you should be able to use any of the
functions without any other changes.

- **Session-level usage:** At the beginning of every session or within
  an R environment, save your API key as the environment variable
  `ODDS_API_KEY` (with quotations) using a command like the following.

``` r

Sys.setenv(ODDS_API_KEY = "XXXX-YOUR-API-KEY-HERE-XXXXX")
```

The helper functions
[`toa_key()`](https://oddsapiR.sportsdataverse.org/reference/register_toa.md),
[`has_toa_key()`](https://oddsapiR.sportsdataverse.org/reference/register_toa.md),
and
[`check_toa_key()`](https://oddsapiR.sportsdataverse.org/reference/register_toa.md)
let you inspect the key at any point.
[`has_toa_key()`](https://oddsapiR.sportsdataverse.org/reference/register_toa.md)
returns `TRUE`/`FALSE`;
[`check_toa_key()`](https://oddsapiR.sportsdataverse.org/reference/register_toa.md)
stops with a helpful message when no key is found.

``` r

has_toa_key()      # TRUE / FALSE
toa_key()          # the raw key string (or NA)
check_toa_key()    # errors loudly if key is missing
```

## **How oddsapiR talks to The Odds API**

Every `toa_*()` function calls the same underlying HTTP layer in
`R/utils.R`:

1.  **`toa_api_request(url, query)`** — builds an `httr2` request,
    attaches a standard user-agent (`oddsapiR/...`), applies a 3-try
    retry policy on transient network failures, and calls
    [`httr2::req_perform()`](https://httr2.r-lib.org/reference/req_perform.html).
2.  **`toa_api_call(url, query)`** — wraps
    [`toa_api_request()`](https://oddsapiR.sportsdataverse.org/reference/toa_api_request.md),
    reads the response body as a string, and parses it with
    [`jsonlite::fromJSON()`](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html).
    Used by every odds/events/scores endpoint.
3.  **`toa_api_headers(url, query)`** — wraps
    [`toa_api_request()`](https://oddsapiR.sportsdataverse.org/reference/toa_api_request.md)
    and reads only the `x-requests-remaining` / `x-requests-used`
    headers. Used by
    [`toa_requests()`](https://oddsapiR.sportsdataverse.org/reference/toa_requests.md).

The base URL pattern for v4 is:

    https://api.the-odds-api.com/v4/sports/{sport_key}/odds
                                                      /events
                                                      /participants
                                                      /scores
    https://api.the-odds-api.com/v4/historical/sports/{sport_key}/odds
                                                                 /events

The API key is passed as the `apiKey` query parameter in every request.

### **Quota tracking**

Every successful response from The Odds API includes three headers:

| Header                 | Meaning                                          |
|:-----------------------|:-------------------------------------------------|
| `x-requests-remaining` | Credits remaining until the monthly quota resets |
| `x-requests-used`      | Credits consumed since the last quota reset      |
| `x-requests-last`      | Cost of the most recent call                     |

`oddsapiR` caches these after every call in a package-private
environment (`.oddsapiR`). They are also attached as attributes to every
returned tibble so they travel with the data:

``` r

odds <- toa_sports_odds(sport_key = 'basketball_nba', regions = 'us', markets = 'h2h')

# Inspect quota without making another call
toa_quota()
# # A tibble: 1 x 3
# requests_remaining requests_used requests_last
#              <int>         <int>         <int>
#               9850           150             1

attr(odds, "oddsapiR_requests_remaining")
attr(odds, "oddsapiR_requests_used")
attr(odds, "oddsapiR_requests_last")
```

The `print.oddsapiR_data()` method echoes these values when you print
any result.

### **Key parameters: regions, markets, odds_format**

Most odds endpoints accept these three shared parameters:

- **`regions`** — which bookmakers to include: `"us"`, `"us2"`, `"uk"`,
  `"eu"`, `"au"`. Comma-separate for multiple (`"us,uk"`). Each region
  counts as 1 unit in the usage quota multiplier.
- **`markets`** — which betting lines to return: `"h2h"` (moneyline),
  `"spreads"` (point handicap), `"totals"` (over/under), `"outrights"`
  (futures). Comma-separate for multiple (`"h2h,spreads"`). Each market
  counts as 1 unit in the quota multiplier.
- **`odds_format`** — `"decimal"` (default) or `"american"`.

**Quota cost** for
[`toa_sports_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_odds.md)
= number of markets × number of regions. So pulling
`"h2h,spreads,totals"` across `"us,uk"` costs 3 × 2 = 6 credits.

### **Historical endpoints and the snapshot model**

[`toa_sports_odds_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_odds_history.md),
[`toa_sports_events_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_events_history.md),
and
[`toa_event_odds_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds_history.md)
operate on a snapshot model: you supply an ISO 8601 `date` timestamp and
the API returns the state of the data at the closest snapshot equal to
or earlier than that time. The response always includes `timestamp`,
`previous_timestamp`, and `next_timestamp` columns so you can page
through the archive programmatically.

## **The included data**

`toa_sports_keys` is a bundled data frame listing all sports the API
covers. This data requires no API key and no network access — it is
included in the package:

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

## **Function reference by family**

### **Sports & Events**

#### `toa_sports()` — Discover active sports

Returns all sports the API covers (or only in-season ones). The `key`
column is the `sport_key` parameter used by every other function. Free —
does not count against your quota.

``` r

sports <- toa_sports(all_sports = TRUE)
# Returns a tibble with columns:
#   key, group, title, description, active, has_outrights
#
# key              group                title         active
# basketball_nba   Basketball           NBA           TRUE
# soccer_epl       Soccer               EPL           TRUE
# ...
```

#### `toa_sports_events()` — List upcoming events for a sport

Returns upcoming and in-play events (without odds). The `id` column from
this result is the `event_id` used by
[`toa_event_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds.md)
and
[`toa_event_markets()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_markets.md).
Free — does not count against your quota.

``` r

events <- toa_sports_events(
  sport_key          = 'basketball_nba',
  date_format        = 'iso',
  commence_time_from = '2025-01-15T00:00:00Z',
  commence_time_to   = '2025-01-16T00:00:00Z'
)
# Returns a tibble: id, sport_key, sport_title, commence_time, home_team, away_team
#
# id                                sport_key       home_team          away_team
# 48db9c3293a52baab881d95d38f37a98  basketball_nba  Los Angeles Lakers  Boston Celtics
```

#### `toa_sports_participants()` — List participants (teams or players) for a sport

Returns the whitelist of teams or individual competitors for a sport.
Cost: 1 credit.

``` r

participants <- toa_sports_participants(sport_key = 'basketball_nba')
# Returns a tibble: sport_key, id, full_name
#
# sport_key       id                              full_name
# basketball_nba  par_01hqmkq6fdf1pvq7jgdd7hdmpf  Los Angeles Lakers
# basketball_nba  par_01hqmkq6fdf1pvq7jgdd7hdmpe  Boston Celtics
```

#### `toa_sports_scores()` — Live and recent scores

Returns live and recently completed games with scores (updated ~30s for
live games; covers completed games within the last 3 days). Cost: 1
credit without `days_from`, 2 credits with it.

``` r

scores <- toa_sports_scores(
  sport_key   = 'basketball_nba',
  days_from   = 1,          # include games completed in the last 1 day
  date_format = 'iso'
)
# Returns a tibble:
#   id, sport_key, sport_title, commence_time, completed, home_team, away_team,
#   scores (list-col of name/score pairs), last_update
```

### **Current Odds & Markets**

#### `toa_sports_odds()` — Featured-market odds across all events for a sport

The primary odds endpoint. Returns a **long-format** tibble — one row
per (event, bookmaker, market, outcome). Cost = markets × regions.

``` r

odds <- toa_sports_odds(
  sport_key   = 'basketball_nba',
  regions     = 'us',
  markets     = 'h2h,spreads,totals',
  odds_format = 'decimal',
  date_format = 'iso'
)
# Returns columns:
#   id, sport_key, sport_title, commence_time, home_team, away_team,
#   bookmaker_key, bookmaker, bookmaker_last_update,
#   market_key, market_last_update,
#   outcomes_name, outcomes_price, outcomes_point
#
# Note: spreads and totals have TWO rows per event per bookmaker
#       (one for each side / Over / Under).
```

#### `toa_event_odds()` — Full market depth for a single event

Like
[`toa_sports_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_odds.md)
but scoped to one game and supports **all** available market keys,
including player props (`player_points`, `player_pass_tds`,
`player_shots_on_goal`, etc.) and alternate lines. Look up `event_id`
first with
[`toa_sports_events()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_events.md).

``` r

event_odds <- toa_event_odds(
  sport_key   = 'basketball_nba',
  event_id    = '48db9c3293a52baab881d95d38f37a98',
  regions     = 'us',
  markets     = 'player_points',   # player props
  odds_format = 'decimal',
  date_format = 'iso'
)
# Adds outcomes_description column (player name for props)
```

You can also target specific bookmakers with the `bookmakers` parameter
(comma-separated slugs like `"draftkings,fanduel"`). When `bookmakers`
and `regions` are both supplied, `bookmakers` takes precedence.

#### `toa_event_markets()` — Discover available market keys for a game

Returns the recently-seen market keys per bookmaker for a single event
(no odds). Use the returned `market_key` values to then request odds via
[`toa_event_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds.md).
Cost: 1 credit.

``` r

markets <- toa_event_markets(
  sport_key = 'basketball_nba',
  event_id  = '48db9c3293a52baab881d95d38f37a98',
  regions   = 'us'
)
# Returns: id, sport_key, sport_title, commence_time, home_team, away_team,
#          bookmaker_key, bookmaker, market_key, market_last_update
#
# Typical market_key values: h2h, spreads, totals, player_points,
#                             player_rebounds, player_assists, ...
```

### **Historical Odds & Events (paid plans)**

Historical endpoints return the API state at a point in time. All three
accept an ISO 8601 `date` string and respond with the snapshot closest
to (and not after) that time. The `timestamp`, `previous_timestamp`, and
`next_timestamp` columns in the result let you page through the archive.

Historical data covers featured markets back to June 2020, and
additional markets (props, alternate lines) from 2023-05-03 at 5-minute
intervals.

#### `toa_sports_odds_history()` — Historical featured-market odds for a sport

``` r

hist_odds <- toa_sports_odds_history(
  sport_key   = 'basketball_nba',
  date        = '2024-01-15T12:15:00Z',
  regions     = 'us',
  markets     = 'spreads',
  odds_format = 'decimal',
  date_format = 'iso'
)
# Returns same columns as toa_sports_odds() plus:
#   timestamp, previous_timestamp, next_timestamp
#
# Cost: 10 x markets x regions (10x historical multiplier)
```

#### `toa_sports_events_history()` — Historical event list (no odds)

``` r

hist_events <- toa_sports_events_history(
  sport_key = 'basketball_nba',
  date      = '2024-01-15T12:15:00Z'
)
# Returns same columns as toa_sports_events() plus:
#   timestamp, previous_timestamp, next_timestamp
#
# Cost: 1 credit
```

#### `toa_event_odds_history()` — Historical odds for a single event

Like
[`toa_event_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds.md)
for a specific snapshot time. Accepts player props and alternate
markets.

``` r

hist_event_odds <- toa_event_odds_history(
  sport_key   = 'basketball_nba',
  event_id    = '93af4b300a4c0dded909234ea32e9abd',
  date        = '2024-01-15T12:15:00Z',
  regions     = 'us',
  markets     = 'h2h',
  odds_format = 'decimal',
  date_format = 'iso'
)
# Returns same columns as toa_event_odds() plus:
#   timestamp, previous_timestamp, next_timestamp
#
# Cost: markets x regions (standard rate, no 10x multiplier for event-level)
```

### **Account & Usage**

#### `toa_quota()` — Inspect your current quota balance

Returns a one-row tibble read from the headers of the **most recent**
API call made in this R session. Calling
[`toa_quota()`](https://oddsapiR.sportsdataverse.org/reference/toa_quota.md)
does not itself use a quota credit.

``` r

# After any toa_* call:
toa_quota()
# # A tibble: 1 x 3
#   requests_remaining requests_used requests_last
#                <int>         <int>         <int>
#                 9850           150             1
```

#### `toa_requests()` — Fetch quota from the API directly

Hits the free `/v4/sports` endpoint specifically to read the current
quota balance from the response headers. Use this at the start of a
session to check your budget before pulling odds.

``` r

toa_requests()
# # A tibble: 1 x 2
#   requests_remaining requests_used
#                <int>         <int>
#                 9850           150
```

#### Key helpers: `toa_key()`, `has_toa_key()`, `check_toa_key()`

``` r

toa_key()         # Returns the ODDS_API_KEY env var or NA_character_
has_toa_key()     # Returns TRUE if key is set, FALSE otherwise
check_toa_key()   # Stops with a clear error if key is missing
```

## **Worked example — pulling moneyline odds**

This minimal example shows the basic pattern: check quota first, pull
odds, inspect the result.

``` r

library(oddsapiR)
library(dplyr)

# 1. Verify a key exists and check starting budget
check_toa_key()
toa_requests()
# requests_remaining = 500, requests_used = 0

# 2. Pull moneyline (h2h) odds for the NBA from US books
nba_h2h <- toa_sports_odds(
  sport_key   = "basketball_nba",
  regions     = "us",
  markets     = "h2h",
  odds_format = "decimal",
  date_format = "iso"
)

# 3. Inspect: one row per (event x bookmaker x outcome)
glimpse(nba_h2h)
# Rows: ~120
# Columns: id, sport_key, sport_title, commence_time, home_team, away_team,
#           bookmaker_key, bookmaker, bookmaker_last_update,
#           market_key, market_last_update, outcomes_name, outcomes_price

# 4. Find the best moneyline price for each team across all books
best_lines <- nba_h2h %>%
  group_by(home_team, away_team, outcomes_name) %>%
  slice_max(outcomes_price, n = 1) %>%
  select(home_team, away_team, outcomes_name, bookmaker, outcomes_price)

best_lines
# home_team           away_team      outcomes_name       bookmaker    outcomes_price
# Los Angeles Lakers  Boston Celtics Los Angeles Lakers  DraftKings            2.05
# Los Angeles Lakers  Boston Celtics Boston Celtics      FanDuel               1.87

# 5. Check how much that cost
toa_quota()
# requests_remaining = 499, requests_used = 1, requests_last = 1
```

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
