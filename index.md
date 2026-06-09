# 

# **oddsapiR**

To access the API, get a free API key from <https://the-odds-api.com>

Installation & Usage

## **Installation**

You can install the released version of
[**`oddsapiR`**](https://github.com/sportsdataverse/oddsapiR) from
[GitHub](https://github.com/sportsdataverse/oddsapiR) with:

``` r

# using the pak package (recommended):
if (!requireNamespace('pak', quietly = TRUE)){
  install.packages('pak')
}
pak::pak("sportsdataverse/oddsapiR")
```

``` r

# or using the devtools package:
if (!requireNamespace('devtools', quietly = TRUE)){
  install.packages('devtools')
}
devtools::install_github(repo = "sportsdataverse/oddsapiR")
```

``` r
# or clone and install locally
git clone https://github.com/sportsdataverse/oddsapiR
cd oddsapiR
Rscript -e "pak::local_install()"  # or: Rscript -e "devtools::install()"
```

#### **Odds API Keys**

The [Odds API](https://the-odds-api.com) requires an API key, here’s a
quick run-down:

- Using the key: You can save the key for consistent usage by adding
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

- For less consistent usage: At the beginning of every session or within
  an R environment, save your API key as the environment variable
  `ODDS_API_KEY` (with quotations) using a command like the following.

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
