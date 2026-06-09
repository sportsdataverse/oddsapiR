# NA

## Summary

## Type of Change

Bug fix (non-breaking change that fixes an issue)

New feature (non-breaking change that adds functionality)

Breaking change (fix or feature that would cause existing functionality
to change)

Documentation update

Deprecation (marking functions for future removal)

CI/build (workflow, package config, or infrastructure changes)

## Changes Made

| File | Change | Why |
|------|--------|-----|
|      |        |     |

## Rationale & Decision Log

## Testing & Validation

`devtools::check()` passes with no ERRORs or WARNINGs

`devtools::test()` – all existing tests pass

New tests added for new/changed functions

Verified against the live API with a valid `ODDS_API_KEY` (no key
committed)

Tested on at least one platform (macOS / Windows / Linux)

### Validation Evidence

## Documentation

roxygen2 docs updated (`devtools::document()`)

`@return` tables use the 3-column `col_name | types | description`
format

`NEWS.md` updated with user-facing changes

pkgdown site builds
([`pkgdown::build_site()`](https://pkgdown.r-lib.org/reference/build_site.html))

## Checklist

Branch follows naming convention: `<type>/<short-description>`

Commit messages follow [Conventional
Commits](https://www.conventionalcommits.org/)
(`<type>(<scope>): <description>`)

No debug code, print statements, or hard-coded API keys

NAMESPACE regenerated if imports/exports changed

DESCRIPTION version bumped (if releasing)

> **Reminder:** Run `devtools::check()` and `devtools::test()` before
> requesting review. Use Conventional Commits: `feat(toa):`,
> `fix(toa):`, `docs(pkgdown):`, `test(toa):`, etc. Never commit a real
> `ODDS_API_KEY`.

## Rollback Plan
