#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

SEXP R_msoc(SEXP sexp_mode, SEXP sexp_inFile, SEXP sexp_outFile, SEXP sexp_pass);

static const R_CallMethodDef CallEntries[] = {
  {"R_msoc", (DL_FUNC) &R_msoc, 4},
  {NULL, NULL, 0}
};

void R_init_msoc(DllInfo *dll) {
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
