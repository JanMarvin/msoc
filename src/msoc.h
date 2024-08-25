#include "decode.hpp"
#include "encode.hpp"

static const size_t maxExceptionSize = 1024;
static char g_exception[maxExceptionSize + 1] = "exception";

static void setException(const std::exception& e)
{
  /// QQQ : not multi-thread
  size_t len = strlen(e.what());
  if (len >= maxExceptionSize) len = maxExceptionSize;
  memcpy(g_exception, e.what(), len);
  g_exception[len] = '\0';
}

#define MSOC_NOERR 0
#define MSOC_ERR_NOT_SUPPORT (-1)
#define MSOC_ERR_ALREADY_ENCRYPTED (-2)
#define MSOC_ERR_ALREADY_DECRYPTED (-3)
#define MSOC_ERR_BAD_PASSWORD (-4)
#define MSOC_ERR_BAD_PARAMETER (-5)
#define MSOC_ERR_SMALL_MAX_SIZE (-6)
#define MSOC_ERR_NO_MEMORY (-7)
#define MSOC_ERR_EXCEPTION (-8)
#define MSOC_ERR_TOO_LARGE_FILE (-9)
#define MSOC_ERR_INFILE_IS_EMPTY (-10)
#define MSOC_ERR_OUTFILE_IS_EMPTY (-11)
#define MSOC_ERR_PASS_IS_EMPTY (-12)

static const char * MSOC_getErrMessage(int err)
{
  switch (err) {
  case MSOC_NOERR:
    return "noerr";
  case MSOC_ERR_NOT_SUPPORT:
    return "not supported format";
  case MSOC_ERR_ALREADY_ENCRYPTED:
    return "already encrypted";
  case MSOC_ERR_ALREADY_DECRYPTED:
    return "already decrypted";
  case MSOC_ERR_BAD_PASSWORD:
    return "bad password";
  case MSOC_ERR_NO_MEMORY:
    return "no memory";
  case MSOC_ERR_EXCEPTION:
    return g_exception;
  case MSOC_ERR_TOO_LARGE_FILE:
    return "too large file";
  case MSOC_ERR_INFILE_IS_EMPTY:
    return "inFile is empty";
  case MSOC_ERR_OUTFILE_IS_EMPTY:
    return "outFile is empty";
  case MSOC_ERR_PASS_IS_EMPTY:
    return "pass is empty";
  default:
    return "unknown err";
  }
}

// from msocdll.cpp
template<class T>
static int readFile(std::string& data, ms::Format& format, uint32_t& dataSize, const T *inFile)
{
  cybozu::Mmap m(inFile);
  if (m.size() > 0xffffffff) {
    return MSOC_ERR_TOO_LARGE_FILE;
  }
  dataSize = static_cast<uint32_t>(m.size());
  data.assign(m.get(), dataSize);
  format = ms::DetectFormat(data.data(), dataSize);
  return MSOC_NOERR;
}
