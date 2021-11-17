cmake_minimum_required (VERSION 3.12)
project (H518EX C CXX)

#-----------------------------------------------------------------------------
# Basic H518EX stuff here
#-----------------------------------------------------------------------------
if (NOT H5EXAMPLES_RESOURCES_DIR)
  include (${H518EX_SOURCE_DIR}/config/cmake/HDFExampleMacros.cmake)

  SET_HDF_BUILD_TYPE()
endif ()

BASIC_SETTINGS (18EX)

#-----------------------------------------------------------------------------
# Define some CMake variables for use later in the project
#-----------------------------------------------------------------------------
set (HDF5EX_C_SRC_DIR          ${H518EX_SOURCE_DIR}/C)
set (HDF5EX_F90_SRC_DIR        ${H518EX_SOURCE_DIR}/FORTRAN)

#-----------------------------------------------------------------------------
# HDF5 support
#-----------------------------------------------------------------------------
HDF5_SUPPORT (TRUE)
message (STATUS "H518EX link libs: ${LINK_LIBS}")

if (WIN32)
  set(CMAKE_TEST_LIB_DIRECTORY "${HDF5_TOOLS_DIR}")
else ()
  set(CMAKE_TEST_LIB_DIRECTORY "${HDF5_LIBRARY_PATH}")
endif ()

#-----------------------------------------------------------------------------
# Option to use 1.6.x API
#-----------------------------------------------------------------------------
option (${EXAMPLE_VARNAME}_USE_16_API "Use the HDF5 1.6.x API" OFF)

#-----------------------------------------------------------------------------
# Option to use 1.8.x API
#-----------------------------------------------------------------------------
option (${EXAMPLE_VARNAME}_USE_18_API "Use the HDF5 1.8.x API" ON)

#-----------------------------------------------------------------------------
# Dashboard and Testing Settings
#-----------------------------------------------------------------------------
option (BUILD_TESTING "Build H518EX Example Testing" OFF)
if (BUILD_TESTING)
  set (DART_TESTING_TIMEOUT 1200 CACHE STRING
       "Timeout in seconds for each test (default 1200=20minutes)")
  enable_testing ()
  include (CTest)
  include (${H518EX_SOURCE_DIR}/CTestConfig.cmake)
  configure_file (${${EXAMPLE_PACKAGE_NAME}_RESOURCES_DIR}/CTestCustom.cmake ${PROJECT_BINARY_DIR}/CTestCustom.ctest @ONLY)
endif ()

#-----------------------------------------------------------------------------
# Build examples
#-----------------------------------------------------------------------------
add_subdirectory (C)

#-----------------------------------------------------------------------------
# Option to build Fortran examples
# Make sure this appears before the CONFIGURE_FILE step
# so that fortran name mangling is detected before writing H5pubconf.h
#-----------------------------------------------------------------------------
# Set default name mangling : overridden by Fortran detection in fortran dir
set (H5_FC_FUNC  "H5_FC_FUNC(name,NAME) name ## _")
set (H5_FC_FUNC_ "H5_FC_FUNC_(name,NAME) name ## _")
if (EXISTS "${H518EX_SOURCE_DIR}/FORTRAN" AND IS_DIRECTORY "${H518EX_SOURCE_DIR}/FORTRAN")
  option (HDF_BUILD_FORTRAN "Build FORTRAN support" OFF)
  if (HDF_BUILD_FORTRAN AND HDF5_BUILD_FORTRAN)
    set (LINK_Fortran_LIBS ${LINK_LIBS})

    # Parallel IO usage requires MPI to be Linked and Included
    if (H5_HAVE_PARALLEL)
      set (LINK_Fortran_LIBS ${LINK_Fortran_LIBS} ${MPI_Fortran_LIBRARIES})
      if (MPI_Fortran_LINK_FLAGS)
        set (CMAKE_Fortran_EXE_LINKER_FLAGS "${MPI_Fortran_LINK_FLAGS} ${CMAKE_EXE_LINKER_FLAGS}")
      endif ()
    endif ()

    add_subdirectory (FORTRAN)
  endif ()
endif ()

#-----------------------------------------------------------------------------
# Option to build filter examples
#-----------------------------------------------------------------------------
if (EXISTS "${H518EX_SOURCE_DIR}/C/H5Filters" AND IS_DIRECTORY "${H518EX_SOURCE_DIR}/C/H5Filters")
  option (HDF_BUILD_FILTERS "Test filter support" OFF)
endif ()
