#define R_NO_REMAP
#define STRICT_R_HEADERS
#include <R.h>
#include <Rinternals.h>
#include <R_ext/Error.h>

#include <string>
#include "msoc.h"

std::string to_string(SEXP sexp) {
  const char* cstr = CHAR(STRING_ELT(sexp, 0));
  return std::string(cstr);
}

extern "C" SEXP R_msoc(SEXP sexp_mode, SEXP sexp_inFile, SEXP sexp_outFile, SEXP sexp_pass)
{

  std::string mode    = to_string(sexp_mode);
  std::string inFile  = to_string(sexp_inFile);
  std::string outFile = to_string(sexp_outFile);
  std::string pass    = to_string(sexp_pass);

  int err = 0;

  if (mode.compare("enc") == 0) {
    err = MSOC_encryptA(outFile.c_str(), inFile.c_str(), pass.c_str(), NULL);
  } else if (mode.compare("dec") == 0) {
    err = MSOC_decryptA(outFile.c_str(), inFile.c_str(), pass.c_str(), NULL);
  }
  if (err != MSOC_NOERR) {
    Rf_error("%s\n", MSOC_getErrMessage(err));
    return Rf_ScalarInteger(-1);
  }
  return Rf_ScalarInteger(0);;
}
