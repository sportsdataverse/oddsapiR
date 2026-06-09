# **Odds API Key Registration**

Save your API Key as a system environment variable `ODDS_API_KEY`

## Usage

``` r
toa_key()

has_toa_key()

check_toa_key()
```

## Value

Called as a side-effect to ensure that a user has an API key stored in
their environment before making a call to the Odds API service.

## Details

To get access to an API key, follow the instructions at
<https://the-odds-api.com>  
  
**Using the key:**  
You can save the key for consistent usage by adding
`ODDS_API_KEY=XXXX-YOUR-API-KEY-HERE-XXXXX` to your .Renviron file
(easily accessed via
[**[`usethis::edit_r_environ()`](https://usethis.r-lib.org/reference/edit.html)**](https://usethis.r-lib.org/reference/edit.html)).  
Run
[**[`usethis::edit_r_environ()`](https://usethis.r-lib.org/reference/edit.html)**](https://usethis.r-lib.org/reference/edit.html),
a new script will pop open named `.Renviron`, **THEN**  
paste the following in the new script that pops up (with**out**
quotations)

    ODDS_API_KEY = XXXX-YOUR-API-KEY-HERE-XXXXX

Save the script and restart your RStudio session, by clicking `Session`
(in between `Plots` and `Build`) and click `Restart R`  
(there also exists the shortcut `Ctrl + Shift + F10` to restart your
session).

If set correctly, from then on you should be able to use any of the
`toa_` functions without any other changes.

**For less consistent usage:**  
At the beginning of every session or within an R environment, save your
API key as the environment variable `ODDS_API_KEY` (**with** quotations)
using a command like the following.

    Sys.setenv(ODDS_API_KEY = "XXXX-YOUR-API-KEY-HERE-XXXXX")
