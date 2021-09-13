cmake_minimum_required (VERSION 3.12)
project (H5EXAMPLES C CXX)

#-----------------------------------------------------------------------------
# Basic HDF5Examples stuff here
#-----------------------------------------------------------------------------
include (${H5EXAMPLES_SOURCE_DIR}/config/cmake/HDFMacros.cmake)
include (${H5EXAMPLES_SOURCE_DIR}/config/cmake/HDFExampleMacros.cmake)
set (CMAKE_JAVA_INCLUDE_PATH "")

SET_HDF_BUILD_TYPE()

BASIC_SETTINGS (EXAMPLES)

#-----------------------------------------------------------------------------
# HDF5 support
#-----------------------------------------------------------------------------
HDF5_SUPPORT (TRUE)
message (STATUS "HDF5 link libs: ${LINK_LIBS}")

#-----------------------------------------------------------------------------
# Build examples
#-----------------------------------------------------------------------------
option (BUILD_1_6 "Build HDF5 1.6 Example Testing" ON)
if (BUILD_1_6 AND HDF5_VERSION_MAJOR VERSION_GREATER_EQUAL 1.6)
  add_subdirectory (1_6)
endif ()
option (BUILD_1_8 "Build HDF5 1.8 Example Testing" ON)
if (BUILD_1_8 AND HDF5_VERSION_MAJOR VERSION_GREATER_EQUAL 1.8)
  add_subdirectory (1_8)
endif ()
option (BUILD_1_10 "Build HDF5 1.10 Example Testing" ON)
if (BUILD_1_10 AND HDF5_VERSION_MAJOR VERSION_GREATER_EQUAL 1.10)
  add_subdirectory (1_10)
endif ()
option (BUILD_1_12 "Build HDF5 1.12 Example Testing" ON)
if (BUILD_1_12 AND HDF5_VERSION_MAJOR VERSION_GREATER_EQUAL 1.12)
  add_subdirectory (1_12)
endif ()
option (BUILD_1_14 "Build HDF5 develop Example Testing" ON)
if (BUILD_1_14 AND HDF5_VERSION_MAJOR VERSION_GREATER 1.12)
  add_subdirectory (1_14)
endif ()

#-----------------------------------------------------------------------------
# Dashboard and Testing Settings
#-----------------------------------------------------------------------------
option (BUILD_TESTING "Build HDF5 Example Testing" OFF)
if (BUILD_TESTING)
  set (DART_TESTING_TIMEOUT 1200 CACHE STRING
      "Timeout in seconds for each test (default 1200=20minutes)"
  )
  enable_testing ()
  include (CTest)
  include (${PROJECT_SOURCE_DIR}/CTestConfig.cmake)
  configure_file (${${EXAMPLE_PACKAGE_NAME}_RESOURCES_DIR}/CTestCustom.cmake ${PROJECT_BINARY_DIR}/CTestCustom.ctest @ONLY)
endif ()

#-----------------------------------------------------------------------------
# Source Packaging Option
#-----------------------------------------------------------------------------
option (PACK_EXAMPLE_SOURCE "Package HDF5 Example Source File" OFF)
if (PACK_EXAMPLE_SOURCE)
  set(CPACK_SOURCE_IGNORE_FILES
      "^${PROJECT_SOURCE_DIR}/\\\\.git*"
      "^${PROJECT_SOURCE_DIR}/\\\\.project"
  )
  set (CPACK_PACKAGE_VENDOR "HDF_Group")
  set (CPACK_PACKAGE_NAME "HDF5Examples")
  set (CPACK_GENERATOR "TGZ")
  set (CPACK_SOURCE_GENERATOR "TGZ")
  if (WIN32)
    set (CPACK_GENERATOR "ZIP")
    set (CPACK_SOURCE_GENERATOR "ZIP")
  endif()
  set (CPACK_TOPLEVEL_TAG "HDF5Examples-${CPACK_PACKAGE_VERSION}-Source")
  set (CPACK_SOURCE_TOPLEVEL_TAG "HDF5Examples-${CPACK_PACKAGE_VERSION}-Source")
  set (CPACK_SOURCE_PACKAGE_FILE_NAME "HDF5Examples-Source")
  INCLUDE(CPack)
  # Installation types
  cpack_add_install_type(Full DISPLAY_NAME "Everything")

  # Component groups
  cpack_add_component_group(Development
      EXPANDED
      DESCRIPTION "All of the examples to test HDF5 library"
  )
  cpack_add_component(source
      DISPLAY_NAME "Source Files"
      DESCRIPTION "Source files of HDF5 Library Examples"
      GROUP Development
      INSTALL_TYPES Full
  )
endif ()
