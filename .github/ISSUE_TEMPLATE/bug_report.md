---
name: Bug Report
about: Report something that isn't working correctly
title: "[BUG] "
labels: bug
assignees: ''
---

## Description

<!-- Clear, concise description of the bug -->

## Reproduction Steps

1. 
2. 
3. 

## Expected Behavior

<!-- What should happen -->

## Actual Behavior

<!-- What actually happens -- include the full error message or stack trace -->

```
# Paste error output here
```

## Minimal Reproducible Example

```r
# Paste a minimal, self-contained example that reproduces the bug
library(oddsapiR)

# NOTE: do NOT paste your real ODDS_API_KEY. Confirm it is set with has_toa_key().

```

## Environment

- **oddsapiR version:** <!-- e.g., 1.0.0 — run packageVersion("oddsapiR") -->
- **R version:** <!-- e.g., 4.4.1 — run R.version.string -->
- **OS:** <!-- e.g., macOS 14.5, Windows 11, Ubuntu 22.04 -->
- **Installed via:** <!-- CRAN / devtools::install_github("sportsdataverse/oddsapiR") -->
- **The Odds API plan:** <!-- free / paid tier (historical endpoints require a paid plan) -->

## Additional Context

<!-- Screenshots, related issues, workarounds, or links to relevant API docs.
     If quota-related, include the output of toa_quota(). -->
