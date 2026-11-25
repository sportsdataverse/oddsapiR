# Changelog

## oddsapiR (development version)

#### Bug fixes

- An HTTP error from The Odds API is now reported instead of returned as
  data. The request layer turned off httr2’s status errors, so a 401
  (invalid key), 422 (invalid parameter) or 429 (usage quota reached)
  error body was parsed like a result, and most wrappers returned it as
  a one-row data frame; only the single-event odds wrappers checked for
  it. Every request now raises an error of class `oddsapiR_http_error`,
  carrying `status` and `url`, on any non-2xx answer, and the function
  reports it (for example
  `HTTP 429 Too Many Requests from https://api.the-odds-api.com/v4/sports/basketball_nba/odds: Usage quota has been reached`)
  and returns an empty data frame. The URL is shown without its query
  string, so the API key never appears in a message.
- [`toa_event_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds.md)
  and
  [`toa_event_odds_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds_history.md)
  no longer print the API key when The Odds API answers with status 200
  but an error body whose message repeats the key. That message is now
  scrubbed the same way as a non-2xx error’s: both checks share one
  helper, which replaces the key, and also its URL-encoded copy, with
  `<apiKey>`.
- The API key is now scrubbed from every error a function reports, not
  only the two status checks. Each wrapper’s error handler printed the
  cause as it came, so a network failure or a parse error whose message
  quoted the request URL showed the key; all 11 wrappers now print the
  cause through the same scrub, and so does the `oddsapiR_warning` a
  wrapper re-raises. A non-2xx answer is also scrubbed with the key the
  request was sent with and the session key (`ODDS_API_KEY`), not only
  the key in the response URL, which a redirect can drop.
- `testthat` in Suggests now requires version 3.1.9 or later, the
  release that added `expect_in()`, which the tests use.
- Warnings no longer cut a result short. All 11 wrappers ran their
  request and parse inside a
  [`tryCatch()`](https://rdrr.io/r/base/conditions.html) with a
  `warning =` handler, so any warning (a coercion `NA`, a partial read)
  stopped the parse there: the warning was printed as a message and the
  function returned an empty data frame. Each warning is now raised as
  an R warning of class `oddsapiR_warning` that names the function, for
  example `toa_sports_odds(): NAs introduced by coercion`, and the
  function finishes and returns its data. Since these are now warnings
  rather than messages,
  [`suppressMessages()`](https://rdrr.io/r/base/message.html) no longer
  hides them; wrap the call as
  `suppressWarnings(toa_sports(), classes = "oddsapiR_warning")`. A
  classed warning (an rlang or lifecycle one, say) also keeps its own
  class.
- Error messages now print the underlying error message
  ([`conditionMessage()`](https://rdrr.io/r/base/conditions.html))
  instead of the whole condition object.
- `inst/CITATION` is now included in the package: an `^inst*` pattern in
  `.Rbuildignore`, which matches every path starting with `ins`, dropped
  it from the built tarball, so `citation("oddsapiR")` fell back to the
  auto-generated entry.

#### Dependencies

- rvest is no longer imported; nothing in the package used it.

#### Tests

- Every wrapper now has an offline test that replays a recorded Odds API
  response (`tests/testthat/fixtures/http/`, recorded by
  `data-raw/http_fixtures/record_fixtures.R`), so the suite covers the
  parsers without an `ODDS_API_KEY` or network access. The API key is
  replaced by `REDACTED` in every recorded URL. New tests also cover
  each wrapper’s error and warning paths and the internal helpers; local
  coverage without a key is 100%.

## oddsapiR 1.0.1

CRAN release: 2026-08-27

CRAN fix release, addressing the `--run-donttest` check failure reported
on 2026-08-25.

#### Bug fixes

- Printing an `oddsapiR_data` tibble no longer errors with “missing
  value where TRUE/FALSE needed”. The Odds API omits its `x-requests-*`
  usage headers on error responses, which stored a zero-length quota
  value; the print method’s guard then evaluated to `NA`. Absent or
  unparseable headers are now recorded as `NA_integer_`, and the guard
  is length-safe.
- **[`toa_event_odds()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds.md)**
  and
  **[`toa_event_odds_history()`](https://oddsapiR.sportsdataverse.org/reference/toa_event_odds_history.md)**
  no longer report an API error response (an invalid key, say) as “event
  found, but no bookmaker odds are available yet”. The API’s own error
  message is surfaced instead, so a failed request is never mistaken for
  an event with no odds posted.

#### Infrastructure & tooling

- Examples that call the live API are guarded with
  `@examplesIf has_toa_key()`, so they are skipped where no API key is
  configured rather than making a doomed request.

## oddsapiR 1.0.0

CRAN release: 2026-08-24

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
