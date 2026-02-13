#
# Copyright (C) 2022  Autodesk, Inc. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

#
# libjxl scaffolding module for Phase 2.
# This module intentionally exposes a dependency target without building libjxl yet.
#

INCLUDE(ProcessorCount) # require CMake 3.15+
PROCESSORCOUNT(_cpu_count)

RV_CREATE_STANDARD_DEPS_VARIABLES("RV_DEPS_JXL" "${RV_DEPS_JXL_VERSION}" "make" "")
RV_SHOW_STANDARD_DEPS_VARIABLES()

ADD_CUSTOM_TARGET(${_target})
ADD_CUSTOM_TARGET(${_target}-stage-target)
ADD_DEPENDENCIES(dependencies ${_target}-stage-target)

ADD_LIBRARY(Jxl::Jxl INTERFACE IMPORTED GLOBAL)
ADD_DEPENDENCIES(Jxl::Jxl ${_target})

# It is required to force directory creation at configure time otherwise CMake complains about importing a non-existing path
FILE(MAKE_DIRECTORY "${_include_dir}")
TARGET_INCLUDE_DIRECTORIES(
  Jxl::Jxl
  INTERFACE ${_include_dir}
)

LIST(APPEND RV_DEPS_LIST Jxl::Jxl)
