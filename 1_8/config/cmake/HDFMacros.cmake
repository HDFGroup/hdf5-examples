#-------------------------------------------------------------------------------
macro (SET_GLOBAL_VARIABLE name value)
  set (${name} ${value} CACHE INTERNAL "Used to pass variables between directories" FORCE)
endmacro (SET_GLOBAL_VARIABLE)

#-------------------------------------------------------------------------------
macro (IDE_GENERATED_PROPERTIES SOURCE_PATH HEADERS SOURCES)
  #set(source_group_path "Source/AIM/${NAME}")
  string (REPLACE "/" "\\\\" source_group_path ${SOURCE_PATH})
  source_group (${source_group_path} FILES ${HEADERS} ${SOURCES})

  #-- The following is needed if we ever start to use OS X Frameworks but only
  #--  works on CMake 2.6 and greater
  #set_property (SOURCE ${HEADERS}
  #       PROPERTY MACOSX_PACKAGE_LOCATION Headers/${NAME}
  #)
endmacro (IDE_GENERATED_PROPERTIES)

#-------------------------------------------------------------------------------
macro (IDE_SOURCE_PROPERTIES SOURCE_PATH HEADERS SOURCES)
  #  INSTALL (FILES ${HEADERS}
  #       DESTINATION include/R3D/${NAME}
  #       COMPONENT Headers       
  #  )

  string (REPLACE "/" "\\\\" source_group_path ${SOURCE_PATH}  )
  source_group (${source_group_path} FILES ${HEADERS} ${SOURCES})

  #-- The following is needed if we ever start to use OS X Frameworks but only
  #--  works on CMake 2.6 and greater
  #set_property (SOURCE ${HEADERS}
  #       PROPERTY MACOSX_PACKAGE_LOCATION Headers/${NAME}
  #)
endmacro (IDE_SOURCE_PROPERTIES)

#-------------------------------------------------------------------------------
macro (TARGET_NAMING target libtype)
  if (WIN32 AND NOT MINGW)
    if (${libtype} MATCHES "SHARED")
      if (HDF_LEGACY_NAMING)
        set_target_properties (${target} PROPERTIES OUTPUT_NAME "dll")
        set_target_properties (${target} PROPERTIES PREFIX "${target}")
      else (HDF_LEGACY_NAMING)
        set_target_properties (${target} PROPERTIES OUTPUT_NAME "${target}dll")
      endif (HDF_LEGACY_NAMING)
    endif (${libtype} MATCHES "SHARED")
  endif (WIN32 AND NOT MINGW)
endmacro (TARGET_NAMING)

#-------------------------------------------------------------------------------
macro (HDF_SET_LIB_OPTIONS libtarget libname libtype)
  # message (STATUS "${libname} libtype: ${libtype}")
  if (${libtype} MATCHES "SHARED")
    if (WIN32 AND NOT MINGW)
      if (HDF_LEGACY_NAMING)
        set (LIB_RELEASE_NAME "${libname}dll")
        set (LIB_DEBUG_NAME "${libname}ddll")
      else (HDF_LEGACY_NAMING)
        set (LIB_RELEASE_NAME "${libname}")
        set (LIB_DEBUG_NAME "${libname}_D")
      endif (HDF_LEGACY_NAMING)
    else (WIN32 AND NOT MINGW)
      set (LIB_RELEASE_NAME "${libname}")
      set (LIB_DEBUG_NAME "${libname}_debug")
    endif (WIN32 AND NOT MINGW)
  else (${libtype} MATCHES "SHARED")
    if (WIN32 AND NOT MINGW)
      if (HDF_LEGACY_NAMING)
        set (LIB_RELEASE_NAME "${libname}")
        set (LIB_DEBUG_NAME "${libname}d")
      else (HDF_LEGACY_NAMING)
        set (LIB_RELEASE_NAME "lib${libname}")
        set (LIB_DEBUG_NAME "lib${libname}_D")
      endif (HDF_LEGACY_NAMING)
    else (WIN32 AND NOT MINGW)
      # if the generator supports configuration types or if the CMAKE_BUILD_TYPE has a value
      if (CMAKE_CONFIGURATION_TYPES OR CMAKE_BUILD_TYPE)
        set (LIB_RELEASE_NAME "${libname}")
        set (LIB_DEBUG_NAME "${libname}_debug")
      else (CMAKE_CONFIGURATION_TYPES OR CMAKE_BUILD_TYPE)
        set (LIB_RELEASE_NAME "lib${libname}")
        set (LIB_DEBUG_NAME "lib${libname}_debug")
      endif (CMAKE_CONFIGURATION_TYPES OR CMAKE_BUILD_TYPE)
    endif (WIN32 AND NOT MINGW)
  endif (${libtype} MATCHES "SHARED")
  
  set_target_properties (${libtarget}
      PROPERTIES
      DEBUG_OUTPUT_NAME          ${LIB_DEBUG_NAME}
      RELEASE_OUTPUT_NAME        ${LIB_RELEASE_NAME}
      MINSIZEREL_OUTPUT_NAME     ${LIB_RELEASE_NAME}
      RELWITHDEBINFO_OUTPUT_NAME ${LIB_RELEASE_NAME}
  )
  
  #----- Use MSVC Naming conventions for Shared Libraries
  if (MINGW AND ${libtype} MATCHES "SHARED")
    set_target_properties (${libtarget}
        PROPERTIES
        IMPORT_SUFFIX ".lib"
        IMPORT_PREFIX ""
        PREFIX ""
    )
  endif (MINGW AND ${libtype} MATCHES "SHARED")

endmacro (HDF_SET_LIB_OPTIONS)

#-------------------------------------------------------------------------------
macro (TARGET_FORTRAN_WIN_PROPERTIES target addlinkflags)
  if (WIN32 AND MSVC)
    if (BUILD_SHARED_LIBS)
      set_target_properties (${target}
          PROPERTIES
              COMPILE_FLAGS "/dll"
              LINK_FLAGS "/SUBSYSTEM:CONSOLE ${addlinkflags}"
      ) 
    else (BUILD_SHARED_LIBS)
      set_target_properties (${target}
          PROPERTIES
              COMPILE_FLAGS "/MD"
              LINK_FLAGS "/SUBSYSTEM:CONSOLE ${addlinkflags}"
      ) 
    endif (BUILD_SHARED_LIBS)
  endif (WIN32 AND MSVC)
endmacro (TARGET_FORTRAN_WIN_PROPERTIES)
