#define R_NO_REMAP
#define STRICT_R_HEADERS
#include <R.h>
#include <Rinternals.h>
#include <R_ext/Error.h>

#ifdef error
#undef error
#endif

#include <string>
#include "msoc.h"


// convert string to utf8 string (make sure that we are still in utf8)
std::string to_string(SEXP sexp) {
  SEXP fst = STRING_ELT(sexp, 0);
  const char *cstr = Rf_translateCharUTF8(fst);
  return std::string(cstr);
}

// there was some kind of password conversion error, therefore use custom decode and encode functions
int msoc_dec(const char *data, const uint32_t dataSize, const std::string outFile, const std::string passData, std::string secretKey, bool doView)
  try
  {
    int spinCount;
    bool ok = ms::decode(data, dataSize, outFile, passData, secretKey, doView, &spinCount);
    if (!ok) return MSOC_ERR_BAD_PASSWORD;
    return MSOC_NOERR;
  } catch (std::exception& e) {
    setException(e);
    return MSOC_ERR_EXCEPTION;
  }

int msoc_enc(const char *data, const uint32_t dataSize, const std::string outFile, const std::string passData, bool isOffice2013, std::string secretKey, int spinCount)
  try
  {
    bool ok = ms::encode(data, dataSize, outFile, passData, isOffice2013, secretKey, spinCount);
    if (!ok) return MSOC_ERR_BAD_PASSWORD;
    return MSOC_NOERR;
  } catch (std::exception& e) {
    setException(e);
    return MSOC_ERR_EXCEPTION;
  }

extern "C" SEXP R_msoc(SEXP sexp_mode, SEXP sexp_inFile, SEXP sexp_outFile, SEXP sexp_pass)
{

  std::string mode    = to_string(sexp_mode);
  std::string inFile  = to_string(sexp_inFile);
  std::string outFile = to_string(sexp_outFile);
  std::string pass    = to_string(sexp_pass);

  std::string secretKeyHex;
  int spinCount = 100000; // 0?
  bool doEncode = false, doDecode = false, doView = false;
  int encMode = 0;

  cybozu::String16 wpass;

  std::string secretKey;
  if (!secretKeyHex.empty()) {
    secretKey = ms::fromHex(secretKeyHex, true);
  }

  if (!pass.empty()) {
    wpass = cybozu::ToUtf16(pass);
  }

  const std::string passData = ms::Char16toChar8(wpass);

  int err = 0;
  std::string data;
  ms::Format format;
  uint32_t dataSize;
  err = readFile(data, format, dataSize, inFile.c_str());
  if (mode.compare("dec") == 0 && err == MSOC_NOERR && format == ms::fZip) {
    err = MSOC_ERR_ALREADY_DECRYPTED;
  }
  if (mode.compare("enc") == 0 && err == MSOC_NOERR && format == ms::fCfb) {
    err = MSOC_ERR_ALREADY_ENCRYPTED;
  }
  if (err != MSOC_NOERR) {
    Rf_error("%s\n", MSOC_getErrMessage(err));
  }

  // if (debug) {
  //   Rprintf("inFile = %s , outFile = %s\n", inFile.c_str(), outFile.c_str());
  //   Rprintf("decoding about to start!\n");
  //   Rprintf("dataSize: %d\n", dataSize);
  //   Rprintf("passData = %s - %s\n", pass.c_str(), passData.c_str());
  // }

  if (mode.compare("enc") == 0) {

    bool isOffice2013 = encMode == 1;
    err = msoc_enc(data.data(), dataSize, outFile, passData, isOffice2013, secretKey, spinCount);

  } else if (mode.compare("dec") == 0) {

    err = msoc_dec(data.data(), dataSize, outFile, passData, secretKey, doView);
  }
  if (err != MSOC_NOERR) {
    Rf_error("%s\n", MSOC_getErrMessage(err));
    return Rf_ScalarInteger(-1); // will not be returned, due to error
  }
  return Rf_ScalarInteger(0);;
}
