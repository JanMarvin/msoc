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

  xlsx <- system.file("extdata", "Untitled1.xlsx", package = "msoc")

  expect_warning(got1 <- encrypt(xlsx, pass = "鬼"), "Password contains non ASCII characters or uses punctuation")
  expect_warning(got2 <- encrypt(xlsx, pass = "brûlée"), "Password contains non ASCII characters or uses punctuation")
  expect_warning(got3 <- encrypt(xlsx, pass = "msoc!"), "Password contains non ASCII characters or uses punctuation")

  decrypt(got1, pass = "鬼")
  decrypt(got2, pass = "brûlée")
  decrypt(got3, pass = "msoc!")

})

test_that("errors work", {

  xlsx <- tempfile(fileext = ".xlsx")

  expect_error(encrypt(xlsx, pass = "foo"), "File does not exist")

})
