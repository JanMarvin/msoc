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
