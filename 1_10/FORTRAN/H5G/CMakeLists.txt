cmake_minimum_required (VERSION 2.8.6)
PROJECT (HDF5_FORTRAN_H5G C CXX Fortran)

#-----------------------------------------------------------------------------
# Define Sources
#-----------------------------------------------------------------------------
SET (examples
    h5ex_g_compact
    h5ex_g_corder
    h5ex_g_create
    h5ex_g_phase
#    h5ex_g_iterate
#    h5ex_g_traverse
#    h5ex_g_intermediate
#    h5ex_g_visit
)

FOREACH (example ${examples})
  ADD_EXECUTABLE (f90_${example} ${HDF5_FORTRAN_H5G_SOURCE_DIR}/${example}.f90)
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
  MACRO (ADD_DUMP_TEST testname)
    ADD_TEST (
        NAME f90_${testname}-clearall
        COMMAND    ${CMAKE_COMMAND}
            -E remove 
            ${testname}.out
            ${testname}.out.err
            ${testname}.h5
    )
    ADD_TEST ( NAME f90_${testname} COMMAND $<TARGET_FILE:f90_${testname}>)
    SET_TESTS_PROPERTIES(f90_${testname} PROPERTIES DEPENDS f90_${testname}-clearall)
    IF (HDF5_BUILD_TOOLS)
      ADD_TEST (
          NAME H5DUMP-f90_${testname}
          COMMAND "${CMAKE_COMMAND}"
              -D "TEST_PROGRAM=$<TARGET_FILE:h5dump>"
              -D "TEST_ARGS:STRING=${ARGN};${testname}.h5"
              -D "TEST_FOLDER=${PROJECT_BINARY_DIR}"
              -D "TEST_OUTPUT=${testname}.out"
              -D "TEST_EXPECT=0"
              -D "TEST_REFERENCE=${testname}.ddl"
              -P "${HDF5_RESOURCES_DIR}/runTest.cmake"
      )
      SET_TESTS_PROPERTIES(H5DUMP-f90_${testname} PROPERTIES DEPENDS f90_${testname})
    ENDIF (HDF5_BUILD_TOOLS)
  ENDMACRO (ADD_DUMP_TEST)

  MACRO (ADD_H5_DUMP_TEST testname)
    ADD_TEST (
        NAME f90_${testname}-clearall
        COMMAND    ${CMAKE_COMMAND}
            -E remove 
            ${testname}.out
            ${testname}.out.err
            ${testname}.ddl.out
            ${testname}.ddl.out.err
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
  ENDMACRO (ADD_H5_DUMP_TEST)
  
  MACRO (ADD_H5_DUMP2_TEST testname)
    ADD_TEST (
        NAME f90_${testname}-clearall
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
    IF (${ARGN} STREQUAL "NULL")
      ADD_TEST (NAME f90_${testname} COMMAND $<TARGET_FILE:f90_${testname}>)
    ELSE (${ARGN} STREQUAL "NULL")
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
    ENDIF (${ARGN} STREQUAL "NULL")
    SET_TESTS_PROPERTIES(f90_${testname} PROPERTIES DEPENDS f90_${testname}-clearall)
    IF (HDF5_BUILD_TOOLS)
      ADD_TEST (
          NAME H5DUMP-f90_${testname}1
          COMMAND "${CMAKE_COMMAND}"
              -D "TEST_PROGRAM=$<TARGET_FILE:h5dump>"
              -D "TEST_ARGS:STRING=${testname}1.h5"
              -D "TEST_FOLDER=${PROJECT_BINARY_DIR}"
              -D "TEST_OUTPUT=${testname}1.ddl.out"
              -D "TEST_EXPECT=0"
              -D "TEST_REFERENCE=${testname}1.ddl"
              -P "${HDF5_RESOURCES_DIR}/runTest.cmake"
      )
      SET_TESTS_PROPERTIES(H5DUMP-f90_${testname}1 PROPERTIES DEPENDS f90_${testname})
      ADD_TEST (
          NAME H5DUMP-f90_${testname}2
          COMMAND "${CMAKE_COMMAND}"
              -D "TEST_PROGRAM=$<TARGET_FILE:h5dump>"
              -D "TEST_ARGS:STRING=${testname}2.h5"
              -D "TEST_FOLDER=${PROJECT_BINARY_DIR}"
              -D "TEST_OUTPUT=${testname}2.ddl.out"
              -D "TEST_EXPECT=0"
              -D "TEST_REFERENCE=${testname}2.ddl"
              -P "${HDF5_RESOURCES_DIR}/runTest.cmake"
      )
      SET_TESTS_PROPERTIES(H5DUMP-f90_${testname}2 PROPERTIES DEPENDS f90_${testname}1)
    ENDIF (HDF5_BUILD_TOOLS)
  ENDMACRO (ADD_H5_DUMP2_TEST)
  
  MACRO (ADD_H5_CMP_TEST testname)
    ADD_TEST (
        NAME f90_${testname}-clearall
        COMMAND    ${CMAKE_COMMAND}
            -E remove 
            ${testname}.out
            ${testname}.out.err
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
  ENDMACRO (ADD_H5_CMP_TEST testname)

  #MESSAGE (STATUS " Copying h5ex_g_compact.test")
  ADD_CUSTOM_COMMAND (
      TARGET     f90_h5ex_g_compact
      POST_BUILD
      COMMAND    ${XLATE_UTILITY}
      ARGS       ${HDF5_FORTRAN_H5G_SOURCE_DIR}/testfiles/h5ex_g_compact.tst ${PROJECT_BINARY_DIR}/h5ex_g_compact.tst -l4
  )
    
  IF (HDF5_BUILD_TOOLS)
    ADD_CUSTOM_COMMAND (
        TARGET     f90_h5ex_g_compact
        POST_BUILD
        COMMAND    ${XLATE_UTILITY}
        ARGS       ${HDF5_FORTRAN_H5G_SOURCE_DIR}/testfiles/h5ex_g_compact1.ddl ${PROJECT_BINARY_DIR}/h5ex_g_compact1.ddl -l4
    )
    ADD_CUSTOM_COMMAND (
        TARGET     f90_h5ex_g_compact
        POST_BUILD
        COMMAND    ${XLATE_UTILITY}
        ARGS       ${HDF5_FORTRAN_H5G_SOURCE_DIR}/testfiles/h5ex_g_compact2.ddl ${PROJECT_BINARY_DIR}/h5ex_g_compact2.ddl -l4
    )
    SET (exrefs
        h5ex_g_corder
        h5ex_g_create
        h5ex_g_phase
#        h5ex_g_iterate
#        h5ex_g_traverse
#        h5ex_g_intermediate
#        h5ex_g_visit
    )
    FOREACH (example ${exrefs})
      ADD_CUSTOM_COMMAND (
          TARGET     f90_${example}
          POST_BUILD
          COMMAND    ${XLATE_UTILITY}
          ARGS       ${HDF5_FORTRAN_H5G_SOURCE_DIR}/testfiles/${example}.tst ${PROJECT_BINARY_DIR}/${example}.tst -l4
      )
    ENDFOREACH (example ${exrefs})
      
#    SET (exfiles
#        h5ex_g_iterate
#        h5ex_g_traverse
#        h5ex_g_visit
#    )
#    FOREACH (example ${exfiles})
#      ADD_CUSTOM_COMMAND (
#          TARGET     f90_${example}
#          POST_BUILD
#          COMMAND    ${CMAKE_COMMAND}
#          ARGS       -E copy_if_different ${HDF5_FORTRAN_H5G_SOURCE_DIR}/testfiles/${example}.h5 ${PROJECT_BINARY_DIR}/${example}.h5
#      )
#    ENDFOREACH (example ${exfiles})

  ENDIF (HDF5_BUILD_TOOLS)

  ADD_H5_DUMP2_TEST (h5ex_g_compact NULL)
  ADD_DUMP_TEST (h5ex_g_create)
  ADD_H5_CMP_TEST (h5ex_g_corder)
  ADD_H5_CMP_TEST (h5ex_g_phase)
#  ADD_H5_CMP_TEST (h5ex_g_iterate)
#  ADD_H5_CMP_TEST (h5ex_g_traverse)
#  ADD_H5_CMP_TEST (h5ex_g_intermediate)
#  ADD_H5_CMP_TEST (h5ex_g_visit)

ENDIF (BUILD_TESTING)
  