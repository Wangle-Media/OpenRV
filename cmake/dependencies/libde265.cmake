#
# Copyright (C) 2022  Autodesk, Inc. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

#
# libde265 official source repository: https://github.com/strukturag/libde265
#

INCLUDE(ProcessorCount) # require CMake 3.15+
PROCESSORCOUNT(_cpu_count)

RV_CREATE_STANDARD_DEPS_VARIABLES("RV_DEPS_LIBDE265" "${RV_DEPS_LIBDE265_VERSION}" "make" "")
RV_SHOW_STANDARD_DEPS_VARIABLES()

SET(_download_url
    "https://github.com/strukturag/libde265/releases/download/v${_version}/libde265-${_version}.tar.gz"
)

# libde265 shared library name
RV_MAKE_STANDARD_LIB_NAME("de265" "0" "SHARED" "")

LIST(APPEND _configure_options "-DCMAKE_BUILD_TYPE=Release")
LIST(APPEND _configure_options "-DBUILD_SHARED_LIBS=ON")
LIST(APPEND _configure_options "-DENABLE_SDL=OFF")
LIST(APPEND _configure_options "-DENABLE_DECODER=ON")
LIST(APPEND _configure_options "-DENABLE_ENCODER=OFF")

EXTERNALPROJECT_ADD(
  ${_target}
  URL ${_download_url}
  DOWNLOAD_NAME ${_target}_${_version}.tar.gz
  DOWNLOAD_DIR ${RV_DEPS_DOWNLOAD_DIR}
  DOWNLOAD_EXTRACT_TIMESTAMP TRUE
  SOURCE_DIR ${_source_dir}
  BINARY_DIR ${_build_dir}
  INSTALL_DIR ${_install_dir}
  CONFIGURE_COMMAND ${CMAKE_COMMAND} ${_configure_options} -DCMAKE_INSTALL_PREFIX=${_install_dir} ${_source_dir}
  BUILD_COMMAND ${_cmake_build_command}
  INSTALL_COMMAND ${_cmake_install_command}
  BUILD_IN_SOURCE FALSE
  BUILD_ALWAYS FALSE
  BUILD_BYPRODUCTS ${_byproducts}
  USES_TERMINAL_BUILD TRUE
)

RV_COPY_LIB_BIN_FOLDERS()

ADD_DEPENDENCIES(dependencies ${_target}-stage-target)

ADD_LIBRARY(libde265::libde265 SHARED IMPORTED GLOBAL)
ADD_DEPENDENCIES(libde265::libde265 ${_target})

SET_PROPERTY(
  TARGET libde265::libde265
  PROPERTY IMPORTED_LOCATION ${_libpath}
)

SET_PROPERTY(
  TARGET libde265::libde265
  PROPERTY IMPORTED_SONAME ${_libname}
)

IF(RV_TARGET_WINDOWS)
  SET_PROPERTY(
    TARGET libde265::libde265
    PROPERTY IMPORTED_IMPLIB ${_implibpath}
  )
ENDIF()

FILE(MAKE_DIRECTORY "${_include_dir}")
TARGET_INCLUDE_DIRECTORIES(
  libde265::libde265
  INTERFACE ${_include_dir}
)

LIST(APPEND RV_DEPS_LIST libde265::libde265)
