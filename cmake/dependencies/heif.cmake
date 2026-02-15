#
# Copyright (C) 2022  Autodesk, Inc. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

#
# libheif official source repository: https://github.com/strukturag/libheif
#

INCLUDE(ProcessorCount) # require CMake 3.15+
PROCESSORCOUNT(_cpu_count)

RV_CREATE_STANDARD_DEPS_VARIABLES("RV_DEPS_HEIF" "${RV_DEPS_HEIF_VERSION}" "make" "")
RV_SHOW_STANDARD_DEPS_VARIABLES()

SET(_download_url
    "https://github.com/strukturag/libheif/archive/refs/tags/v${_version}.tar.gz"
)

# libheif shared library name is generally not version-suffixed on Windows, and may be suffixed on Unix.
RV_MAKE_STANDARD_LIB_NAME("heif" "" "SHARED" "")

GET_TARGET_PROPERTY(_dav1d_include_dir dav1d::dav1d INTERFACE_INCLUDE_DIRECTORIES)
GET_TARGET_PROPERTY(_dav1d_library dav1d::dav1d IMPORTED_LOCATION)

GET_TARGET_PROPERTY(_libde265_include_dir libde265::libde265 INTERFACE_INCLUDE_DIRECTORIES)
GET_TARGET_PROPERTY(_libde265_library libde265::libde265 IMPORTED_LOCATION)

LIST(APPEND _configure_options "-DBUILD_SHARED_LIBS=ON")
LIST(APPEND _configure_options "-DBUILD_TESTING=OFF")
LIST(APPEND _configure_options "-DWITH_EXAMPLES=OFF")
LIST(APPEND _configure_options "-DWITH_LIBDE265=ON")
LIST(APPEND _configure_options "-DWITH_X265=OFF")
LIST(APPEND _configure_options "-DWITH_AOM_DECODER=OFF")
LIST(APPEND _configure_options "-DWITH_AOM_ENCODER=OFF")
LIST(APPEND _configure_options "-DWITH_RAV1E=OFF")
LIST(APPEND _configure_options "-DWITH_DAV1D=ON")
LIST(APPEND _configure_options "-DWITH_FFMPEG_DECODER=OFF")
LIST(APPEND _configure_options "-DDAV1D_INCLUDE_DIR=${_dav1d_include_dir}")
LIST(APPEND _configure_options "-DDAV1D_LIBRARY=${_dav1d_library}")
LIST(APPEND _configure_options "-DLIBDE265_INCLUDE_DIR=${_libde265_include_dir}")
LIST(APPEND _configure_options "-DLIBDE265_LIBRARY=${_libde265_library}")

IF(DEFINED RV_DEPS_FFMPEG_ROOT_DIR)
  LIST(APPEND _configure_options "-DCMAKE_PREFIX_PATH=${RV_DEPS_FFMPEG_ROOT_DIR}")
  LIST(APPEND _configure_options "-DFFMPEG_ROOT=${RV_DEPS_FFMPEG_ROOT_DIR}")
  LIST(APPEND _configure_options "-DFFMPEG_avcodec_INCLUDE_DIR:PATH=${RV_DEPS_FFMPEG_ROOT_DIR}/include")
  LIST(APPEND _configure_options "-DFFMPEG_avcodec_LIBRARY:FILEPATH=${RV_DEPS_FFMPEG_ROOT_DIR}/bin/avcodec.lib")
  LIST(APPEND _configure_options "-DFFMPEG_avutil_INCLUDE_DIR:PATH=${RV_DEPS_FFMPEG_ROOT_DIR}/include")
  LIST(APPEND _configure_options "-DFFMPEG_avutil_LIBRARY:FILEPATH=${RV_DEPS_FFMPEG_ROOT_DIR}/bin/avutil.lib")
ENDIF()

EXTERNALPROJECT_ADD(
  ${_target}
  URL ${_download_url}
  DOWNLOAD_NAME ${_target}_${_version}.tar.gz
  DOWNLOAD_DIR ${RV_DEPS_DOWNLOAD_DIR}
  DOWNLOAD_EXTRACT_TIMESTAMP TRUE
  SOURCE_DIR ${_source_dir}
  BINARY_DIR ${_build_dir}
  INSTALL_DIR ${_install_dir}
  DEPENDS dav1d::dav1d ffmpeg::avcodec libde265::libde265
  PATCH_COMMAND ${CMAKE_COMMAND} -DHEIF_DECODER_FFMPEG_FILE=libheif/plugins/decoder_ffmpeg.cc -P "${PROJECT_SOURCE_DIR}/cmake/patches/libheif_decoder_ffmpeg_null_outimg.cmake"
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

ADD_LIBRARY(Heif::Heif SHARED IMPORTED GLOBAL)
ADD_DEPENDENCIES(Heif::Heif ${_target})

SET_PROPERTY(
  TARGET Heif::Heif
  PROPERTY IMPORTED_LOCATION ${_libpath}
)

SET_PROPERTY(
  TARGET Heif::Heif
  PROPERTY IMPORTED_SONAME ${_libname}
)

IF(RV_TARGET_WINDOWS)
  SET_PROPERTY(
    TARGET Heif::Heif
    PROPERTY IMPORTED_IMPLIB ${_implibpath}
  )
ENDIF()

FILE(MAKE_DIRECTORY "${_include_dir}")
TARGET_INCLUDE_DIRECTORIES(
  Heif::Heif
  INTERFACE ${_include_dir}
)

LIST(APPEND RV_DEPS_LIST Heif::Heif)
