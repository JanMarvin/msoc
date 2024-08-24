
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

Before you encrypt a file, you should memorize the password. If you
forget the password, there is no way to recover the contents of the
file. Password encoding was not extensively tested. Before encrypting
with non ASCII characters, it is recommended to check that files encoded
this way, can be opened in spreadsheet software.

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

## An example with [`openxlsx2`](https://github.com/JanMarvin/openxlsx2)

``` r
library(openxlsx2)
library(msoc)

xlsx <- temp_xlsx()

# let us write some worksheet
wb_workbook()$add_worksheet()$add_data(x = mtcars)$save(xlsx)

# now we can encrypt it
encrypt(xlsx, xlsx, pass = "msoc")
#> [1] "/var/folders/p7/t9znbbgj2_ndlz6vbxmgh7zm0000gn/T//RtmpfkrWpI/temp_xlsx_181864316774a.xlsx"

# the file is encrypted, we can not read it
try(wb <- wb_load(xlsx))
#> Error : Unable to open and load file:  /var/folders/p7/t9znbbgj2_ndlz6vbxmgh7zm0000gn/T//RtmpfkrWpI/temp_xlsx_181864316774a.xlsx

# we have to decrypt it first
decrypt(xlsx, xlsx, pass = "msoc")
#> [1] "/var/folders/p7/t9znbbgj2_ndlz6vbxmgh7zm0000gn/T//RtmpfkrWpI/temp_xlsx_181864316774a.xlsx"

# now we can load it again
wb_load(xlsx)$to_df() %>% head()
#>    mpg cyl disp  hp drat    wt  qsec vs am gear carb
#> 2 21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
#> 3 21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
#> 4 22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
#> 5 21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
#> 6 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
#> 7 18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
```

## License

This package is licensed under the BSD 3-Clause license and is based on
[`msoffice`](https://github.com/herumi/msoffice) (by Cybozu Labs, Inc;
COPYRIGHT 2007-2015 and Shigeo Mitsunari;COPYRIGHT 2015-2023) and
[`cybozulib`](https://github.com/herumi/cybozulib) (by Cybozu Labs, Inc;
COPYRIGHT 2007-2012 and Shigeo Mitsunari; COPYRIGHT 2012-2023). Both
release under the BSD 3-Clause License.
