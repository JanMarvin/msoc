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
