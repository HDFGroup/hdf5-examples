cmake_minimum_required (VERSION 2.8)
PROJECT (HDF5_C_H5T)

#-----------------------------------------------------------------------------
# Define Sources
#-----------------------------------------------------------------------------
SET (examples
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
    h5ex_t_stringatt
    h5ex_t_vlen
    h5ex_t_vlenatt
    h5ex_t_vlstring
    h5ex_t_vlstringatt
    h5ex_t_cpxcmpd
    h5ex_t_cpxcmpdatt
    h5ex_t_commit
    h5ex_t_convert
)

FOREACH (example ${examples})
  ADD_EXECUTABLE (${example} ${HDF5_C_H5T_SOURCE_DIR}/${example}.c)
  TARGET_NAMING (${example} ${LIB_TYPE})
  TARGET_LINK_LIBRARIES (${example} ${HDF5_LIB_TARGET})
ENDFOREACH (example ${examples})

IF (BUILD_TESTING)
  MACRO (ADD_H5_TEST testname)
    ADD_TEST (
        NAME ${testname}-clearall
        COMMAND    ${CMAKE_COMMAND}
            -E remove 
            ${testname}.out
            ${testname}.out.err
            ${testname}.dmp.out
            ${testname}.dmp.out.err
            ${testname}.out.tmp
            ${testname}.h5
    )
    ADD_TEST (
        NAME ${testname}
        COMMAND "${CMAKE_COMMAND}"
            -D "TEST_PROGRAM=$<TARGET_FILE:${testname}>"
            -D "TEST_ARGS:STRING="
            -D "TEST_FOLDER=${PROJECT_BINARY_DIR}"
            -D "TEST_EXPECT=0"
            -D "TEST_OUTPUT=${testname}.out"
            -D "TEST_REFERENCE=${testname}.tst"
            -P "${HDF5_RESOURCES_DIR}/runTest.cmake"
    )
    SET_TESTS_PROPERTIES(${testname} PROPERTIES DEPENDS ${testname}-clearall)
    IF (HDF5_BUILD_TOOLS)
      ADD_TEST (
          NAME H5DUMP-${testname}
          COMMAND "${CMAKE_COMMAND}"
              -D "TEST_PROGRAM=$<TARGET_FILE:h5dump>"
              -D "TEST_ARGS:STRING=${ARGN};${testname}.h5"
              -D "TEST_FOLDER=${PROJECT_BINARY_DIR}"
              -D "TEST_OUTPUT=${testname}.dmp.out"
              -D "TEST_EXPECT=0"
              -D "TEST_REFERENCE=${testname}.dmp"
              -P "${HDF5_RESOURCES_DIR}/runTest.cmake"
      )
      SET_TESTS_PROPERTIES(H5DUMP-${testname} PROPERTIES DEPENDS ${testname})
    ENDIF (HDF5_BUILD_TOOLS)
  ENDMACRO (ADD_H5_TEST)
  
  MACRO (ADD_H5_CMP_TEST testname)
    ADD_TEST (
        NAME ${testname}-clearall
        COMMAND    ${CMAKE_COMMAND}
            -E remove 
            ${testname}.out
            ${testname}.out.err
            ${testname}.h5
    )
    ADD_TEST (
        NAME ${testname}
        COMMAND "${CMAKE_COMMAND}"
            -D "TEST_PROGRAM=$<TARGET_FILE:${testname}>"
            -D "TEST_ARGS:STRING=${ARGN}"
            -D "TEST_FOLDER=${PROJECT_BINARY_DIR}"
            -D "TEST_EXPECT=0"
            -D "TEST_OUTPUT=${testname}.out"
            -D "TEST_REFERENCE=${testname}.test"
            -P "${HDF5_RESOURCES_DIR}/runTest.cmake"
    )
    SET_TESTS_PROPERTIES(${testname} PROPERTIES DEPENDS ${testname}-clearall)
  ENDMACRO (ADD_H5_CMP_TEST)

  FOREACH (example ${examples})
    IF (${example} STREQUAL "h5ex_t_cpxcmpd" OR ${example} STREQUAL "h5ex_t_cpxcmpdatt")  
      SET (testdest "${PROJECT_BINARY_DIR}/${example}")
      #MESSAGE (STATUS " Copying ${example}.test")
      ADD_CUSTOM_COMMAND (
          TARGET     ${example}
          POST_BUILD
          COMMAND    ${XLATE_UTILITY}
          ARGS       ${HDF5_C_H5T_SOURCE_DIR}/${example}.tst ${testdest}.tst -l4
      )
      IF (HDF5_BUILD_TOOLS AND NOT ${example} STREQUAL "h5ex_t_convert")
        ADD_CUSTOM_COMMAND (
            TARGET     ${example}
            POST_BUILD
            COMMAND    ${XLATE_UTILITY}
            ARGS       ${HDF5_C_H5T_SOURCE_DIR}/${example}.dmp ${testdest}.dmp -l4
        )
      ENDIF (HDF5_BUILD_TOOLS AND NOT ${example} STREQUAL "h5ex_t_convert")
      ADD_H5_TEST (${example} -n)
    ELSEIF (${example} STREQUAL "h5ex_t_convert")  
      ADD_CUSTOM_COMMAND (
          TARGET     ${example}
          POST_BUILD
          COMMAND    ${XLATE_UTILITY}
          ARGS       ${HDF5_C_H5T_SOURCE_DIR}/${example}.test ${PROJECT_BINARY_DIR}/${example}.test -l4
      )
      ADD_H5_CMP_TEST (${example})
    ELSE (${example} STREQUAL "h5ex_t_cpxcmpd" OR ${example} STREQUAL "h5ex_t_cpxcmpdatt")  
      SET (testdest "${PROJECT_BINARY_DIR}/${example}")
      #MESSAGE (STATUS " Copying ${example}.test")
      ADD_CUSTOM_COMMAND (
          TARGET     ${example}
          POST_BUILD
          COMMAND    ${XLATE_UTILITY}
          ARGS       ${HDF5_C_H5T_SOURCE_DIR}/${example}.tst ${testdest}.tst -l4
      )
      IF (HDF5_BUILD_TOOLS AND NOT ${example} STREQUAL "h5ex_t_convert")
        ADD_CUSTOM_COMMAND (
            TARGET     ${example}
            POST_BUILD
            COMMAND    ${XLATE_UTILITY}
            ARGS       ${HDF5_C_H5T_SOURCE_DIR}/${example}.dmp ${testdest}.dmp -l4
        )
      ENDIF (HDF5_BUILD_TOOLS AND NOT ${example} STREQUAL "h5ex_t_convert")
      ADD_H5_TEST (${example})
    ENDIF (${example} STREQUAL "h5ex_t_cpxcmpd" OR ${example} STREQUAL "h5ex_t_cpxcmpdatt")  
  ENDFOREACH (example ${examples})
ENDIF (BUILD_TESTING)
  