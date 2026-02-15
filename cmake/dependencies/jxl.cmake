#
# Copyright (C) 2022  Autodesk, Inc. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

#
# libjxl official source repository: https://github.com/libjxl/libjxl
#

INCLUDE(ProcessorCount) # require CMake 3.15+
PROCESSORCOUNT(_cpu_count)

RV_CREATE_STANDARD_DEPS_VARIABLES("RV_DEPS_JXL" "${RV_DEPS_JXL_VERSION}" "make" "")
RV_SHOW_STANDARD_DEPS_VARIABLES()

RV_MAKE_STANDARD_LIB_NAME("jxl" "" "SHARED" "")

LIST(APPEND _configure_options "-DBUILD_SHARED_LIBS=ON")
LIST(APPEND _configure_options "-DBUILD_TESTING=OFF")
LIST(APPEND _configure_options "-DJPEGXL_ENABLE_TOOLS=OFF")
LIST(APPEND _configure_options "-DJPEGXL_ENABLE_EXAMPLES=OFF")
LIST(APPEND _configure_options "-DJPEGXL_ENABLE_BENCHMARK=OFF")
LIST(APPEND _configure_options "-DJPEGXL_ENABLE_DOXYGEN=OFF")
LIST(APPEND _configure_options "-DJPEGXL_ENABLE_MANPAGES=OFF")
LIST(APPEND _configure_options "-DJPEGXL_ENABLE_JPEGLI=OFF")
LIST(APPEND _configure_options "-DJPEGXL_FORCE_SYSTEM_BROTLI=OFF")
LIST(APPEND _configure_options "-DJPEGXL_FORCE_SYSTEM_HWY=OFF")

EXTERNALPROJECT_ADD(
  ${_target}
  GIT_REPOSITORY https://github.com/libjxl/libjxl.git
  GIT_TAG v${_version}
  GIT_SHALLOW TRUE
  GIT_PROGRESS TRUE
  GIT_SUBMODULES
    third_party/brotli
    third_party/highway
    third_party/lcms
    third_party/libjpeg-turbo
    third_party/libpng
    third_party/sjpeg
    third_party/skcms
    third_party/zlib
  GIT_SUBMODULES_RECURSE FALSE
  SOURCE_DIR ${_source_dir}
  BINARY_DIR ${_build_dir}
  INSTALL_DIR ${_install_dir}
  DEPENDS ZLIB::ZLIB PNG::PNG jpeg-turbo::jpeg
  CONFIGURE_COMMAND ${CMAKE_COMMAND} ${_configure_options}
  BUILD_COMMAND ${_cmake_build_command}
  INSTALL_COMMAND ${_cmake_install_command}
  BUILD_IN_SOURCE FALSE
  BUILD_ALWAYS FALSE
  BUILD_BYPRODUCTS ${_byproducts}
  USES_TERMINAL_BUILD TRUE
)

RV_COPY_LIB_BIN_FOLDERS()

ADD_DEPENDENCIES(dependencies ${_target}-stage-target)

ADD_LIBRARY(Jxl::Jxl SHARED IMPORTED GLOBAL)
ADD_DEPENDENCIES(Jxl::Jxl ${_target})

SET_PROPERTY(
  TARGET Jxl::Jxl
  PROPERTY IMPORTED_LOCATION ${_libpath}
)

SET_PROPERTY(
  TARGET Jxl::Jxl
  PROPERTY IMPORTED_SONAME ${_libname}
)

IF(RV_TARGET_WINDOWS)
  SET_PROPERTY(
    TARGET Jxl::Jxl
    PROPERTY IMPORTED_IMPLIB ${_implibpath}
  )
ENDIF()

FILE(MAKE_DIRECTORY "${_include_dir}")
TARGET_INCLUDE_DIRECTORIES(
  Jxl::Jxl
  INTERFACE ${_include_dir}
)

LIST(APPEND RV_DEPS_LIST Jxl::Jxl)
