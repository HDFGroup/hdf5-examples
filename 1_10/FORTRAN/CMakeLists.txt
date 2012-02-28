cmake_minimum_required (VERSION 2.8.6)
PROJECT (HDF5Examples_F90 C CXX Fortran)

#-----------------------------------------------------------------------------
# Build the Fortran Examples
#-----------------------------------------------------------------------------
ADD_SUBDIRECTORY (${PROJECT_SOURCE_DIR}/H5D ${PROJECT_BINARY_DIR}/H5D)
ADD_SUBDIRECTORY (${PROJECT_SOURCE_DIR}/H5G ${PROJECT_BINARY_DIR}/H5G)
ADD_SUBDIRECTORY (${PROJECT_SOURCE_DIR}/H5T ${PROJECT_BINARY_DIR}/H5T)
