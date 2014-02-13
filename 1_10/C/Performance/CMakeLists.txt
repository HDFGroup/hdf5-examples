cmake_minimum_required (VERSION 2.8.10)
PROJECT (HDF5Examples_C_PERFORM)

#-----------------------------------------------------------------------------
# Define Sources
#-----------------------------------------------------------------------------
SET (examples
    h5slabread
    h5slabwrite
    h5efc
)

FOREACH (example ${examples})
  ADD_EXECUTABLE (${example} ${PROJECT_SOURCE_DIR}/${example}.c)
  TARGET_NAMING (${example} ${LIB_TYPE})
  TARGET_LINK_LIBRARIES (${example} ${LINK_LIBS})
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
            -P "${HDF5EX_RESOURCES_DIR}/runTest.cmake"
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
              -P "${HDF5EX_RESOURCES_DIR}/runTest.cmake"
      )
      SET_TESTS_PROPERTIES(H5DUMP-${testname} PROPERTIES DEPENDS ${testname})
    ENDIF (HDF5_BUILD_TOOLS)
  ENDMACRO (ADD_H5_TEST)

  FOREACH (example ${examples})
    SET (testdest "${PROJECT_BINARY_DIR}/${example}.test")
    #MESSAGE (STATUS " Copying ${example}.test")
    ADD_CUSTOM_COMMAND (
        TARGET     ${example}
        POST_BUILD
        COMMAND    ${CMAKE_COMMAND}
        ARGS       -E copy_if_different ${PROJECT_SOURCE_DIR}/${example}.test ${testdest}
    )
    ADD_H5_TEST (${example})
  ENDFOREACH (example ${examples})
ENDIF (BUILD_TESTING)
  