#include "no_mangle.hpp"

extern "C" char *__cxa_demangle(const char *mangled_name, char *buf, size_t *n,
                                int *status) {
    (void)mangled_name;
    (void)buf;
    (void)n;

    if (status) *status = -1;

    return (char *)nullptr;
}