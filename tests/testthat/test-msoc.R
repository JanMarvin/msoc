test_that("encrypt/decrypt", {

  files <- c(
    system.file("extdata", "Untitled1.docx", package = "msoc"),
    system.file("extdata", "Untitled1.xlsx", package = "msoc"),
    system.file("extdata", "Untitled1.pptx", package = "msoc")
  )

  for (file in files) {

    expect_silent(out <- encrypt(file, pass = "msoc"))

    expect_error(out <- decrypt(out, pass = "test"), "bad password")
    expect_silent(out <- decrypt(out, pass = "msoc"))

  }

})

test_that("decrypt/encrypt", {

  files <- c(
    system.file("extdata", "Encrypted.docx", package = "msoc"),
    system.file("extdata", "Encrypted.xlsx", package = "msoc"),
    system.file("extdata", "Encrypted.pptx", package = "msoc")
  )

  for (file in files) {

    expect_error(out <- decrypt(file, pass = "test"), "bad password")
    expect_silent(out <- decrypt(file, pass = "msoc"))

  }

})

test_that("password should be ascii", {

  skip_if_not_installed("stringi")

  xlsx <- system.file("extdata", "Untitled1.xlsx", package = "msoc")

  ghost  <- stringi::stri_unescape_unicode("\\u9b3c")
  brulee <- stringi::stri_unescape_unicode("br\\u00fbl\\u00e9e")

  expect_warning(got1 <- encrypt(xlsx, pass = ghost), "Password contains non ASCII characters or uses punctuation")
  expect_warning(got2 <- encrypt(xlsx, pass = brulee), "Password contains non ASCII characters or uses punctuation")
  expect_warning(got3 <- encrypt(xlsx, pass = "msoc!"), "Password contains non ASCII characters or uses punctuation")

  decrypt(got1, pass = ghost)
  decrypt(got2, pass = brulee)
  decrypt(got3, pass = "msoc!")

})

test_that("errors work", {

  xlsx <- tempfile(fileext = ".xlsx")

  expect_error(encrypt(xlsx, pass = "foo"), "File does not exist")

  docx <- system.file("extdata", "Untitled1.docx", package = "msoc")

  expect_silent(out <- encrypt(docx, pass = "msoc"))
  expect_error(out <- encrypt(out, pass = "msoc"), "already encrypted")
  expect_error(out <- decrypt(docx, pass = "msoc"), "already decrypted")

})

test_that("encrypt/decrypt with aes256", {

  files <- c(
    system.file("extdata", "Untitled1.docx", package = "msoc"),
    system.file("extdata", "Untitled1.xlsx", package = "msoc"),
    system.file("extdata", "Untitled1.pptx", package = "msoc")
  )

  for (file in files) {

    expect_silent(out <- encrypt(file, pass = "msoc", aes256 = TRUE))

    expect_error(out <- decrypt(out, pass = "test"), "bad password")
    expect_silent(out <- decrypt(out, pass = "msoc"))

  }

})

test_that("hasher works", {

  skip_if_not_installed("openssl")

  verifyPasswordSHA512 <- function(attempted_password, stored_hash, stored_salt, stored_spin) {

    salt_raw <- openssl::base64_decode(stored_salt)

    password_utf16le_raw <- iconv(enc2utf8(attempted_password), to = "UTF-16LE", toRaw = TRUE)[[1]]

    hashed_attempt <- as.raw(openssl::sha512(c(salt_raw, password_utf16le_raw)))

    for (i in 0:(stored_spin - 1)) {
      index_bytes <- writeBin(as.integer(i), raw(), size = 4, endian = "little")
      hashed_attempt <- as.raw(openssl::sha512(c(hashed_attempt, index_bytes)))
    }

    final_attempt_hash <- openssl::base64_encode(hashed_attempt)

    identical(final_attempt_hash, stored_hash)
  }

  hp <- msoc_hash("openxlsx2")

  expect_true(verifyPasswordSHA512("openxlsx2", stored_hash = hp$hash, stored_salt = hp$salt, stored_spin = hp$spin))
  expect_false(verifyPasswordSHA512("openxlsx", stored_hash = hp$hash, stored_salt = hp$salt, stored_spin = hp$spin))

})
