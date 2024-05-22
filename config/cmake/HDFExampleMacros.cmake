#
# Copyright by The HDF Group.
# All rights reserved.
#
# This file is part of HDF5.  The full HDF5 copyright notice, including
# terms governing use, modification, and redistribution, is contained in
# the COPYING file, which can be found at the root of the source code
# distribution tree, or in https://www.hdfgroup.org/licenses.
# If you do not have access to either file, you may request a copy from
# help@hdfgroup.org.
#

#-------------------------------------------------------------------------------
macro (BASIC_SETTINGS varname)
  string (TOUPPER ${varname} EXAMPLE_PACKAGE_VARNAME)
  string (TOLOWER ${varname} EXAMPLE_VARNAME)
  set (H5${EXAMPLE_PACKAGE_VARNAME}_PACKAGE "h5${EXAMPLE_VARNAME}")
  set (H5${EXAMPLE_PACKAGE_VARNAME}_PACKAGE_NAME "h5${EXAMPLE_VARNAME}")
  string (TOUPPER ${H5${EXAMPLE_PACKAGE_VARNAME}_PACKAGE_NAME} EXAMPLE_PACKAGE_NAME)
  string (TOLOWER ${H5${EXAMPLE_PACKAGE_VARNAME}_PACKAGE_NAME} EXAMPLE_NAME)
  set (CMAKE_NO_SYSTEM_FROM_IMPORTED 1)

  #-----------------------------------------------------------------------------
  # Setup output Directories
  #-----------------------------------------------------------------------------
  SET_HDF_OUTPUT_DIRS(${EXAMPLE_PACKAGE_NAME})

  set (CMAKE_POSITION_INDEPENDENT_CODE ON)

  if (MSVC)
    set (CMAKE_MFC_FLAG 0)
  endif ()

  set (CMAKE_C_STANDARD 99)
  set (CMAKE_C_STANDARD_REQUIRED TRUE)

  if (HDF_BUILD_CPP_LIB)
    ENABLE_LANGUAGE (CXX)

    set (CMAKE_CXX_STANDARD 98)
    set (CMAKE_CXX_STANDARD_REQUIRED TRUE)
    set (CMAKE_CXX_EXTENSIONS OFF)
  endif ()

  #-----------------------------------------------------------------------------
  # Compiler specific flags : Shouldn't there be compiler tests for these
  #-----------------------------------------------------------------------------
  if (CMAKE_C_COMPILER_ID STREQUAL "GNU")
    set (CMAKE_C_FLAGS "${CMAKE_ANSI_CFLAGS} ${CMAKE_C_FLAGS}")
  endif ()
  if (CMAKE_CXX_COMPILER_LOADED AND CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set (CMAKE_CXX_FLAGS "${CMAKE_ANSI_CFLAGS} ${CMAKE_CXX_FLAGS}")
  endif ()

  #-----------------------------------------------------------------------------
  # This is in here to help some of the GCC based IDES like Eclipse
  # and code blocks parse the compiler errors and warnings better.
  #-----------------------------------------------------------------------------
  if (CMAKE_C_COMPILER_ID STREQUAL "GNU")
    set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fmessage-length=0")
  endif ()
  if (CMAKE_CXX_COMPILER_LOADED AND CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fmessage-length=0")
  endif ()

  #-----------------------------------------------------------------------------
  # Option to allow the user to disable compiler warnings
  #-----------------------------------------------------------------------------
  option (HDF_DISABLE_COMPILER_WARNINGS "Disable compiler warnings" OFF)
  if (HDF_DISABLE_COMPILER_WARNINGS)
    # MSVC uses /w to suppress warnings.  It also complains if another
    # warning level is given, so remove it.
    if (MSVC)
      set (HDF_WARNINGS_BLOCKED 1)
      string (REGEX REPLACE "(^| )([/-])W[0-9]( |$)" " " CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
      set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /w")
      if (CMAKE_CXX_COMPILER_LOADED AND CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        string (REGEX REPLACE "(^| )([/-])W[0-9]( |$)" " " CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
        set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /w")
      endif ()
    endif ()
    if (WIN32)
      add_definitions (-D_CRT_SECURE_NO_WARNINGS)
    endif ()
    # Borland uses -w- to suppress warnings.
    if (BORLAND)
     set (HDF_WARNINGS_BLOCKED 1)
      set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -w-")
    endif ()

    # Most compilers use -w to suppress warnings.
    if (NOT HDF_WARNINGS_BLOCKED)
      set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -w")
      if (CMAKE_CXX_COMPILER_LOADED AND CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -w")
      endif ()
    endif ()
  endif ()

  #-----------------------------------------------------------------------------
  # Set includes needed for build
  #-----------------------------------------------------------------------------
  set (${EXAMPLE_PACKAGE_NAME}_INCLUDES_BUILD_TIME
      ${${EXAMPLE_PACKAGE_NAME}_SRC_DIR} ${${EXAMPLE_PACKAGE_NAME}_BINARY_DIR}
  )
endmacro ()

macro (EXTERNAL_HDF5_LIBRARY compress_type)
  set (HDF5_VERSION "1.15.0")
  set (HDF5_VERSION_MAJOR "1.15")
  set (HDF5LIB_TGZ_NAME "hdf5.tar.gz" CACHE STRING "Use HDF5LIB from compressed file" FORCE)
  set (HDF5LIB_TGZ_ORIGPATH "https://github.com/HDFGroup/hdf5/releases/download/snapshot" CACHE STRING "Use HDF5LIB from original location" FORCE)
  set (HDF5LIB_USE_LOCALCONTENT ON CACHE BOOL "Use local file for HDF5LIB FetchContent" FORCE)
  set (HDF5LIB_GIT_URL "https://github.com/HDFGroup/hdf5.git" CACHE STRING "Use HDF5LIB from  GitHub repository" FORCE)
  set (HDF5LIB_GIT_BRANCH "develop" CACHE STRING "" FORCE)
  if (NOT HDF5LIB_USE_LOCALCONTENT)
    set (HDF5LIB_URL ${H5EXAMPLES_SOURCE_DIR}/${HDF5LIB_TGZ_NAME})
  else ()
    set (HDF5LIB_URL ${HDF5LIB_TGZ_ORIGPATH}/${HDF5LIB_TGZ_NAME})
  endif ()
  message (VERBOSE "Library HDF5LIB file is ${HDF5LIB_URL}")
  if (${compress_type} MATCHES "GIT")
    FetchContent_Declare (HDF5LIB
        GIT_REPOSITORY ${HDF5LIB_GIT_URL}
        GIT_TAG ${HDF5LIB_GIT_BRANCH}
    )
  elseif (${compress_type} MATCHES "TGZ")
    message (VERBOSE "Library HDF5LIB file ${HDF5LIB_URL}")
    FetchContent_Declare (HDF5LIB
        URL ${HDF5LIB_URL}
        URL_HASH ""
    )
  endif ()
  FetchContent_GetProperties(HDF5LIB)
  if(NOT hdf5lib_POPULATED)
    FetchContent_Populate(HDF5LIB)

    set (BUILD_SHARED_LIBS OFF CACHE BOOL "Build Shared Libraries" FORCE)
    set (HDF5_BUILD_CPP_LIB OFF CACHE BOOL "Build C++ support" FORCE)
    set (HDF5_BUILD_FORTRAN OFF CACHE BOOL "Build FORTRAN support" FORCE)
    set (HDF5_BUILD_JAVA OFF CACHE BOOL "Build JAVA support" FORCE)
    set (BUILD_TESTING OFF CACHE BOOL "Build JHDF5 Unit Testing" FORCE)
    set (HDF5_BUILD_EXAMPLES OFF CACHE BOOL "Build JHDF5 Library Examples" FORCE)
    set (HDF5_BUILD_HL_LIB OFF CACHE BOOL "Build JHDF5 HIGH Level HDF5 Library" FORCE)
    set (HDF5_ENABLE_Z_LIB_SUPPORT OFF CACHE BOOL "Enable Zlib Filters" FORCE)
    set (HDF5_ENABLE_SZIP_SUPPORT OFF CACHE BOOL "Use SZip Filter" FORCE)

    add_subdirectory(${hdf5lib_SOURCE_DIR} ${hdf5lib_BINARY_DIR})
  endif()

  add_library(${HDF_PACKAGE_NAMESPACE}hdf5lib-static ALIAS hdf5-static)
  set (H5LIB_STATIC_LIBRARY "${HDF_PACKAGE_NAMESPACE}hdf5lib-static")
  set (H5LIB_LIBRARIES ${H5LIB_STATIC_LIBRARY})
  set (H5LIB_TOOLS ${hdf5lib_BINARY_DIR}/bin})

  set (H5LIB_INCLUDE_DIR_GEN "${hdf5lib_BINARY_DIR}/src")
  set (H5LIB_INCLUDE_DIR "${hdf5lib_SOURCE_DIR}/src")
  set (H5LIB_FOUND 1)
  set (H5LIB_INCLUDE_DIRS ${H5LIB_INCLUDE_DIR_GEN} ${H5LIB_INCLUDE_DIR})
  message (STATUS "HDF5-${HDF5_VERSION} found: INC=${H5LIB_INCLUDE_DIRS} TOOLS=${H5LIB_TOOLS}")
endmacro ()

macro (HDF5_SUPPORT)
  set (CMAKE_MODULE_PATH ${H5EX_RESOURCES_DIR} ${CMAKE_MODULE_PATH})
  option (USE_SHARED_LIBS "Use Shared Libraries" ON)

  if (HDF_FETCH_HDF5)
    include (FetchContent)
    EXTERNAL_HDF5_LIBRARY(GIT)
    set (H5EX_HDF5_INCLUDE_DIRS ${H5LIB_INCLUDE_DIRS})
    set (H5EX_HDF5_HAVE_H5PUBCONF_H 1)
    set (H5EX_HDF5_HAVE_HDF5 1)
    set (H5EX_HDF5_HEADER "h5pubconf.h")
    set (H5EX_HDF5_LINK_LIBS ${H5EX_HDF5_LINK_LIBS} ${H5LIB_LIBRARIES})
    if (NOT TARGET h5dump)
      add_executable (h5dump IMPORTED)
    endif()
    set (H5EX_HDF5_DUMP_EXECUTABLE $<TARGET_FILE:h5dump>)
  else ()
    if (NOT H5EX_HDF5_HEADER)
      if (USE_SHARED_LIBS)
        set (FIND_HDF_COMPONENTS C shared)
      else ()
        set (FIND_HDF_COMPONENTS C static)
        set (HDF_BUILD_JAVA OFF CACHE BOOL "Build Java support" FORCE)
        message (STATUS "Using static HDF5 - disable build of Java examples")
      endif ()
      if (HDF_BUILD_FORTRAN)
        set (FIND_HDF_COMPONENTS ${FIND_HDF_COMPONENTS} Fortran)
      endif ()
      if (HDF_BUILD_JAVA)
        set (FIND_HDF_COMPONENTS ${FIND_HDF_COMPONENTS} Java)
        set (HDF5_Java_FOUND 1) #default setting for 1.10.1 and earlier
      endif ()
      message (STATUS "HDF5 find comps: ${FIND_HDF_COMPONENTS}")
      set (SEARCH_PACKAGE_NAME ${HDF5_PACKAGE_NAME})

      find_package (HDF5 NAMES ${SEARCH_PACKAGE_NAME} COMPONENTS ${FIND_HDF_COMPONENTS})
      message (STATUS "HDF5 C libs:${HDF5_FOUND} static:${HDF5_static_C_FOUND} and shared:${HDF5_shared_C_FOUND}")
      message (STATUS "HDF5 Fortran libs: static:${HDF5_static_Fortran_FOUND} and shared:${HDF5_shared_Fortran_FOUND}")
      message (STATUS "HDF5 Java libs: ${HDF5_Java_FOUND}")
      if (HDF5_FOUND)
        if (NOT HDF5_static_C_FOUND AND NOT HDF5_shared_C_FOUND)
          #find library from non-dual-binary package
          set (FIND_HDF_COMPONENTS C)
          if (HDF_BUILD_FORTRAN)
            set (FIND_HDF_COMPONENTS ${FIND_HDF_COMPONENTS} Fortran)
          endif ()
          if (HDF_BUILD_JAVA)
            set (FIND_HDF_COMPONENTS ${FIND_HDF_COMPONENTS} Java)
         endif ()
          message (STATUS "HDF5 find comps: ${FIND_HDF_COMPONENTS}")

          find_package (HDF5 NAMES ${SEARCH_PACKAGE_NAME} COMPONENTS ${FIND_HDF_COMPONENTS})
          message (STATUS "HDF5 libs:${HDF5_FOUND} C:${HDF5_C_FOUND} Fortran:${HDF5_Fortran_FOUND} Java:${HDF5_Java_FOUND}")
          set (H5EX_HDF5_LINK_LIBS ${H5EX_HDF5_LINK_LIBS} ${HDF5_LIBRARIES})
          if (HDF5_BUILD_SHARED_LIBS)
            add_definitions (-DH5_BUILT_AS_DYNAMIC_LIB)
          else ()
            add_definitions (-DH5_BUILT_AS_STATIC_LIB)
          endif ()
          if (USE_SHARED_LIBS AND WIN32)
            set_property (TARGET ${HDF5_NAMESPACE}h5dump PROPERTY IMPORTED_LOCATION "${HDF5_TOOLS_DIR}/h5dumpdll")
          else ()
            set_property (TARGET ${HDF5_NAMESPACE}h5dump PROPERTY IMPORTED_LOCATION "${HDF5_TOOLS_DIR}/h5dump")
          endif ()
          if (HDF_BUILD_JAVA)
            set (CMAKE_JAVA_INCLUDE_PATH "${CMAKE_JAVA_INCLUDE_PATH};${HDF5_JAVA_INCLUDE_DIRS}")
            message (STATUS "HDF5 jars:${HDF5_JAVA_INCLUDE_DIRS}")
          endif ()
          set (H5EX_HDF5_DUMP_EXECUTABLE $<TARGET_FILE:${HDF5_NAMESPACE}h5dump>)
        else ()
          if (USE_SHARED_LIBS AND HDF5_shared_C_FOUND)
            set (H5EX_HDF5_LINK_LIBS ${H5EX_HDF5_LINK_LIBS} ${HDF5_C_SHARED_LIBRARY})
            set (HDF5_LIBRARY_PATH ${PACKAGE_PREFIX_DIR}/lib)
          else ()
            set (H5EX_HDF5_LINK_LIBS ${H5EX_HDF5_LINK_LIBS} ${HDF5_C_STATIC_LIBRARY})
          endif ()
          if (HDF5_VERSION VERSION_LESS "1.14.4" AND NOT HDF5_shared_C_FOUND)
            if (NOT TARGET ${HDF5_NAMESPACE}h5dump-shared)
              add_executable (${HDF5_NAMESPACE}h5dump-shared IMPORTED)
            endif ()
            set (H5EX_HDF5_DUMP_EXECUTABLE $<TARGET_FILE:${HDF5_NAMESPACE}h5dump-shared>)
          else ()
            if (NOT TARGET ${HDF5_NAMESPACE}h5dump)
              add_executable (${HDF5_NAMESPACE}h5dump IMPORTED)
           endif()
            set (H5EX_HDF5_DUMP_EXECUTABLE $<TARGET_FILE:${HDF5_NAMESPACE}h5dump>)
          endif()

          if (NOT HDF5_static_Fortran_FOUND AND NOT HDF5_shared_Fortran_FOUND)
            set (HDF_BUILD_FORTRAN OFF CACHE BOOL "Build FORTRAN support" FORCE)
            message (STATUS "HDF5 Fortran libs not found - disable build of Fortran examples")
          else ()
            if (HDF_BUILD_FORTRAN AND ${HDF5_BUILD_FORTRAN})
              if (BUILD_SHARED_LIBS AND HDF5_shared_Fortran_FOUND)
                set (H5EX_HDF5_LINK_LIBS ${H5EX_HDF5_LINK_LIBS} ${HDF5_FORTRAN_SHARED_LIBRARY})
              elseif (HDF5_static_Fortran_FOUND)
                set (H5EX_HDF5_LINK_LIBS ${H5EX_HDF5_LINK_LIBS} ${HDF5_FORTRAN_STATIC_LIBRARY})
              else ()
                set (HDF_BUILD_FORTRAN OFF CACHE BOOL "Build FORTRAN support" FORCE)
                message (STATUS "HDF5 Fortran libs not found - disable build of Fortran examples")
              endif ()
            endif ()
          endif ()
          if (HDF_BUILD_JAVA AND HDF5_Java_FOUND)
            if (${HDF5_BUILD_JAVA})
              set (CMAKE_JAVA_INCLUDE_PATH "${CMAKE_JAVA_INCLUDE_PATH};${HDF5_JAVA_INCLUDE_DIRS}")
              set (H5EX_JAVA_LIBRARY ${HDF5_JAVA_LIBRARY})
              set (H5EX_JAVA_LIBRARIES ${HDF5_JAVA_LIBRARY})
              message (STATUS "HDF5 lib:${H5EX_JAVA_LIBRARY} jars:${HDF5_JAVA_INCLUDE_DIRS}}")
            else ()
              set (HDF_BUILD_JAVA OFF CACHE BOOL "Build Java support" FORCE)
              message (STATUS "HDF5 Java libs not found - disable build of Java examples")
            endif ()
          else ()
            set (HDF_BUILD_JAVA OFF CACHE BOOL "Build Java support" FORCE)
          endif ()
        endif ()
      else ()
        find_package (HDF5) # Legacy find
        #Legacy find_package does not set HDF5_TOOLS_DIR, so we set it here
        set (HDF5_TOOLS_DIR ${HDF5_LIBRARY_DIRS}/../bin)
        #Legacy find_package does not set HDF5_BUILD_SHARED_LIBS, so we set it here
        if (USE_SHARED_LIBS AND EXISTS "${HDF5_LIBRARY_DIRS}/libhdf5.so")
          set (HDF5_BUILD_SHARED_LIBS 1)
        else ()
          set (HDF5_BUILD_SHARED_LIBS 0)
        endif ()
        set (H5EX_HDF5_LINK_LIBS ${H5EX_HDF5_LINK_LIBS} ${HDF5_LIBRARIES})
        add_executable (${HDF5_NAMESPACE}h5dump IMPORTED)
        set_property (TARGET ${HDF5_NAMESPACE}h5dump PROPERTY IMPORTED_LOCATION "${HDF5_TOOLS_DIR}/h5dump")
        set (H5EX_HDF5_DUMP_EXECUTABLE $<TARGET_FILE:${HDF5_NAMESPACE}h5dump>)
      endif ()

      set (HDF5_PACKAGE_NAME ${SEARCH_PACKAGE_NAME})

      if (HDF5_FOUND)
        set (H5EX_HDF5_INCLUDE_DIRS ${HDF5_INCLUDE_DIR})
        set (H5EX_HDF5_HAVE_H5PUBCONF_H 1)
        set (H5EX_HDF5_HAVE_HDF5 1)
        set (H5EX_HDF5_HEADER "h5pubconf.h")
        message (STATUS "HDF5-${HDF5_VERSION_STRING} found: INC=${HDF5_INCLUDE_DIR} TOOLS=${HDF5_TOOLS_DIR}")
      else ()
        message (FATAL_ERROR " HDF5 is Required for HDF5 Examples")
      endif ()
    else ()
      # This project is being called from within another and HDF5 is already configured
      set (H5EX_HDF5_HAVE_H5PUBCONF_H 1)
      set (H5EX_HDF5_HAVE_HDF5 1)
      message (STATUS "HDF5-${HDF5_VERSION_STRING} used")
    endif ()
    if (HDF_BUILD_FORTRAN)
     list (APPEND H5EX_HDF5_INCLUDE_DIRS ${HDF5_INCLUDE_DIR_FORTRAN})
    endif ()
  endif ()
  message (STATUS "HDF5 link libs: ${H5EX_HDF5_LINK_LIBS} Includes: ${H5EX_HDF5_INCLUDE_DIRS}")
endmacro ()

#-------------------------------------------------------------------------------
# Purpose:
# Breaking down three numbered versions (x.y.z) into their components, and
# returning a major and minor version (xy).
#
# Parameters:
#     version  [in]  The version string.
#     xyapi    [out] A "majorminor" API version.
#     
macro (APIVersion version xyapi)
  string (REGEX REPLACE "(\-[0-9]+)" "" xyz ${version})
  message (VERBOSE "version=${version}")

  string (REGEX REPLACE "([0-9]+).[0-9]+.[0-9]+" "\\1" major ${xyz})
  string (REGEX REPLACE "[0-9]+.([0-9]+).[0-9]+" "\\1" minor ${xyz})
  string (REGEX REPLACE "[0-9]+.[0-9]+.([0-9]+)" "\\1" patch ${xyz})
  message (VERBOSE "major=${major} minor=${minor}")

  # Round up to the next major release if minor is odd-numbered
  math (EXPR rem "${minor}%2")
  if (NOT ${rem} STREQUAL "0")
    math (EXPR minor "${minor} + 1")
  endif ()

  set (${xyapi} "${major}${minor}")

  #-----------------------------------------------------------------------------
  # Option to use 1.6.x API
  #-----------------------------------------------------------------------------
  option (${EXAMPLE_VARNAME}_USE_16_API "Use the HDF5 1.6.x API" OFF)
  if (${EXAMPLE_VARNAME}_USE_16_API AND ${xyapi} GREATER 16)
    set (${xyapi} "16")
  endif ()

  #-----------------------------------------------------------------------------
  # Option to use 1.8.x API
  #-----------------------------------------------------------------------------
  option (${EXAMPLE_VARNAME}_USE_18_API "Use the HDF5 1.8.x API" OFF)
  if (${EXAMPLE_VARNAME}_USE_18_API AND ${xyapi} GREATER 18)
    set (${xyapi} "18")
  endif ()

  #-----------------------------------------------------------------------------
  # Option to use 1.10.x API
  #-----------------------------------------------------------------------------
  option (${EXAMPLE_VARNAME}_USE_110_API "Use the HDF5 1.10.x API" OFF)
  if (${EXAMPLE_VARNAME}_USE_110_API AND ${xyapi} GREATER 110)
    set (${xyapi} "110")
  endif ()

  #-----------------------------------------------------------------------------
  # Option to use 1.12.x API
  #-----------------------------------------------------------------------------
  option (${EXAMPLE_VARNAME}_USE_112_API "Use the HDF5 1.12.x API" OFF)
  if (${EXAMPLE_VARNAME}_USE_112_API AND ${xyapi} GREATER 112)
    set (${xyapi} "112")
  endif ()

  #-----------------------------------------------------------------------------
  # Option to use 1.14.x API
  #-----------------------------------------------------------------------------
  option (${EXAMPLE_VARNAME}_USE_114_API "Use the HDF5 1.14.x API" OFF)
  if (${EXAMPLE_VARNAME}_USE_114_API AND ${xyapi} GREATER 114)
    set (${xyapi} "114")
  endif ()

  #-----------------------------------------------------------------------------
  # Option to use 1.16.x API
  #-----------------------------------------------------------------------------
  option (${EXAMPLE_VARNAME}_USE_116_API "Use the HDF5 1.16.x API" OFF)
  if (${EXAMPLE_VARNAME}_USE_116_API AND ${xyapi} GREATER 116)
    set (${xyapi} "116")
  endif ()
endmacro ()
