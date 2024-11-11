#pragma once

#include "h4_types.hpp"
#include "no_mangle.hpp"

#define H4_DEFINE_GETTER(type, name) \
    type get_##name() const { return name; }

#define H4_DEFINE_GETTER_CONST_PTR(type, name) \
    const type *get_##name() const { return static_cast<const type *>(&name); }

#define H4_DEFINE_SETTER(type, name) \
    void set_##name(const type &value) { name = value; }

#define H4_DEFINE_GETTER_SETTER(type, name) \
    H4_DEFINE_GETTER(type, name)            \
    H4_DEFINE_SETTER(type, name)
