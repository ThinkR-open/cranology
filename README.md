
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cranology

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of {cranology} is to provide tools to scrape data from CRAN and
MRAN website.

## Installation

You can install the development version of {cranology} like so:

``` r
remotes::install_github("ThinkR-open/cranology")
```

## Example

``` r
library(cranology)
```

``` r
dates <- seq(
  from = as.Date("2018-04-10", "%Y-%m-%d"), 
  by = "1 year", 
  length.out = 4
)
cran_get_package_number_mran(dates)
#> Scraping MRAN...
#>         date     n
#> 1 2018-04-10 12418
#> 2 2019-04-10 14042
#> 3 2020-04-10 15507
#> 4 2021-04-10 17398
```

## Code of Conduct

Please note that the cranology project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
