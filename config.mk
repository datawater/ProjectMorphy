WERROR ?=true
TARGET ?=native 
USE_GRAPHITE ?=true
USE_FFUNCTION_SECTION ?=true
USE_FAST_MATH ?=true
USE_NO_MANGLE ?=true
PROFILE ?=debug

HAS_MOLD := $(shell which mold || (echo "none"))
HAS_EXCEPTIONS := $(shell grep -rnI "none")

CXXWARNS = -Wall -Wextra -pedantic -Wno-error=reorder
CXXFLAGS = -std=c++17 -I../common -I../ -I../src/server/src/include -I../src/client/src/include -L../common
LIBS = -pthread

RELEASE_CXXFLAGS = -mtune=$(TARGET) -march=$(TARGET) -flto -s -Wl,--gc-sections -DPROFILE_RELEASE
DEBUG_CXXFLAGS = -Og -ggdb -DPROFILE_DEBUG
SIZE_CXXFLAGS = -Os -Wl,--gc-sections -s -fno-unroll-loops -fmerge-all-constants -ffast-math -Wl,z,norelo -fvtable-g -DPROFILE_SIZE

ifeq ($(WERROR),true)
	CXXWARNS += -Werror
endif

ifeq ($(USE_GRAPHITE),true)
	RELEASE_CXXFLAGS += -fgraphite-identity -floop-nest-optimize -floop-paralellize-all -fdevirtualize-at-ltrans -fipa-pta
endif

ifeq ($(USE_FFUNCTION_SECTION),true)
	RELEASE_CXXFLAGS += -ffunction-sections -fdata-sections
endif

ifeq ($(USE_FAST_MATH),true)
	RELEASE_CXXFLAGS += -Ofast
else
	RELEASE_CXXFLAGS += -O3
endif

ifeq ($(USE_NO_MANGLE),true)
	CXXFLAGS += -DNO_MANGLE
endif

ifneq ($(HAS_MOLD),none)
	CXXFLAGS += -fuse-ld=mold
endif

ifeq ($(HAS_EXCEPTIONS),none)
	SIZE_CXXFLAGS += -fno-exceptions 
endif

CXXFLAGS += $(CXXWARNS)

ifeq ($(PROFILE),debug)
	CXXFLAGS += $(DEBUG_CXXFLAGS)
else ifeq ($(PROFILE),release)
	CXXFLAGS += $(RELEASE_CXXFLAGS)
else ifeq ($(PROFILE),size)
	CXXFLAGS += $(SIZE_CXXFLAGS)
else 
	$(error Unknown profile $(PROFILE))
endif