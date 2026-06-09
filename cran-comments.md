## Release summary

This is the 1.0.0 major release. It:
* Migrates the HTTP stack from `httr` to `httr2` (and removes `janitor`; adds `tibble`).
* Adds five new endpoint wrappers completing The Odds API v4 surface:
  `toa_sports_events()`, `toa_event_markets()`, `toa_sports_participants()`,
  `toa_sports_events_history()`, and `toa_event_odds_history()`.
* Adds `toa_quota()` and per-request usage-quota reporting (attributes + print method).
* Repoints `toa_sports_odds_history()` to the current `/v4/historical/...` endpoint
  (the previous `/odds-history` path was deprecated upstream); the signature changed.
* I am ignoring the note on non-ASCII characters in package data because they are proper names.

## R CMD check results

0 errors | 0 warnings | 0 notes

## revdepcheck results

We checked 0 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages
