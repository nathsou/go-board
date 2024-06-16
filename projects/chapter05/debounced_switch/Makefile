# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0

TOPLEVEL_LANG ?= verilog
SIM ?= icarus

VERILOG_SOURCES = $(shell pwd)/debounce_filter.v
MODULE = test_debounce_filter
TOPLEVEL = debounce_filter
WAVES = 1
COMPILE_ARGS += -P debounce_filter.DEBOUNCE_LIMIT=4

include $(shell cocotb-config --makefiles)/Makefile.sim
