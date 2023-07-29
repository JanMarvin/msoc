#' msoc
#'
#' @description
#' Package to make the `msoc` library (`https://github.com/herumi/msoffice`)
#' for encrypting/decrypting of Office Open XML files available under R.
#'
#' @details
#' The password is expected to be plain text. If security is of importance,
#' do not use this package. If the password is lost, opening the file will
#' be impossible.
#'
#' @name msoc-package
#' @docType package
#' @useDynLib msoc, .registration=TRUE
#'
#' @import Rcpp
#' @importFrom tools file_ext
NULL

#' msoc driver function
#' @param type type
#' @param input input
#' @param output output
#' @param pass pass
#' @keywords internal
#' @noRd
.msoc <- function(type = c("dec", "enc"), input, output, pass) {

  if (is.null(output)) {
    ext <- tools::file_ext(input)
    output <- tempfile(fileext = paste0(".", ext))
  }

  out <- msoc(type, inFile = input, outFile = output, pass = pass)
  stopifnot(out == 0)

  output
}

#' Encryption/Decryption function
#' @name msoc
#' @param input input file
#' @param output (optional) output file. If none is provided, construct a
#' temporary output file with the file extension of the input file
#' @param pass a password to decrypt/encrypt the input file. The password is
#' expected to be plain text. If security is of importance, do not use this
#' package. If the password is lost, opening the file will be impossible.
#' @returns a path to the output file. Either specified or temporary
NULL

#' @rdname msoc
#' @export
encrypt <- function(input, output = NULL, pass) {

  out <- .msoc("enc", input = input, output = output, pass = pass)

  out
}

#' @rdname msoc
#' @export
decrypt <- function(input, output = NULL, pass) {

  out <- .msoc("dec", input = input, output = output, pass = pass)

  out
}
