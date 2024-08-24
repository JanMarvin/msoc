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

  xlsx <- tempfile(fileext = ".xlsx")

  expect_error(encrypt(xlsx, xlsx, pass = "鬼"), "password contains accented or japanese characters or uses punctuation")
  expect_error(encrypt(xlsx, xlsx, pass = "brûlée"), "password contains accented or japanese characters or uses punctuation")
  expect_error(encrypt(xlsx, xlsx, pass = "msoc!"), "password contains accented or japanese characters or uses punctuation")

})
