if(NOT DEFINED OIIO_HEIFINPUT_FILE)
  message(FATAL_ERROR "OIIO_HEIFINPUT_FILE is required")
endif()

if(NOT EXISTS "${OIIO_HEIFINPUT_FILE}")
  message(FATAL_ERROR "OIIO heifinput source not found: ${OIIO_HEIFINPUT_FILE}")
endif()

file(READ "${OIIO_HEIFINPUT_FILE}" _content)

set(_old_block [=[
#if LIBHEIF_NUMERIC_VERSION >= MAKE_LIBHEIF_VERSION(1, 16, 0, 0)
    // Try to discover the orientation. The Exif is unreliable. We have to go
    // through the transformation properties ourselves. A tricky bit is that
    // the C++ API doesn't give us a direct way to get the context ptr, we
    // need to resort to some casting trickery, with knowledge that the C++
    // heif::Context class consists solely of a std::shared_ptr to a
    // heif_context.
    // NO int orientation = m_spec.get_int_attribute("Orientation", 1);
    int orientation = 1;
    const heif_context* raw_ctx
        = reinterpret_cast<std::shared_ptr<heif_context>*>(m_ctx.get())->get();
    int xpcount = heif_item_get_transformation_properties(raw_ctx, id, nullptr,
                                                          100);
    xpcount     = std::min(xpcount, 100);  // clamp to some reasonable limit
    std::vector<heif_property_id> xprops(xpcount);
    heif_item_get_transformation_properties(raw_ctx, id, xprops.data(),
                                            xpcount);
    for (int i = 0; i < xpcount; ++i) {
        auto type = heif_item_get_property_type(raw_ctx, id, xprops[i]);
        if (type == heif_item_property_type_transform_rotation) {
            int rot = heif_item_get_property_transform_rotation_ccw(raw_ctx, id,
                                                                    xprops[i]);
            // cw[] maps to one additional clockwise 90 degree turn
            static const int cw[] = { 0, 6, 7, 8, 5, 2, 3, 4, 1 };
            for (int i = 0; i < rot / 90; ++i)
                orientation = cw[orientation];
        } else if (type == heif_item_property_type_transform_mirror) {
            int mirror = heif_item_get_property_transform_mirror(raw_ctx, id,
                                                                 xprops[i]);
            //                                1  2  3  4  5  6  7  8
            static const int mirrorh[] = { 0, 2, 1, 4, 3, 6, 5, 8, 7 };
            static const int mirrorv[] = { 0, 4, 3, 2, 1, 8, 7, 6, 5 };
            if (mirror == heif_transform_mirror_direction_vertical) {
                orientation = mirrorv[orientation];
            } else if (mirror == heif_transform_mirror_direction_horizontal) {
                orientation = mirrorh[orientation];
            }
        }
    }
#else
    // Prior to libheif 1.16, the get_transformation_properties API was not
    // available, so we have to rely on the Exif orientation tag.
    int orientation = m_spec.get_int_attribute("Orientation", 1);
#endif
]=])

set(_new_block [=[
    int orientation = m_spec.get_int_attribute("Orientation", 1);
]=])

string(FIND "${_content}" "reinterpret_cast<std::shared_ptr<heif_context>*>(m_ctx.get())->get()" _unsafe_pos)
if(NOT _unsafe_pos EQUAL -1)
  string(REPLACE "${_old_block}" "${_new_block}" _content "${_content}")
endif()

if(NOT _unsafe_pos EQUAL -1)
  string(FIND "${_content}" "reinterpret_cast<std::shared_ptr<heif_context>*>(m_ctx.get())->get()" _check_pos)
  if(NOT _check_pos EQUAL -1)
    message(FATAL_ERROR "Failed to remove unsafe heif::Context reinterpret-cast in ${OIIO_HEIFINPUT_FILE}")
  endif()
endif()

file(WRITE "${OIIO_HEIFINPUT_FILE}" "${_content}")
message(STATUS "Applied OIIO HEIF input orientation guard patch to ${OIIO_HEIFINPUT_FILE}")