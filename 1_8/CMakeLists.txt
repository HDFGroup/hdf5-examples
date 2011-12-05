cmake_minimum_required (VERSION 2.8.6)
PROJECT (HDF5 C CXX)

#-----------------------------------------------------------------------------
# Instructions for use : Normal Build
#
# For standard build of HDF5 examples.
#-----------------------------------------------------------------------------
IF (USE_SHARED_LIBS)
  SET (BUILD_NAME_EXT "SHARED")
ELSE (USE_SHARED_LIBS)
  SET (BUILD_NAME_EXT "STATIC")
ENDIF (USE_SHARED_LIBS)

#-----------------------------------------------------------------------------
# Define some CMake variables for use later in the project
#-----------------------------------------------------------------------------
SET (HDF5_RESOURCES_DIR      ${HDF5_SOURCE_DIR}/config/cmake)
SET (HDF5_C_SRC_DIR          ${HDF5_SOURCE_DIR}/C)
SET (HDF5_F90_SRC_DIR        ${HDF5_SOURCE_DIR}/FORTRAN)

#-----------------------------------------------------------------------------
# Include some macros for reusable code
#-----------------------------------------------------------------------------
INCLUDE (${HDF5_RESOURCES_DIR}/HDFMacros.cmake)
INCLUDE (${HDF5_RESOURCES_DIR}/HDF5Macros.cmake)

#-----------------------------------------------------------------------------
# Setup output Directories
#-----------------------------------------------------------------------------
SET (CMAKE_RUNTIME_OUTPUT_DIRECTORY
    ${PROJECT_BINARY_DIR}/bin CACHE PATH "Single Directory for all Executables."
)
SET (CMAKE_LIBRARY_OUTPUT_DIRECTORY
    ${PROJECT_BINARY_DIR}/bin CACHE PATH "Single Directory for all Libraries"
)
SET (CMAKE_ARCHIVE_OUTPUT_DIRECTORY
    ${PROJECT_BINARY_DIR}/bin CACHE PATH "Single Directory for all static libraries."
)
SET (CMAKE_Fortran_MODULE_DIRECTORY
    ${PROJECT_BINARY_DIR}/bin/fortran CACHE PATH "Single Directory for all fortran modules."
)

#-----------------------------------------------------------------------------
# Option to Build Static executables
#-----------------------------------------------------------------------------
OPTION (BUILD_STATIC_EXECS "Build Static Executabless" OFF)
IF (BUILD_STATIC_EXECS)
  IF (NOT WIN32)
    SET (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -static")
    SET (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -static")
  ENDIF (NOT WIN32)
ENDIF (BUILD_STATIC_EXECS)

#-----------------------------------------------------------------------------
# When building utility executables that generate other (source) files :
# we make use of the following variables defined in the root CMakeLists.
# Certain systems may add /Debug or /Release to output paths
# and we need to call the executable from inside the CMake configuration
#-----------------------------------------------------------------------------
SET (EXE_EXT "")
IF (WIN32)
  SET (EXE_EXT ".exe")
  IF (NOT CYGWIN)
    ADD_DEFINITIONS (-DBIND_TO_CURRENT_VCLIBS_VERSION=1)
    ADD_DEFINITIONS (-D_CRT_SECURE_NO_WARNINGS)
  ENDIF (NOT CYGWIN)
ENDIF (WIN32)

IF (MSVC)
  SET (CMAKE_MFC_FLAG 0)
ENDIF (MSVC)

SET (MAKE_SYSTEM)
IF (CMAKE_BUILD_TOOL MATCHES "make")
  SET (MAKE_SYSTEM 1)
ENDIF (CMAKE_BUILD_TOOL MATCHES "make")

SET (CFG_INIT "/${CMAKE_CFG_INTDIR}")
IF (MAKE_SYSTEM)
  SET (CFG_INIT "")
ENDIF (MAKE_SYSTEM)

#-----------------------------------------------------------------------------
# Compiler specific flags : Shouldn't there be compiler tests for these
#-----------------------------------------------------------------------------
IF (CMAKE_COMPILER_IS_GNUCC)
  SET (CMAKE_C_FLAGS "${CMAKE_ANSI_CFLAGS} ${CMAKE_C_FLAGS} -std=c99 -fomit-frame-pointer -finline-functions -fno-common")
ENDIF (CMAKE_COMPILER_IS_GNUCC)

#-----------------------------------------------------------------------------
# HDF5 support
#-----------------------------------------------------------------------------
SET (CMAKE_MODULE_PATH ${HDF5_RESOURCES_DIR} ${CMAKE_MODULE_PATH})

IF (NOT USE_SHARED_LIBS)
  SET (HDF5_USE_STATIC_LIBRARIES 1)
ENDIF (NOT USE_SHARED_LIBS)

ADD_DEFINITIONS (-DH5_USE_18_API)

IF (NOT HDF5_HDF5_HEADER)
  FIND_PACKAGE (HDF5)
  IF (HDF5_FOUND)
    SET (HDF5_HAVE_H5PUBCONF_H 1)
    SET (HDF5_HAVE_HDF5 1)
    SET (HDF5_HDF5_HEADER "h5pubconf.h")
    SET (HDF5_INCLUDE_DIR_GEN ${HDF5_INCLUDE_DIR})
    MESSAGE (STATUS "HDF5 found")
    IF ((NOT USE_SHARED_LIBS AND HDF5_BUILD_SHARED_LIBS) OR (USE_SHARED_LIBS AND NOT HDF5_BUILD_SHARED_LIBS))
      MESSAGE (STATUS "HDF5 build type does match requested type")
    ENDIF ((NOT USE_SHARED_LIBS AND HDF5_BUILD_SHARED_LIBS) OR (USE_SHARED_LIBS AND NOT HDF5_BUILD_SHARED_LIBS))
  ELSE (HDF5_FOUND)
    MESSAGE (FATAL_ERROR " HDF5 is Required for HDF5 Examples")
  ENDIF (HDF5_FOUND)
ELSE (NOT HDF5_HDF5_HEADER)
  # This project is being called from within another and HDF5 is already configured
  SET (HDF5_HAVE_H5PUBCONF_H 1)
  SET (HDF5_HAVE_HDF5 1)
ENDIF (NOT HDF5_HDF5_HEADER)
IF (NOT HDF5_LIBRARY)
  SET (HDF5_LIBRARY ${HDF5_LIBRARIES})
ENDIF (NOT HDF5_LIBRARY)
ADD_EXECUTABLE (h5dump IMPORTED)
IF (USE_SHARED_LIBS AND WIN32)
  SET_PROPERTY (TARGET h5dump PROPERTY IMPORTED_LOCATION "${HDF5_TOOLS_DIR}/h5dumpdll")
ELSE (USE_SHARED_LIBS AND WIN32)
  SET_PROPERTY (TARGET h5dump PROPERTY IMPORTED_LOCATION "${HDF5_TOOLS_DIR}/h5dump")
ENDIF (USE_SHARED_LIBS AND WIN32)
SET (HDF5_DUMP_EXECUTABLE $<TARGET_FILE:h5dump>)
SET (LINK_LIBS ${LINK_LIBS} ${HDF5_LIBRARIES})
INCLUDE_DIRECTORIES (${HDF5_INCLUDE_DIRS})
IF (HDF_BUILD_FORTRAN)
  INCLUDE_DIRECTORIES (${HDF5_INCLUDE_DIR_FORTRAN})
ENDIF (HDF_BUILD_FORTRAN)

#-----------------------------------------------------------------------------
# Option to use Shared/Static libs, default is static
#-----------------------------------------------------------------------------
SET (LIB_TYPE STATIC)
IF (BUILD_SHARED_LIBS)
  SET (LIB_TYPE SHARED)
  SET (H5_BUILT_AS_DYNAMIC_LIB 1)
ELSE (BUILD_SHARED_LIBS)
  IF (NOT WIN32)
    # should this be a user setting : Everyone uses it anyway ?
    ADD_DEFINITIONS (-DPIC)
  ENDIF (NOT WIN32)
ENDIF (BUILD_SHARED_LIBS)

IF (MSVC)
  SET (CMAKE_MFC_FLAG 0)
ENDIF (MSVC)

#-----------------------------------------------------------------------------
# Option to allow the user to disable compiler warnings
#-----------------------------------------------------------------------------
OPTION (HDF_DISABLE_COMPILER_WARNINGS "Disable compiler warnings" OFF)
IF (HDF_DISABLE_COMPILER_WARNINGS)
  # MSVC uses /w to suppress warnings.  It also complains if another
  # warning level is given, so remove it.
  IF (MSVC)
    SET (HDF_WARNINGS_BLOCKED 1)
    STRING (REGEX REPLACE "(^| )([/-])W[0-9]( |$)" " "
        CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
    SET (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /w")
  ENDIF (MSVC)
  IF (WIN32 AND NOT CYGWIN)
    ADD_DEFINITIONS (-D_CRT_SECURE_NO_WARNINGS)
  ENDIF (WIN32 AND NOT CYGWIN)
  # Borland uses -w- to suppress warnings.
  IF (BORLAND)
    SET (HDF_WARNINGS_BLOCKED 1)
    SET (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -w-")
  ENDIF (BORLAND)

  # Most compilers use -w to suppress warnings.
  IF (NOT HDF_WARNINGS_BLOCKED)
    SET (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -w")
  ENDIF (NOT HDF_WARNINGS_BLOCKED)
ENDIF (HDF_DISABLE_COMPILER_WARNINGS)

#-----------------------------------------------------------------------------
# This is in here to help some of the GCC based IDES like Eclipse
# and code blocks parse the compiler errors and warnings better.
#-----------------------------------------------------------------------------
IF (CMAKE_COMPILER_IS_GNUCC)
  SET (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fmessage-length=0")
ENDIF (CMAKE_COMPILER_IS_GNUCC)
IF (CMAKE_COMPILER_IS_GNUCXX)
  SET (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fmessage-length=0")
ENDIF (CMAKE_COMPILER_IS_GNUCXX)

#-----------------------------------------------------------------------------
# All examples need the main include directories
#-----------------------------------------------------------------------------
INCLUDE_DIRECTORIES (${HDF5_BINARY_DIR})

#-----------------------------------------------------------------------------
# Option to Enable MPI Parallel
#-----------------------------------------------------------------------------
SET (CMAKE_MODULE_PATH ${HDF5_RESOURCES_DIR} ${CMAKE_MODULE_PATH})
OPTION (HDF_ENABLE_PARALLEL "Enable parallel build (requires MPI)" OFF)
IF (HDF_ENABLE_PARALLEL)
  INCLUDE (FindMPI)
  INCLUDE_DIRECTORIES (${MPI_INCLUDE_PATH})
  IF (MPI_FOUND)
    SET (H5_HAVE_PARALLEL 1)
    # MPI checks, only do these if MPI_FOUND is true, otherwise they always fail
    # and once set, they are cached as false and not regenerated
    SET (CMAKE_REQUIRED_LIBRARIES "${MPI_LIBRARY};${MPI_EXTRA_LIBRARY}" )
    CHECK_FUNCTION_EXISTS (MPI_File_get_size H5_HAVE_MPI_GET_SIZE) 
    # Used by Fortran + MPI
    CHECK_SYMBOL_EXISTS (MPI_Comm_c2f "${MPI_INCLUDE_PATH}/mpi.h"  H5_HAVE_MPI_MULTI_LANG_Comm)
    CHECK_SYMBOL_EXISTS (MPI_Info_c2f "${MPI_INCLUDE_PATH}/mpi.h"  H5_HAVE_MPI_MULTI_LANG_Info)
  ENDIF (MPI_FOUND)
ENDIF (HDF_ENABLE_PARALLEL)

# Parallel IO usage requires MPI to be Linked and Included
IF (H5_HAVE_PARALLEL)
  SET (LINK_LIBS ${LINK_LIBS} ${MPI_LIBRARY})
  IF (MPI_LINK_FLAGS)
    SET (CMAKE_EXE_LINKER_FLAGS ${MPI_LINK_FLAGS} ${CMAKE_EXE_LINKER_FLAGS})
  ENDIF (MPI_LINK_FLAGS)
  IF (MPI_EXTRA_LIBRARY)
    SET (LINK_LIBS ${LINK_LIBS} ${MPI_EXTRA_LIBRARY})
  ENDIF (MPI_EXTRA_LIBRARY)
ENDIF (H5_HAVE_PARALLEL)

#-----------------------------------------------------------------------------
# Option to use threadsafe
# Note: Currently CMake only allows configuring of threadsafe on WINDOWS.
#-----------------------------------------------------------------------------
IF (WIN32 AND NOT CYGWIN)
  OPTION (HDF_ENABLE_THREADSAFE "Enable Threadsafety" OFF)
  IF (HDF_ENABLE_THREADSAFE)
    # check for unsupported options
    IF (HDF_ENABLE_PARALLEL)
      MESSAGE (FATAL " **** Parallel and Threadsafe options are mutually exclusive **** ")
    ENDIF (HDF_ENABLE_PARALLEL)
    SET (H5_HAVE_WIN_THREADS 1)
    SET (H5_HAVE_THREADSAFE 1)
  ENDIF (HDF_ENABLE_THREADSAFE)
ENDIF (WIN32 AND NOT CYGWIN)

#-----------------------------------------------------------------------------
# Build utility to copy and strip X lines of file
#-----------------------------------------------------------------------------
IF (BUILD_TESTING)
  SET (XLATE_UTILITY "xlatefile")
  ADD_EXECUTABLE(${XLATE_UTILITY} ${HDF5_RESOURCES_DIR}/xlatefile.c)
ENDIF (BUILD_TESTING)

#-----------------------------------------------------------------------------
# Dashboard and Testing Settings
#-----------------------------------------------------------------------------
OPTION (BUILD_TESTING "Build HDF5 Example Testing" OFF)
IF (BUILD_TESTING)
  SET (DART_TESTING_TIMEOUT 1200
      CACHE INTEGER
      "Timeout in seconds for each test (default 1200=20minutes)"
  )
  ENABLE_TESTING ()
  INCLUDE (CTest)
  INCLUDE (${HDF5_SOURCE_DIR}/CTestConfig.cmake)
  CONFIGURE_FILE (${HDF5_RESOURCES_DIR}/CTestCustom.cmake ${HDF5_BINARY_DIR}/CTestCustom.ctest @ONLY)
ENDIF (BUILD_TESTING)

#-----------------------------------------------------------------------------
# Build examples
#-----------------------------------------------------------------------------
ADD_SUBDIRECTORY (${HDF5_SOURCE_DIR}/C ${PROJECT_BINARY_DIR}/C)

#-----------------------------------------------------------------------------
# Option to build Fortran examples
# Make sure this appears before the CONFIGURE_FILE step
# so that fortran name mangling is detected before writing H5pubconf.h
#-----------------------------------------------------------------------------
# Set default name mangling : overridden by Fortran detection in fortran dir
SET (H5_FC_FUNC  "H5_FC_FUNC(name,NAME) name ## _")
SET (H5_FC_FUNC_ "H5_FC_FUNC_(name,NAME) name ## _")
IF (EXISTS "${HDF5_SOURCE_DIR}/FORTRAN" AND IS_DIRECTORY "${HDF5_SOURCE_DIR}/FORTRAN")
  OPTION (HDF_BUILD_FORTRAN "Build FORTRAN support" OFF)
  IF (HDF_BUILD_FORTRAN AND HDF5_BUILD_FORTRAN)
    INCLUDE (${HDF5_RESOURCES_DIR}/HDF5UseFortran.cmake)
    ADD_SUBDIRECTORY (${HDF5_SOURCE_DIR}/FORTRAN ${PROJECT_BINARY_DIR}/FORTRAN)
  ENDIF (HDF_BUILD_FORTRAN AND HDF5_BUILD_FORTRAN)
ENDIF (EXISTS "${HDF5_SOURCE_DIR}/FORTRAN" AND IS_DIRECTORY "${HDF5_SOURCE_DIR}/FORTRAN")
