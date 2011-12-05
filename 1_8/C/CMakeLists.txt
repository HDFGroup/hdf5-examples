cmake_minimum_required (VERSION 2.8.6)
PROJECT (HDF5_C)

#-----------------------------------------------------------------------------
# Shared/Static Libs
#-----------------------------------------------------------------------------
IF (USE_SHARED_LIBS)
  SET (C_BUILT_AS_DYNAMIC_LIB 1)
ELSE (USE_SHARED_LIBS)
  SET (C_BUILT_AS_STATIC_LIB 1)
ENDIF (USE_SHARED_LIBS)

#-----------------------------------------------------------------------------
# Build the C Examples
#-----------------------------------------------------------------------------
ADD_SUBDIRECTORY (${HDF5_C_SOURCE_DIR}/H5D ${HDF5_C_BINARY_DIR}/H5D)
ADD_SUBDIRECTORY (${HDF5_C_SOURCE_DIR}/H5G ${HDF5_C_BINARY_DIR}/H5G)
ADD_SUBDIRECTORY (${HDF5_C_SOURCE_DIR}/H5T ${HDF5_C_BINARY_DIR}/H5T)
#ADD_SUBDIRECTORY (${HDF5_C_SOURCE_DIR}/Performance ${HDF5_C_BINARY_DIR}/Performance)
