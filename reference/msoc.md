# Encryption/Decryption function

Encryption/Decryption function

## Usage

``` r
encrypt(input, output = NULL, pass, aes256 = FALSE)

decrypt(input, output = NULL, pass)
```

## Arguments

- input:

  input file

- output:

  (optional) output file. If none is provided, construct a temporary
  output file with the file extension of the input file

- pass:

  a password to decrypt/encrypt the input file. The password is expected
  to be plain text. If security is of importance, do not use this
  package. If the password is lost, opening the file will be impossible.

- aes256:

  use AES256 for encryption, the default is AES128.

## Value

a path to the output file. Either specified or temporary
