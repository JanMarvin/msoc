#' @useDynLib msoc R_msoc
msoc <- function(mode, in_file, out_file, pass) {
  stopifnot(is.character(mode))
  stopifnot(is.character(in_file))
  stopifnot(is.character(out_file))
  stopifnot(is.character(pass))
  .Call(R_msoc, mode, in_file, out_file, pass)
}

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
#'
#' @importFrom tools file_ext
"_PACKAGE"

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

  if (!all(type %in% c("dec", "enc")))
    stop("Input must be enc/dec. Was: ", type)

  out <- msoc(type, in_file = input, out_file = output, pass = pass)
  stopifnot(out == 0)

  output
}

# Function to check for problematic characters in the password
check_password <- function(password) {
  # Define regex patterns with Unicode escape sequences
  accented_pattern    <- "[\u00C0-\u00FF]"
  japanese_pattern    <- "[\u3041-\u3093\u30A1-\u30F3\u4E00-\u9FAF]"
  punctuation_pattern <- "[[{}();:,.!?\'\"`~@#$%^&*]"

  # Check for the presence of problematic characters
  has_accented    <- grepl(accented_pattern, password)
  has_japanese    <- grepl(japanese_pattern, password)
  has_punctuation <- grepl(punctuation_pattern, password)

  # Return results
  if (any(has_accented, has_japanese, has_punctuation))
    stop("password contains accented or japanese characters or uses punctuation")

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

  check_password(pass)

  out <- .msoc("enc", input = input, output = output, pass = pass)

  out
}

#' @rdname msoc
#' @export
decrypt <- function(input, output = NULL, pass) {

  out <- .msoc("dec", input = input, output = output, pass = pass)

  out
}
