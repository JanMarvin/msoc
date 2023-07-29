
<!-- README.md is generated from README.Rmd. Please edit that file -->

# msoc

<!-- badges: start -->

[![R-CMD-check](https://github.com/JanMarvin/msoc/workflows/R-CMD-check/badge.svg)](https://github.com/JanMarvin/msoc/actions)
[![r-universe](https://janmarvin.r-universe.dev/badges/msoc)](https://janmarvin.r-universe.dev/msoc)
<!-- badges: end -->

This R package provides the cryptographic library
[msoc](https://github.com/herumi/msoffice) and allows encrypting and
decrypting office open xml files with R.

## Installation

You can install the development version of `msoc` from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("JanMarvin/msoc")
```

Or from [r-universe](https://r-universe.dev/) with:

``` r
# Enable repository from janmarvin
options(repos = c(
  janmarvin = 'https://janmarvin.r-universe.dev',
  CRAN = 'https://cloud.r-project.org'))
# Download and install msoc in R
install.packages('msoc')
```

## Introduction

A word of warning. I have no background in cryptography and I am
somewhat unable to maintain the bundled msoc library. Assume that I only
made it work and if it ever breaks, you are on your own. Due to these
reasons the package will never be released to CRAN either.

``` r
library(msoc)
file <- system.file("extdata", "Untitled1.xlsx", package = "msoc")

# out is an encrypted file and you will 
# be unable to open it without the password
out <- encrypt(file, pass = "msoc")

# out is an decrypted file and readable
# without the password
out <- decrypt(out, pass = "msoc")
```

## License

This package is licensed under the BSD 3-Clause license and is based on
[`msoffice`](https://github.com/herumi/msoffice) (by Cybozu Labs, Inc;
COPYRIGHT 2007-2015 and Shigeo Mitsunari;COPYRIGHT 2015-2023) and
[`cybozulib`](https://github.com/herumi/cybozulib) (by Cybozu Labs, Inc;
COPYRIGHT 2007-2012 and Shigeo Mitsunari; COPYRIGHT 2012-2023). Both
release under the BSD 3-Clause License.
