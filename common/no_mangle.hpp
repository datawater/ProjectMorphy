#pragma once

#ifdef NO_MANGLE
#ifndef _H4_CXA_DEMANGLE_DEFINED
#define _H4_CXA_DEMANGLE_DEFINED

#include <cstddef>

extern "C" char *__cxa_demangle(const char *mangled_name, char *buf, size_t *n,
                                int *status);
#endif  // _H4_CXA_DEMANGLE_DEFINED
#endif  // NO_MANGLE