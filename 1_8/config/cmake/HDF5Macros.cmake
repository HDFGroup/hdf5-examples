#-------------------------------------------------------------------------------
macro (H5_SET_LIB_OPTIONS libtarget libname libtype)
  HDF_SET_LIB_OPTIONS (${libtarget} ${libname} ${libtype})
  if (${libtype} MATCHES "SHARED")
    if (WIN32)
      set (LIBHDF_VERSION ${HDF5_PACKAGE_VERSION_MAJOR})
    else (WIN32)
      set (LIBHDF_VERSION ${HDF5_PACKAGE_VERSION})
    endif (WIN32)
    set_target_properties (${libtarget} PROPERTIES VERSION ${LIBHDF_VERSION})
    set_target_properties (${libtarget} PROPERTIES SOVERSION ${LIBHDF_VERSION})
  endif (${libtype} MATCHES "SHARED")

  #-- Apple Specific install_name for libraries
  if (APPLE)
    option (HDF5_BUILD_WITH_INSTALL_NAME "Build with library install_name set to the installation path" OFF)
    if (HDF5_BUILD_WITH_INSTALL_NAME)
      SET_TARGET_PROPERTIES(${libtarget} PROPERTIES
          LINK_FLAGS "-current_version ${HDF5_PACKAGE_VERSION} -compatibility_version ${HDF5_PACKAGE_VERSION}"
          INSTALL_NAME_DIR "${CMAKE_INSTALL_PREFIX}/lib"
          BUILD_WITH_INSTALL_RPATH ${HDF5_BUILD_WITH_INSTALL_NAME}
      )
    endif (HDF5_BUILD_WITH_INSTALL_NAME)
  endif (APPLE)

endmacro (H5_SET_LIB_OPTIONS)
