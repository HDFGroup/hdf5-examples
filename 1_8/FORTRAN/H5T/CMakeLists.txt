cmake_minimum_required (VERSION 2.8)
PROJECT (HDF5_FORTRAN_H5T C CXX Fortran)

#-----------------------------------------------------------------------------
# Define Sources
#-----------------------------------------------------------------------------
SET (f03examples
    h5ex_t_array
    h5ex_t_arrayatt
    h5ex_t_bit
    h5ex_t_bitatt
    h5ex_t_cmpd
    h5ex_t_cmpdatt
    h5ex_t_enum
    h5ex_t_enumatt
    h5ex_t_float
    h5ex_t_floatatt
    h5ex_t_int
    h5ex_t_intatt
    h5ex_t_objref
    h5ex_t_objrefatt
    h5ex_t_opaque
    h5ex_t_opaqueatt
    h5ex_t_regref
    h5ex_t_regrefatt
    h5ex_t_string
    h5ex_t_stringC
    h5ex_t_stringCatt
    h5ex_t_vlen
    h5ex_t_vlenatt
#    h5ex_t_vlstring
#    h5ex_t_vlstringatt
#    h5ex_t_cpxcmpd
#    h5ex_t_cpxcmpdatt
#    h5ex_t_commit
#    h5ex_t_convert
)
SET (examples
    h5ex_t_vlstring
#    h5ex_t_vlstringatt
#    h5ex_t_cpxcmpd
#    h5ex_t_cpxcmpdatt
#    h5ex_t_commit
#    h5ex_t_convert
)

IF (HDF5_ENABLE_F2003)
  FOREACH (example ${f03examples})
    ADD_EXECUTABLE (f90_${example} ${HDF5_FORTRAN_H5T_SOURCE_DIR}/${example}_F03.f90)
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
  ENDFOREACH (example ${f03examples})
ENDIF (HDF5_ENABLE_F2003)

FOREACH (example ${examples})
  ADD_EXECUTABLE (f90_${example} ${HDF5_FORTRAN_H5T_SOURCE_DIR}/${example}.f90)
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
            -P "${HDF5_RESOURCES_DIR}/runTest.cmake"
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
              -P "${HDF5_RESOURCES_DIR}/runTest.cmake"
      )
      SET_TESTS_PROPERTIES(H5DUMP-f90_${testname} PROPERTIES DEPENDS f90_${testname})
    ENDIF (HDF5_BUILD_TOOLS)
  ENDMACRO (ADD_H5_TEST)
  
  MACRO (ADD_H5_CMP_TEST testname)
    ADD_TEST (
        NAME f90_${testname}-clearall
        COMMAND    ${CMAKE_COMMAND}
            -E remove 
            ${testname}.out
            ${testname}.out.err
            ${testname}.h5
    )
    ADD_TEST (
        NAME f90_${testname}
        COMMAND "${CMAKE_COMMAND}"
            -D "TEST_PROGRAM=$<TARGET_FILE:f90_${testname}>"
            -D "TEST_ARGS:STRING=${ARGN}"
            -D "TEST_FOLDER=${PROJECT_BINARY_DIR}"
            -D "TEST_EXPECT=0"
            -D "TEST_OUTPUT=${testname}.out"
            -D "TEST_REFERENCE=${testname}.tst"
            -P "${HDF5_RESOURCES_DIR}/runTest.cmake"
    )
    SET_TESTS_PROPERTIES(f90_${testname} PROPERTIES DEPENDS f90_${testname}-clearall)
  ENDMACRO (ADD_H5_CMP_TEST)

  MACRO (TEST_EXAMPLE example)
    IF (${example} STREQUAL "h5ex_t_cpxcmpd" OR ${example} STREQUAL "h5ex_t_cpxcmpdatt")  
      SET (testdest "${PROJECT_BINARY_DIR}/${example}")
      #MESSAGE (STATUS " Copying ${example}.test")
      ADD_CUSTOM_COMMAND (
          TARGET     f90_${example}
          POST_BUILD
          COMMAND    ${XLATE_UTILITY}
          ARGS       ${HDF5_FORTRAN_H5T_SOURCE_DIR}/testfiles/${example}.tst ${testdest}.tst -l4
      )
      IF (HDF5_BUILD_TOOLS AND NOT ${example} STREQUAL "h5ex_t_convert")
        ADD_CUSTOM_COMMAND (
            TARGET     f90_${example}
            POST_BUILD
            COMMAND    ${XLATE_UTILITY}
            ARGS       ${HDF5_FORTRAN_H5T_SOURCE_DIR}/testfiles/${example}.ddl ${testdest}.ddl -l4
        )
      ENDIF (HDF5_BUILD_TOOLS AND NOT ${example} STREQUAL "h5ex_t_convert")
      ADD_H5_TEST (${example} -n)
    ELSEIF (${example} STREQUAL "h5ex_t_convert")  
      ADD_CUSTOM_COMMAND (
          TARGET     f90_${example}
          POST_BUILD
          COMMAND    ${XLATE_UTILITY}
          ARGS       ${HDF5_FORTRAN_H5T_SOURCE_DIR}/testfiles/${example}.tst ${PROJECT_BINARY_DIR}/${example}.tst -l4
      )
      ADD_H5_CMP_TEST (${example})
    ELSE (${example} STREQUAL "h5ex_t_cpxcmpd" OR ${example} STREQUAL "h5ex_t_cpxcmpdatt")  
      SET (testdest "${PROJECT_BINARY_DIR}/${example}")
      #MESSAGE (STATUS " Copying ${example}.test")
      ADD_CUSTOM_COMMAND (
          TARGET     f90_${example}
          POST_BUILD
          COMMAND    ${XLATE_UTILITY}
          ARGS       ${HDF5_FORTRAN_H5T_SOURCE_DIR}/testfiles/${example}.tst ${testdest}.tst -l4
      )
      IF (HDF5_BUILD_TOOLS AND NOT ${example} STREQUAL "h5ex_t_convert")
        ADD_CUSTOM_COMMAND (
            TARGET     f90_${example}
            POST_BUILD
            COMMAND    ${XLATE_UTILITY}
            ARGS       ${HDF5_FORTRAN_H5T_SOURCE_DIR}/testfiles/${example}.ddl ${testdest}.ddl -l4
        )
      ENDIF (HDF5_BUILD_TOOLS AND NOT ${example} STREQUAL "h5ex_t_convert")
      ADD_H5_TEST (${example})
    ENDIF (${example} STREQUAL "h5ex_t_cpxcmpd" OR ${example} STREQUAL "h5ex_t_cpxcmpdatt")  
  ENDMACRO (TEST_EXAMPLE)

  IF (HDF5_ENABLE_F2003)
    FOREACH (example ${f03examples})
      TEST_EXAMPLE (${example)
    ENDFOREACH (example ${f03examples})
  ENDIF (HDF5_ENABLE_F2003)
  
  FOREACH (example ${examples})
    TEST_EXAMPLE (${example)
  ENDFOREACH (example ${examples})
  
ENDIF (BUILD_TESTING)
  