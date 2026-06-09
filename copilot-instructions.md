# GitHub Copilot Instructions – oddsapiR

These instructions tell GitHub Copilot (and other AI coding assistants)
how to write code that fits this repository. `oddsapiR` is an R client
for [The Odds API v4](https://the-odds-api.com). Every exported function
is prefixed `toa_` and returns an `oddsapiR_data` tibble.

For the authoritative, fuller guide see
[CLAUDE.md](https://oddsapiR.sportsdataverse.org/CLAUDE.md) and
[CONTRIBUTING.md](https://oddsapiR.sportsdataverse.org/CONTRIBUTING.md).

## Golden rules

1.  **Never call `httr2`/`httr` directly from a wrapper.** Route every
    request through
    [`toa_api_call()`](https://oddsapiR.sportsdataverse.org/reference/toa_api_call.md)
    /
    [`toa_api_headers()`](https://oddsapiR.sportsdataverse.org/reference/toa_api_headers.md)
    in `R/utils.R`.
2.  **Initialize the return variable before `tryCatch`**
    (e.g. `odds <- data.frame()`).
3.  **Build the query list unconditionally** –
    [`httr2::req_url_query()`](https://httr2.r-lib.org/reference/req_url.html)
    drops `NULL` values.
4.  **`@return` tables are 3-column**: `col_name | types | description`.
5.  **Tests use subset-direction assertions**
    (`expect_in(sort(cols), sort(colnames(x)))`).
6.  **Use `cli::cli_alert_*` for messages**, never bare
    [`message()`](https://rdrr.io/r/base/message.html).
7.  **Never hard-code or commit an `ODDS_API_KEY`.**
8.  **Never add AI assistants as commit co-authors.**

## The HTTP layer

`R/utils.R` provides the shared stack. Do not reimplement it:

- `toa_api_request(url, query)` – builds an `httr2` request, applies the
  user agent + retry policy, performs it, and caches the `x-requests-*`
  usage headers. Returns the response.
- `toa_api_call(url, query)` –
  [`toa_api_request()`](https://oddsapiR.sportsdataverse.org/reference/toa_api_request.md) +
  parse JSON body. Returns a list/data.frame.
- `toa_api_headers(url, query)` –
  [`toa_api_request()`](https://oddsapiR.sportsdataverse.org/reference/toa_api_request.md) +
  return the quota usage data.frame.
- `make_toa_data(df, type, timestamp)` – tags the tibble as
  `oddsapiR_data` and attaches the timestamp/type and the cached quota
  attributes.
- [`toa_quota()`](https://oddsapiR.sportsdataverse.org/reference/toa_quota.md)
  – exported accessor for the most recent call’s usage credits.

## Canonical wrapper template

``` r

#' @name toa_resource
#' @title **Get <thing> from The Odds API**
#' @description
#' **<one-line description>.**
#'
#' **Usage quota cost:** <Free | markets × regions | 1 | 10 × markets × regions>.
#' @param sport_key (*string*, required): The `sport_key`. See [toa_sports()].
#' @param regions (*string*, required): Comma-delimited regions (`us`, `us2`, `uk`, `eu`, `au`).
#' @return A tibble with one row per <unit>:
#'
#'    |col_name  |types     |description                         |
#'    |:---------|:---------|:-----------------------------------|
#'    |id        |character |Unique event id.                    |
#'    |sport_key |character |Sport key, e.g. `basketball_nba`.   |
#'
#' @keywords Betting Lines
#' @importFrom cli cli_alert_danger
#' @importFrom glue glue
#' @importFrom dplyr rename
#' @importFrom rlang .data
#' @import tidyr
#' @export
#' @examples \donttest{
#'    try(toa_resource(sport_key = 'basketball_nba', regions = 'us'))
#' }
toa_resource <- function(sport_key, regions = 'us', date_format = 'iso'){
  base_url <- glue::glue('https://api.the-odds-api.com/v4/sports/{sport_key}/resource')
  query_params <- list(
    apiKey     = as.character(toa_key()),
    regions    = regions,
    dateFormat = date_format
  )

  resource <- data.frame()   # MANDATORY: initialize before tryCatch

  tryCatch(
    expr = {
      resource <- toa_api_call(base_url, query = query_params) %>%
        # parse: unnest bookmakers -> markets -> outcomes, rename key/last_update
        make_toa_data("Resource data from the-odds-api.com", Sys.time())
    },
    error = function(e) {
      cli::cli_alert_danger("{Sys.time()}: Invalid arguments or no data available for {sport_key}!")
      cli::cli_alert_danger("Error:\n{e}")
    },
    warning = function(w) {
      cli::cli_alert_warning("{Sys.time()}: Warning:\n{w}")
    },
    finally = {}
  )
  return(resource)
}
```

## Parsing notes

- Odds nest `bookmakers[] -> markets[] -> outcomes[]`. Rename ambiguous
  fields per level: `key -> bookmaker_key` / `market_key`,
  `title -> bookmaker`, `last_update -> bookmaker_last_update` /
  `market_last_update`. Finish with
  `tidyr::unnest("outcomes", names_sep = "_")` (-\>
  `outcomes_name`/`_price`/`_point`).
- The **current** event-odds endpoint has **no** bookmaker-level
  `last_update`; the `/odds` and historical endpoints do. Do not copy
  the `bookmaker_last_update` rename blindly.
- Single-event responses are one object – wrap as a 1-row tibble with a
  `bookmakers = list(raw$bookmakers)` list-column
  ([`tibble::tibble`](https://tibble.tidyverse.org/reference/tibble.html))
  before unnesting.
- Historical endpoints wrap the payload in
  `{timestamp, previous_timestamp, next_timestamp, data}`; surface the
  three timestamps as leading columns (`.before = 1`).
- Player-prop markets add an `outcomes_description` column; `h2h` has no
  `outcomes_point`.

## Endpoints (all 10)

`/v4/sports` (free), `/v4/sports/{sport}/odds`,
`/v4/sports/{sport}/scores`, `/v4/sports/{sport}/events` (free),
`/v4/sports/{sport}/events/{eventId}/odds`,
`/v4/sports/{sport}/events/{eventId}/markets`,
`/v4/sports/{sport}/participants`, `/v4/historical/sports/{sport}/odds`,
`/v4/historical/sports/{sport}/events`,
`/v4/historical/sports/{sport}/events/{eventId}/odds`. The legacy
`/v4/sports/{sport}/odds-history` path is deprecated.

## Tests

``` r

test_that("The Odds API - Resource", {
  skip_on_cran()
  skip_if_not(has_toa_key(), "ODDS_API_KEY not set")

  x <- toa_resource(sport_key = 'basketball_nba', regions = 'us')
  if (!is.data.frame(x) || nrow(x) == 0) skip("No rows returned at test time")

  cols <- c("id", "sport_key")
  expect_in(sort(cols), sort(colnames(x)))   # expected ⊆ actual
  expect_s3_class(x, "data.frame")
})
```

## After changing code

- `devtools::document()` to regenerate `man/` + `NAMESPACE` (never
  hand-edit those).
- Add new exported functions to `_pkgdown.yml` `reference:`.
- Update `NEWS.md` + `cran-comments.md` for user-visible changes.
- `devtools::build_readme()` if `README.Rmd` changed.
- Commit with Conventional Commits (`feat(toa):`, `fix(toa):`, …). No AI
  co-authors.
