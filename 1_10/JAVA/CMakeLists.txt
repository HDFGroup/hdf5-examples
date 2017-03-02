cmake_minimum_required (VERSION 3.2.2)
project (HDFJAVAExamples_NATIVE Java)

set (CMAKE_VERBOSE_MAKEFILE 1)

INCLUDE_DIRECTORIES (
    ${HDFJAVA_LIB_DIR}
    ${JAVA_INCLUDE_PATH}
    ${JAVA_INCLUDE_PATH2}
)

set (HDF_JAVA_EXAMPLES
    HDF5FileCreate
    HDF5GroupCreate
    HDF5DatasetCreate
    HDF5AttributeCreate
    HDF5DatasetRead
    HDF5FileStructure
    HDF5SubsetSelect
)

if (WIN32 AND NOT CYGWIN)
  set (CMAKE_JAVA_INCLUDE_FLAG_SEP ";")
else (WIN32 AND NOT CYGWIN)
  set (CMAKE_JAVA_INCLUDE_FLAG_SEP ":")
endif (WIN32 AND NOT CYGWIN)

set (CMAKE_JAVA_CLASSPATH ".")
foreach (CMAKE_INCLUDE_PATH ${CMAKE_JAVA_INCLUDE_PATH})
  set (CMAKE_JAVA_CLASSPATH "${CMAKE_JAVA_CLASSPATH}${CMAKE_JAVA_INCLUDE_FLAG_SEP}${CMAKE_INCLUDE_PATH}")
endforeach (CMAKE_INCLUDE_PATH)

foreach (HCP_JAR ${CMAKE_JAVA_INCLUDE_PATH})
  get_filename_component (_HCP_FILE ${HCP_JAR} NAME)
  set (HDFJAVA_CLASSJARS "${_HCP_FILE} ${HDFJAVA_CLASSJARS}")
endforeach (HCP_JAR ${CMAKE_JAVA_INCLUDE_PATH})

foreach (example ${HDF_JAVA_EXAMPLES})
  file (WRITE ${PROJECT_BINARY_DIR}/Manifest.txt
  "Main-Class: ${example}
Class-Path: ${HDFJAVA_CLASSJARS}
"
  )
  ADD_JAR (${example} SOURCES ${example}.java MANIFEST ${PROJECT_BINARY_DIR}/Manifest.txt)
  get_target_property (${example}_JAR_FILE ${example} JAR_FILE)
endforeach (example ${HDF_JAVA_EXAMPLES})

if (BUILD_TESTING)
  macro (ADD_H5_TEST resultfile resultcode)
    add_test (
        NAME jnative-h5-${resultfile}
        COMMAND "${CMAKE_COMMAND}"
            -D "TEST_TESTER=${CMAKE_Java_RUNTIME}"
            -D "TEST_PROGRAM=${resultfile}"
            -D "TEST_ARGS:STRING=${ARGN}"
            -D "TEST_CLASSPATH:STRING=${CMAKE_JAVA_CLASSPATH}${CMAKE_JAVA_INCLUDE_FLAG_SEP}${${resultfile}_JAR_FILE}"
            -D "TEST_LIBRARY_DIRECTORY=${HDF5_JAVA_LIBRARIES}"
            -D "TEST_FOLDER=${HDFJAVAExamples_NATIVE_BINARY_DIR}"
            -D "TEST_OUTPUT=${HDFJAVAExamples_NATIVE_BINARY_DIR}/${resultfile}.out"
            -D "TEST_REFERENCE=${resultfile}.txt"
            -D "TEST_EXPECT=${resultcode}"
            -D "TEST_SKIP_COMPARE=TRUE"
            -P "${HDF5EX_RESOURCES_DIR}/jrunTest.cmake"
    )
    if (NOT "${last_test}" STREQUAL "")
      set_tests_properties (jnative-h5-${resultfile} PROPERTIES DEPENDS ${last_test})
    endif (NOT "${last_test}" STREQUAL "")
    set (last_test "jnative-h5-${resultfile}")
  endmacro (ADD_H5_TEST file)

  foreach (example ${HDF_JAVA_EXAMPLES})
    add_test (
        NAME jnative-h5-${example}-clearall-objects
        COMMAND    ${CMAKE_COMMAND}
            -E remove
            ${HDFJAVAExamples_NATIVE_BINARY_DIR}/${example}.h5
            ${example}.out
            ${example}.out.err
    )
    if (NOT "${last_test}" STREQUAL "")
      set_tests_properties (jnative-h5-${example}-clearall-objects PROPERTIES DEPENDS ${last_test})
    endif (NOT "${last_test}" STREQUAL "")
    add_test (
        NAME jnative-h5-${example}-copy-objects
        COMMAND    ${CMAKE_COMMAND}
            -E copy_if_different
            ${HDFJAVAExamples_NATIVE_SOURCE_DIR}/testfiles/${example}.txt
            ${HDFJAVAExamples_NATIVE_BINARY_DIR}/${example}.txt
    )
    set_tests_properties (jnative-h5-${example}-copy-objects PROPERTIES DEPENDS jnative-h5-${example}-clearall-objects)
    set (last_test "jnative-h5-${example}-copy-objects")
    ADD_H5_TEST (${example} 0)
  endforeach (example ${HDF_JAVA_EXAMPLES})

endif (BUILD_TESTING)
