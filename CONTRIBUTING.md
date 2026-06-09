# Contributing to oddsapiR

Thanks for your interest in improving `oddsapiR`, the SportsDataverse R client for
[The Odds API](https://the-odds-api.com)! This guide covers how to set up a development
environment, the conventions the package follows, and how to get a change merged.

By participating you agree to abide by the [Code of Conduct](CODE_OF_CONDUCT.md).

## Table of Contents

- [Ways to contribute](#ways-to-contribute)
- [Getting set up](#getting-set-up)
- [The Odds API key](#the-odds-api-key)
- [Development workflow](#development-workflow)
- [Coding conventions](#coding-conventions)
- [Testing](#testing)
- [Documentation](#documentation)
- [Commit & PR conventions](#commit--pr-conventions)

## Ways to contribute

- **Report a bug** -- open an issue using the Bug Report template.
- **Request a feature / new endpoint** -- open an issue using the Feature Request template.
- **Improve docs** -- typo fixes, clearer examples, and better `@return` tables are always
  welcome.
- **Add or fix a wrapper** -- see the conventions below.

## Getting set up

1. Fork and clone the repository.
2. Install the development dependencies (pak recommended; devtools also works):

   ```r
   # recommended:
   install.packages("pak")
   pak::local_install_dev_deps()

   # or with devtools:
   install.packages("devtools")
   devtools::install_dev_deps()
   ```

3. Load the package for interactive development:

   ```r
   devtools::load_all()
   ```

## The Odds API key

Most functions hit the live API, so you need a (free) key from
<https://the-odds-api.com>. Store it as the `ODDS_API_KEY` environment variable:

```r
usethis::edit_r_environ()
# add the line:  ODDS_API_KEY=your-key-here
# then restart R
```

Confirm it is picked up with `has_toa_key()`. **Never commit your key.** Historical
(`/v4/historical/...`) endpoints require a paid plan; tests for those skip cleanly when the
plan tier returns no data.

Be mindful of your usage quota -- `toa_quota()` reports the credits used/remaining for the
most recent call, and the same numbers print with every returned tibble.

## Development workflow

```r
devtools::load_all()      # load the package
devtools::document()      # regenerate man/ + NAMESPACE after changing roxygen
devtools::test()          # run the test suite (needs ODDS_API_KEY)
devtools::build_readme()  # re-render README.md from README.Rmd
devtools::check()         # full R CMD check before opening a PR
```

## Coding conventions

`oddsapiR` follows the conventions documented in [CLAUDE.md](CLAUDE.md). The essentials:

- **Naming.** Public functions are prefixed `toa_` and mirror the endpoint shape.
- **HTTP layer.** Never call `httr2` directly. Build a base URL + a named `query_params`
  list and call `toa_api_call(base_url, query = query_params)`. `NULL` query values are
  dropped automatically, so thread optional parameters through unconditionally.
- **Initialize the return variable** (e.g. `odds <- data.frame()`) **before** the
  `tryCatch` so an API error returns an empty tibble instead of erroring on an unbound name.
- **Parse to a tidy tibble** with `tidyr::unnest()` over `bookmakers -> markets -> outcomes`,
  renaming the ambiguous `key`/`last_update` fields at each level, then finish with
  `make_toa_data(<description>, Sys.time())`.
- **Self-describing returns.** Echo identity columns the API omits (e.g. `sport_key` on
  participants; snapshot timestamps on historical wrappers).
- **`@return` tables are 3-column**: `col_name | types | description`. Include a
  **Usage quota cost** note in the `@description`.
- **Messaging** uses `cli::cli_alert_*`, not bare `message()`.

## Testing

- Add a `tests/testthat/test-<function>.R` file for every new function.
- Gate live tests: `skip_on_cran()` and `skip_if_not(has_toa_key(), "ODDS_API_KEY not set")`.
- Guard against empty/transient responses before asserting columns:
  `if (!is.data.frame(x) || nrow(x) == 0) skip("No rows returned at test time")`.
- **Use subset-direction assertions** so upstream column additions never break the suite:

  ```r
  expect_in(sort(cols), sort(colnames(x)))   # expected ⊆ actual
  expect_s3_class(x, "data.frame")
  ```

## Documentation

- Never hand-edit `NAMESPACE` or anything under `man/` -- regenerate with
  `devtools::document()`.
- Re-render the README with `devtools::build_readme()` and commit `README.Rmd` +
  `README.md` together.
- Add new exported functions to the `reference:` section of `_pkgdown.yml`.
- For user-visible changes, update `NEWS.md` and `cran-comments.md`.

## Commit & PR conventions

- Use [Conventional Commits](https://www.conventionalcommits.org/):
  `feat(toa):`, `fix(toa):`, `docs:`, `test(toa):`, `refactor:`, `chore:`, `ci:`. Mark
  breaking changes with `type!:` or a `BREAKING CHANGE:` footer.
- Keep unrelated changes in separate commits.
- **Do not add AI tools (Claude, Copilot, etc.) as commit co-authors.**
- Open your PR against `main`, fill out the PR template, and confirm `devtools::check()` and
  `devtools::test()` pass.

Thanks again for contributing!
