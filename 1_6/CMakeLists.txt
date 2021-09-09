cmake_minimum_required (VERSION 3.12)
project (H516EX C CXX)

#-----------------------------------------------------------------------------
# Basic H516EX stuff here
#-----------------------------------------------------------------------------
if (NOT H5EXAMPLES_RESOURCES_DIR)
  include (${H516EX_SOURCE_DIR}/config/cmake/HDFMacros.cmake)
  include (${H516EX_SOURCE_DIR}/config/cmake/HDFExampleMacros.cmake)

  SET_HDF_BUILD_TYPE()
endif ()

BASIC_SETTINGS (16EX)

#-----------------------------------------------------------------------------
# Define some CMake variables for use later in the project
#-----------------------------------------------------------------------------
set (HDF5EX_C_SRC_DIR          ${H516EX_SOURCE_DIR}/C)

#-----------------------------------------------------------------------------
# HDF5 support
#-----------------------------------------------------------------------------
HDF5_SUPPORT (TRUE)
message (STATUS "H516EX link libs: ${LINK_LIBS}")

if (WIN32)
  set(CMAKE_TEST_LIB_DIRECTORY "${HDF5_TOOLS_DIR}")
else ()
  set(CMAKE_TEST_LIB_DIRECTORY "${HDF5_LIBRARY_PATH}")
endif ()

#-----------------------------------------------------------------------------
# Option to use 1.6.x API
#-----------------------------------------------------------------------------
option (${EXAMPLE_VARNAME}_USE_16_API "Use the HDF5 1.6.x API" ON)

#-----------------------------------------------------------------------------
# Dashboard and Testing Settings
#-----------------------------------------------------------------------------
option (BUILD_TESTING "Build H516EX Example Testing" OFF)
if (BUILD_TESTING)
  set (DART_TESTING_TIMEOUT 1200 CACHE STRING
       "Timeout in seconds for each test (default 1200=20minutes)")
  enable_testing ()
  include (CTest)
  include (${H516EX_SOURCE_DIR}/CTestConfig.cmake)
  configure_file (${${EXAMPLE_PACKAGE_NAME}_RESOURCES_DIR}/CTestCustom.cmake ${PROJECT_BINARY_DIR}/CTestCustom.ctest @ONLY)
endif ()

#-----------------------------------------------------------------------------
# Build examples
#-----------------------------------------------------------------------------
add_subdirectory (C)
