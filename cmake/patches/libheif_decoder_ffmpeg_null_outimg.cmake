if(NOT DEFINED HEIF_DECODER_FFMPEG_FILE)
  message(FATAL_ERROR "HEIF_DECODER_FFMPEG_FILE is required")
endif()

set(_target_file "${HEIF_DECODER_FFMPEG_FILE}")

if(NOT EXISTS "${_target_file}")
  message(FATAL_ERROR "libheif decoder source not found: ${_target_file}")
endif()

file(READ "${_target_file}" _content)

set(_old_block [=[
  nclx = heif_nclx_color_profile_alloc();
  heif_nclx_color_profile_set_color_primaries(nclx, static_cast<uint16_t>(color_primaries));
  heif_nclx_color_profile_set_transfer_characteristics(nclx, static_cast<uint16_t>(transfer_characteristics));
  heif_nclx_color_profile_set_matrix_coefficients(nclx, static_cast<uint16_t>(matrix_coefficients));
  nclx->full_range_flag = (bool)video_full_range_flag;
  heif_image_set_nclx_color_profile(*out_img, nclx);
]=])

set(_new_block [=[
  if (out_img && *out_img)
  {
    nclx = heif_nclx_color_profile_alloc();
    heif_nclx_color_profile_set_color_primaries(nclx, static_cast<uint16_t>(color_primaries));
    heif_nclx_color_profile_set_transfer_characteristics(nclx, static_cast<uint16_t>(transfer_characteristics));
    heif_nclx_color_profile_set_matrix_coefficients(nclx, static_cast<uint16_t>(matrix_coefficients));
    nclx->full_range_flag = (bool)video_full_range_flag;
    heif_image_set_nclx_color_profile(*out_img, nclx);
  }
]=])

set(_nested_block [=[
  if (out_img && *out_img)
  {
    if (out_img && *out_img)
    {
      nclx = heif_nclx_color_profile_alloc();
      heif_nclx_color_profile_set_color_primaries(nclx, static_cast<uint16_t>(color_primaries));
      heif_nclx_color_profile_set_transfer_characteristics(nclx, static_cast<uint16_t>(transfer_characteristics));
      heif_nclx_color_profile_set_matrix_coefficients(nclx, static_cast<uint16_t>(matrix_coefficients));
      nclx->full_range_flag = (bool)video_full_range_flag;
      heif_image_set_nclx_color_profile(*out_img, nclx);
    }
  }
]=])

set(_old_noimage_guard [=[
  hevc_codecParam = avcodec_parameters_alloc();
]=])

set(_new_noimage_guard [=[
  if (!out_img || !*out_img) {
    err = { heif_error_Decoder_plugin_error, heif_suberror_Unspecified, "ffmpeg decoder produced no image" };
    goto errexit;
  }

  hevc_codecParam = avcodec_parameters_alloc();
]=])

string(FIND "${_content}" "${_nested_block}" _nested_pos)
if(NOT _nested_pos EQUAL -1)
  string(REPLACE "${_nested_block}" "${_new_block}" _content "${_content}")
endif()

string(FIND "${_content}" "${_old_block}" _old_pos)
if(NOT _old_pos EQUAL -1)
  string(REPLACE "${_old_block}" "${_new_block}" _content "${_content}")
endif()

string(FIND "${_content}" "ffmpeg decoder produced no image" _noimage_pos)
if(_noimage_pos EQUAL -1)
  string(REPLACE "${_old_noimage_guard}" "${_new_noimage_guard}" _content "${_content}")
endif()

string(FIND "${_content}" "if (out_img && *out_img)" _guard_pos)
if(_guard_pos EQUAL -1)
  message(FATAL_ERROR "Failed to apply libheif ffmpeg out_img guard in ${_target_file}")
endif()

string(FIND "${_content}" "ffmpeg decoder produced no image" _noimage_guard_pos)
if(_noimage_guard_pos EQUAL -1)
  message(FATAL_ERROR "Failed to apply libheif ffmpeg no-image guard in ${_target_file}")
endif()

file(WRITE "${_target_file}" "${_content}")
message(STATUS "Applied libheif ffmpeg out_img guard patch to ${_target_file}")