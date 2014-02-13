cmake_minimum_required (VERSION 2.8.10)
PROJECT (HDF5Examples_FORTRAN_H5D C CXX Fortran)
# --------------------------------------------------------------------
# Notes: When creating examples they should be prefixed
# with "f90_". This allows for easier filtering of the examples.
# --------------------------------------------------------------------

#-----------------------------------------------------------------------------
# Setup include Directories
#-----------------------------------------------------------------------------
LINK_DIRECTORIES (
    ${CMAKE_Fortran_MODULE_DIRECTORY}
    ${HDF5EX_F90_BINARY_DIR}
    ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
)

#-----------------------------------------------------------------------------
# Define Sources
#-----------------------------------------------------------------------------
SET (examples
    h5ex_d_alloc
    h5ex_d_checksum
    h5ex_d_chunk
    h5ex_d_compact
    h5ex_d_extern
    h5ex_d_fillval
    h5ex_d_gzip
    h5ex_d_hyper
#    h5ex_d_nbit
    h5ex_d_rdwr
#    h5ex_d_soint
#    h5ex_d_szip
    h5ex_d_transform
    h5ex_d_unlimmod
#    h5ex_d_shuffle
#    h5ex_d_sofloat
#    h5ex_d_unlimadd
#    h5ex_d_unlimgzip
)

FOREACH (example ${examples})
  ADD_EXECUTABLE (f90_${example} ${PROJECT_SOURCE_DIR}/${example}.f90)
  TARGET_NAMING (f90_${example} ${LIB_TYPE})
  TARGET_FORTRAN_WIN_PROPERTIES (f90_${example} "")
  IF (WIN32 AND NOT CYGWIN)
    SET_PROPERTY (TARGET f90_${example} 
        APPEND PROPERTY COMPILE_DEFINITIONS 
          HDF5F90_WINDOWS
    )
  ENDIF (WIN32 AND NOT CYGWIN)
  TARGET_LINK_LIBRARIES (f90_${example} ${LINK_LIBS})
  SET_TARGET_PROPERTIES (f90_${example} PROPERTIES LINKER_LANGUAGE Fortran)
ENDFOREACH (example ${examples})

IF (BUILD_TESTING)
  MACRO (ADD_H5_TEST testname)
    ADD_TEST (
        NAME f90_${testname}-clearall
        COMMAND    ${CMAKE_COMMAND}
            -E remove 
            ${testname}.out
            ${testname}.out.err
            ${testname}.ddl.out
            ${testname}.ddl.out.err
            ${testname}.h5
    )
    ADD_TEST (
        NAME f90_${testname}
        COMMAND "${CMAKE_COMMAND}"
            -D "TEST_PROGRAM=$<TARGET_FILE:f90_${testname}>"
            -D "TEST_ARGS:STRING="
            -D "TEST_FOLDER=${PROJECT_BINARY_DIR}"
            -D "TEST_EXPECT=0"
            -D "TEST_OUTPUT=${testname}.out"
            -D "TEST_REFERENCE=${testname}.tst"
            -P "${HDF5EX_RESOURCES_DIR}/runTest.cmake"
    )
    SET_TESTS_PROPERTIES(f90_${testname} PROPERTIES DEPENDS f90_${testname}-clearall)
    IF (HDF5_BUILD_TOOLS)
      ADD_TEST (
          NAME H5DUMP-f90_${testname}
          COMMAND "${CMAKE_COMMAND}"
              -D "TEST_PROGRAM=$<TARGET_FILE:h5dump>"
              -D "TEST_ARGS:STRING=${ARGN};${testname}.h5"
              -D "TEST_FOLDER=${PROJECT_BINARY_DIR}"
              -D "TEST_OUTPUT=${testname}.ddl.out"
              -D "TEST_EXPECT=0"
              -D "TEST_REFERENCE=${testname}.ddl"
              -P "${HDF5EX_RESOURCES_DIR}/runTest.cmake"
      )
      SET_TESTS_PROPERTIES(H5DUMP-f90_${testname} PROPERTIES DEPENDS f90_${testname})
    ENDIF (HDF5_BUILD_TOOLS)
  ENDMACRO (ADD_H5_TEST)

  FOREACH (example ${examples})
    SET (testdest "${PROJECT_BINARY_DIR}/${example}")
    #MESSAGE (STATUS " Copying ${example}.test")
    ADD_CUSTOM_COMMAND (
        TARGET     f90_${example}
        POST_BUILD
        COMMAND    ${XLATE_UTILITY}
        ARGS       ${PROJECT_SOURCE_DIR}/testfiles/${example}.tst ${testdest}.tst -l4
    )
    IF (HDF5_BUILD_TOOLS)
      ADD_CUSTOM_COMMAND (
          TARGET     f90_${example}
          POST_BUILD
          COMMAND    ${XLATE_UTILITY}
          ARGS       ${PROJECT_SOURCE_DIR}/testfiles/${example}.ddl ${testdest}.ddl -l4
      )
    ENDIF (HDF5_BUILD_TOOLS)
    
    IF (${example} STREQUAL "h5ex_d_transform")  
      ADD_H5_TEST (${example} -n)
    ELSE (${example} STREQUAL "h5ex_d_transform")  
      ADD_H5_TEST (${example})
    ENDIF (${example} STREQUAL "h5ex_d_transform")  
  ENDFOREACH (example ${examples})
ENDIF (BUILD_TESTING)
  