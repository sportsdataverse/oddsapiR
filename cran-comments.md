## Release summary

This is a fix release for the `--run-donttest` additional-issues failure reported
for 1.0.0 on 2026-08-25 (correction requested by 2026-09-16).

**Cause.** The Odds API omits its `x-requests-*` usage headers on error responses.
On the CRAN check machines no API key is configured, so the example request
returned HTTP 401, `httr2::resp_header()` returned `NULL`, and
`as.integer(NULL)` stored a zero-length usage value. The print method's guard,
`!is.null(x) && !is.na(x)`, then evaluated to `NA` on that zero-length value and
aborted with "missing value where TRUE/FALSE needed".

**Fixes.**
* Absent or unparseable `x-requests-*` headers are recorded as `NA_integer_`, and
  the print-method guard is now length-safe.
* `toa_event_odds()` / `toa_event_odds_history()` surface the API's own error
  message rather than reporting a failed request as an event with no odds posted.
* Examples that call the live API are guarded with `@examplesIf has_toa_key()`,
  so on a machine with no API key they are skipped rather than issuing a request
  that cannot succeed. This is what makes the `--run-donttest` run clean.
* I am ignoring the note on non-ASCII characters in package data because they are proper names.

## R CMD check results

0 errors | 0 warnings | 0 notes

Verified under the reported conditions: `R CMD check --run-donttest` with no
`ODDS_API_KEY` in the environment (`R_ENVIRON_USER` pointed at an empty file)
returns `Status: OK`.

One local-only artifact: `R CMD check --as-cran` on a Windows dev machine reports a
non-standard `''NULL''` directory in the check directory. Phase bisection shows it is
created by the CRAN-incoming *remote* checks themselves (it disappears with
`_R_CHECK_CRAN_INCOMING_REMOTE_=false` and does not occur in any other phase), i.e. an
artifact of the checking environment, not of the package.

## revdepcheck results

We checked 0 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages
