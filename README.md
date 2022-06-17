
# 

# **oddsapiR** <a href='https://oddsapiR.sportsdataverse.org/'><img src='https://raw.githubusercontent.com/saiemgilani/oddsapiR/main/logo.png' align="right" width="20%" min-width="100px"/></a>

<!-- badges: start -->

[![Version-Number](https://img.shields.io/github/r-package/v/saiemgilani/oddsapiR?label=oddsapiR&logo=R&style=for-the-badge)](https://github.com/sportsdataverse/oddsapiR)
[![R-CMD-check](https://img.shields.io/github/workflow/status/saiemgilani/oddsapiR/R-CMD-check?label=R-CMD-Check&logo=R&logoColor=white&style=for-the-badge)](https://github.com/sportsdataverse/oddsapiR/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg?style=for-the-badge&logo=github)](https://github.com/sportsdataverse/oddsapiR)
[![Contributors](https://img.shields.io/github/contributors/saiemgilani/oddsapiR?style=for-the-badge)](https://github.com/sportsdataverse/oddsapiR/graphs/contributors)
[![Twitter
Follow](https://img.shields.io/twitter/follow/SportsDataverse?color=blue&label=%40SportsDataverse&logo=twitter&style=for-the-badge)](https://twitter.com/SportsDataverse)

<!-- badges: end -->

To access the API, get a free API key from <https://the-odds-api.com>

Installation & Usage

## **Installation**

You can install the CRAN version of
[**`oddsapiR`**](https://CRAN.R-project.org/package=oddsapiR) with:

``` r
install.packages("oddsapiR")
```

You can install the released version of
[**`oddsapiR`**](https://github.com/sportsdataverse/oddsapiR) from
[GitHub](https://github.com/sportsdataverse/oddsapiR) with:

``` r
# You can install using the pacman package using the following code:
if (!requireNamespace('pacman', quietly = TRUE)){
  install.packages('pacman')
}
pacman::p_load_current_gh("sportsdataverse/oddsapiR")
```

``` r
# if you would prefer devtools installation
if (!requireNamespace('devtools', quietly = TRUE)){
  install.packages('devtools')
}
# Alternatively, using the devtools package:
devtools::install_github(repo = "sportsdataverse/oddsapiR")
```

``` r
git clone https://github.com/sportsdataverse/oddsapi
cd oddsapi
Rscript -e "devtools::install()"
```

#### **Odds API Keys**

The [Odds API](https://the-odds-api.com) requires an API key, here’s a
quick run-down:

-   Using the key: You can save the key for consistent usage by adding
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

-   For less consistent usage: At the beginning of every session or
    within an R environment, save your API key as the environment
    variable `ODDS_API_KEY` (with quotations) using a command like the
    following.

``` r
Sys.setenv(ODDS_API_KEY = "XXXX-YOUR-API-KEY-HERE-XXXXX")
```

## **Documentation**

For more information on the package and function reference, please see
the [**`oddsapiR`** documentation
website](https://oddsapiR.sportsdataverse.org).

## **Breaking Changes**

[**Full News on
Releases**](https://oddsapiR.sportsdataverse.org/news/index.html)

## Follow the [SportsDataverse](https://twitter.com/SportsDataverse) on Twitter and star this repo

[![Twitter
Follow](https://img.shields.io/twitter/follow/SportsDataverse?color=blue&label=%40SportsDataverse&logo=twitter&style=for-the-badge)](https://twitter.com/SportsDataverse)

[![GitHub
stars](https://img.shields.io/github/stars/sportsdataverse/oddsapiR.svg?color=eee&logo=github&style=for-the-badge&label=Star%20oddsapiR&maxAge=2592000)](https://github.com/sportsdataverse/oddsapiR/stargazers/)

## **Our Authors**

-   [Saiem Gilani](https://twitter.com/saiemgilani)  
    <a href="https://twitter.com/saiemgilani" target="blank"><img src="https://img.shields.io/twitter/follow/saiemgilani?color=blue&label=%40saiemgilani&logo=twitter&style=for-the-badge" alt="@saiemgilani" /></a>
    <a href="https://github.com/saiemgilani" target="blank"><img src="https://img.shields.io/github/followers/saiemgilani?color=eee&logo=Github&style=for-the-badge" alt="@saiemgilani" /></a>

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
