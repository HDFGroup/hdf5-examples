cmake_minimum_required (VERSION 2.8)
PROJECT (HDF5_C_H5G)

#-----------------------------------------------------------------------------
# Define Sources
#-----------------------------------------------------------------------------
SET (examples
    h5ex_g_compact
    h5ex_g_corder
    h5ex_g_create
    h5ex_g_phase
    h5ex_g_iterate
    h5ex_g_traverse
    h5ex_g_intermediate
    h5ex_g_visit
)

FOREACH (example ${examples})
  ADD_EXECUTABLE (${example} ${HDF5_C_H5G_SOURCE_DIR}/${example}.c)
  TARGET_NAMING (${example} ${LIB_TYPE})
  TARGET_LINK_LIBRARIES (${example} ${HDF5_LIB_TARGET})
ENDFOREACH (example ${examples})

IF (BUILD_TESTING)
  MACRO (ADD_DUMP_TEST testname)
    ADD_TEST (
        NAME ${testname}-clearall
        COMMAND    ${CMAKE_COMMAND}
            -E remove 
            ${testname}.out
            ${testname}.out.err
            ${testname}.h5
    )
    ADD_TEST ( NAME ${testname} COMMAND $<TARGET_FILE:${testname}>)
    SET_TESTS_PROPERTIES(${testname} PROPERTIES DEPENDS ${testname}-clearall)
    IF (HDF5_BUILD_TOOLS)
      ADD_TEST (
          NAME H5DUMP-${testname}
          COMMAND "${CMAKE_COMMAND}"
              -D "TEST_PROGRAM=$<TARGET_FILE:h5dump>"
              -D "TEST_ARGS:STRING=${ARGN};${testname}.h5"
              -D "TEST_FOLDER=${PROJECT_BINARY_DIR}"
              -D "TEST_OUTPUT=${testname}.out"
              -D "TEST_EXPECT=0"
              -D "TEST_REFERENCE=${testname}.tst"
              -P "${HDF5_RESOURCES_DIR}/runTest.cmake"
      )
      SET_TESTS_PROPERTIES(H5DUMP-${testname} PROPERTIES DEPENDS ${testname})
    ENDIF (HDF5_BUILD_TOOLS)
  ENDMACRO (ADD_DUMP_TEST)

  MACRO (ADD_H5_DUMP_TEST testname)
    ADD_TEST (
        NAME ${testname}-clearall
        COMMAND    ${CMAKE_COMMAND}
            -E remove 
            ${testname}.out
            ${testname}.out.err
            ${testname}.ddl.out
            ${testname}.ddl.out.err
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
              -D "TEST_OUTPUT=${testname}.ddl.out"
              -D "TEST_EXPECT=0"
              -D "TEST_REFERENCE=${testname}.ddl"
              -P "${HDF5_RESOURCES_DIR}/runTest.cmake"
      )
      SET_TESTS_PROPERTIES(H5DUMP-${testname} PROPERTIES DEPENDS ${testname})
    ENDIF (HDF5_BUILD_TOOLS)
  ENDMACRO (ADD_H5_DUMP_TEST)
  
  MACRO (ADD_H5_DUMP2_TEST testname)
    ADD_TEST (
        NAME ${testname}-clearall
        COMMAND    ${CMAKE_COMMAND}
            -E remove 
            ${testname}.out
            ${testname}.out.err
            ${testname}1.ddl.out
            ${testname}1.ddl.out.err
            ${testname}1.h5
            ${testname}2.ddl.out
            ${testname}2.ddl.out.err
            ${testname}2.h5
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
          NAME H5DUMP-${testname}1
          COMMAND "${CMAKE_COMMAND}"
              -D "TEST_PROGRAM=$<TARGET_FILE:h5dump>"
              -D "TEST_ARGS:STRING=${testname}1.h5"
              -D "TEST_FOLDER=${PROJECT_BINARY_DIR}"
              -D "TEST_OUTPUT=${testname}1.ddl.out"
              -D "TEST_EXPECT=0"
              -D "TEST_REFERENCE=${testname}1.ddl"
              -P "${HDF5_RESOURCES_DIR}/runTest.cmake"
      )
      SET_TESTS_PROPERTIES(H5DUMP-${testname}1 PROPERTIES DEPENDS ${testname})
      ADD_TEST (
          NAME H5DUMP-${testname}2
          COMMAND "${CMAKE_COMMAND}"
              -D "TEST_PROGRAM=$<TARGET_FILE:h5dump>"
              -D "TEST_ARGS:STRING=${testname}2.h5"
              -D "TEST_FOLDER=${PROJECT_BINARY_DIR}"
              -D "TEST_OUTPUT=${testname}2.ddl.out"
              -D "TEST_EXPECT=0"
              -D "TEST_REFERENCE=${testname}2.ddl"
              -P "${HDF5_RESOURCES_DIR}/runTest.cmake"
      )
      SET_TESTS_PROPERTIES(H5DUMP-${testname}2 PROPERTIES DEPENDS ${testname}1)
    ENDIF (HDF5_BUILD_TOOLS)
  ENDMACRO (ADD_H5_DUMP2_TEST)
  
  MACRO (ADD_H5_CMP_TEST testname)
    ADD_TEST (
        NAME ${testname}-clearall
        COMMAND    ${CMAKE_COMMAND}
            -E remove 
            ${testname}.out
            ${testname}.out.tmp
            ${testname}.out.err
    )
    ADD_TEST (
        NAME ${testname}
        COMMAND "${CMAKE_COMMAND}"
            -D "TEST_PROGRAM=$<TARGET_FILE:${testname}>"
            -D "TEST_ARGS:STRING=${ARGN}"
            -D "TEST_FOLDER=${PROJECT_BINARY_DIR}"
            -D "TEST_EXPECT=0"
            -D "TEST_OUTPUT=${testname}.out"
            -D "TEST_REFERENCE=${testname}.tst"
            -P "${HDF5_RESOURCES_DIR}/runTest.cmake"
    )
    SET_TESTS_PROPERTIES(${testname} PROPERTIES DEPENDS ${testname}-clearall)
  ENDMACRO (ADD_H5_CMP_TEST testname)

  #MESSAGE (STATUS " Copying h5ex_g_compact.test")
  ADD_CUSTOM_COMMAND (
      TARGET     h5ex_g_compact
      POST_BUILD
      COMMAND    ${XLATE_UTILITY}
      ARGS       ${HDF5_C_H5G_SOURCE_DIR}/testfiles/h5ex_g_compact.tst ${PROJECT_BINARY_DIR}/h5ex_g_compact.tst -l4
  )
    
  IF (HDF5_BUILD_TOOLS)
    ADD_CUSTOM_COMMAND (
        TARGET     h5ex_g_compact
        POST_BUILD
        COMMAND    ${XLATE_UTILITY}
        ARGS       ${HDF5_C_H5G_SOURCE_DIR}/testfiles/h5ex_g_compact1.ddl ${PROJECT_BINARY_DIR}/h5ex_g_compact1.ddl -l4
    )
    ADD_CUSTOM_COMMAND (
        TARGET     h5ex_g_compact
        POST_BUILD
        COMMAND    ${XLATE_UTILITY}
        ARGS       ${HDF5_C_H5G_SOURCE_DIR}/testfiles/h5ex_g_compact2.ddl ${PROJECT_BINARY_DIR}/h5ex_g_compact2.ddl -l4
    )
    SET (exrefs
        h5ex_g_corder
        h5ex_g_create
        h5ex_g_phase
        h5ex_g_iterate
        h5ex_g_traverse
        h5ex_g_intermediate
        h5ex_g_visit
    )
    FOREACH (example ${exrefs})
      ADD_CUSTOM_COMMAND (
          TARGET     ${example}
          POST_BUILD
          COMMAND    ${XLATE_UTILITY}
          ARGS       ${HDF5_C_H5G_SOURCE_DIR}/testfiles/${example}.tst ${PROJECT_BINARY_DIR}/${example}.tst -l4
      )
    ENDFOREACH (example ${exrefs})
      
    SET (exfiles
        h5ex_g_iterate
        h5ex_g_traverse
        h5ex_g_visit
    )
    FOREACH (example ${exfiles})
      ADD_CUSTOM_COMMAND (
          TARGET     ${example}
          POST_BUILD
          COMMAND    ${CMAKE_COMMAND}
          ARGS       -E copy_if_different ${HDF5_C_H5G_SOURCE_DIR}/${example}.h5 ${PROJECT_BINARY_DIR}/${example}.h5
      )
    ENDFOREACH (example ${exfiles})

  ENDIF (HDF5_BUILD_TOOLS)

  ADD_H5_DUMP2_TEST (h5ex_g_compact)
  ADD_DUMP_TEST (h5ex_g_create)
  ADD_H5_CMP_TEST (h5ex_g_corder)
  ADD_H5_CMP_TEST (h5ex_g_phase)
  ADD_H5_CMP_TEST (h5ex_g_iterate)
  ADD_H5_CMP_TEST (h5ex_g_traverse)
  ADD_H5_CMP_TEST (h5ex_g_intermediate)
  ADD_H5_CMP_TEST (h5ex_g_visit)

ENDIF (BUILD_TESTING)
  