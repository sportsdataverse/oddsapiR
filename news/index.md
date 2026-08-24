# Changelog

## oddsapiR 1.0.0

First major release. Full coverage of The Odds API v4, an `httr2` HTTP
stack, and per-request usage-quota reporting.

#### New features

- Five new endpoint wrappers complete the v4 surface:
  - **[`toa_sports_events()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_events.md)**
    – in-play and upcoming events for a sport
    (`/v4/sports/{sport}/events`).
  - **[`toa_event_markets()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_markets.md)**
    – available market keys per bookmaker for a single event
    (`/v4/sports/{sport}/events/{eventId}/markets`).
  - **[`toa_sports_participants()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_participants.md)**
    – teams or players for a sport (`/v4/sports/{sport}/participants`).
  - **[`toa_sports_events_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_events_history.md)**
    – historical events snapshot
    (`/v4/historical/sports/{sport}/events`).
  - **[`toa_event_odds_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds_history.md)**
    – historical single-event odds
    (`/v4/historical/sports/{sport}/events/{eventId}/odds`).
- **[`toa_quota()`](https://oddsapiR.sportsdataverse.org/reference/toa_quota.md)**
  – new exported accessor returning the usage credits
  (`requests_remaining`, `requests_used`, `requests_last`) from the most
  recent call. The same values are attached as attributes to every
  returned tibble and echoed when an `oddsapiR_data` object is printed.
- Every wrapper’s `@return` documentation is now a 3-column table
  (`col_name | types | description`) and carries a **Usage quota cost**
  note.

#### Breaking changes

- The HTTP stack migrated from `httr` to **`httr2`**. `httr` and
  `janitor` were removed from Imports; `tibble` was promoted to Imports.
- **[`toa_sports_odds_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_odds_history.md)**
  now calls the current `/v4/historical/sports/{sport}/odds` endpoint
  (the legacy `/v4/sports/{sport}/odds-history` path is deprecated
  upstream). Its signature changed: `date` is now the required second
  argument and `event_ids` is an optional filter. The return gains
  leading `timestamp`, `previous_timestamp` and `next_timestamp`
  columns.

#### Bug fixes

- **[`toa_event_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds.md)**
  and
  **[`toa_event_odds_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds_history.md)**
  now return a zero-row tibble carrying the documented column schema
  (with an informative message) when the event exists but its
  `bookmakers` array is empty – e.g. no lines posted yet for the
  requested markets/regions – instead of erroring with a misleading
  “Invalid arguments” alert
  ([\#4](https://github.com/sportsdataverse/oddsapiR/issues/4)).
- Wrappers now initialize their return variable before the `tryCatch`,
  so an API error (500/timeout/connection reset) returns an empty tibble
  and a `cli` message instead of throwing `object '...' not found`.
- **[`toa_event_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds.md)**
  parsing is more robust (builds an explicit tibble rather than
  `as_tibble(data = ".")`) and surfaces `outcomes_description` for
  player-prop markets.
- Returns are self-describing:
  [`toa_sports_participants()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_participants.md)
  echoes `sport_key`, and the historical wrappers surface the snapshot
  timestamps.

#### Test infrastructure

- Tests added for all new functions; legacy tests hardened to gate on
  [`has_toa_key()`](https://oddsapiR.sportsdataverse.org/reference/register_toa.md),
  skip on empty/out-of-season responses, and assert columns
  subset-direction (`expect_in(sort(cols), sort(colnames(x)))`) so
  upstream column additions don’t break the suite.

#### Infrastructure & tooling

- GitHub Actions workflows modernized for the Node 24 runtime
  (`actions/checkout@v5`, `r-lib/actions/*@v2`, `check-r-package`,
  pak-based dependency installs).
- Added project meta files: `CLAUDE.md`, `CONTRIBUTING.md`,
  `CODE_OF_CONDUCT.md`, `.github/copilot-instructions.md`, issue
  templates, and a pull request template.
- `README` installation now leads with `pak` (with `devtools` as an
  alternative).

## oddsapiR 0.0.3

CRAN release: 2023-03-19

- [`toa_event_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds.md)
  function added
- [`toa_sports_odds_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_odds_history.md)
  function added

## oddsapiR 0.0.2

CRAN release: 2023-01-05

- Minor under the hood changes for tidyselect deprecation of .data\$
  masking

## oddsapiR 0.0.1

CRAN release: 2022-06-22

- Added a `NEWS.md` file to track changes to the package.
- Four core exported functions:
  - **[`toa_sports()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports.md)**:
    Get the Sports for which the Odds API provides coverage
  - **[`toa_sports_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_odds.md)**:
    Get the odds for the sports which the Odds API provides coverage
  - **[`toa_sports_scores()`](https://oddsapiR.sportsdataverse.org/reference/toa_sports_scores.md)**:
    Get the scores for the sports which the Odds API provides coverage
  - **[`toa_requests()`](https://oddsapiR.sportsdataverse.org/reference/toa_requests.md)**:
    Get your usage and remaining calls for your key from The Odds API
- Tests added for each of the above functions.
