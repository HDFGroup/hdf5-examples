cmake_minimum_required (VERSION 2.8.6)
PROJECT (HDF5_F90 C CXX Fortran)

#-----------------------------------------------------------------------------
# Build the Fortran Examples
#-----------------------------------------------------------------------------
ADD_SUBDIRECTORY (${HDF5_F90_SOURCE_DIR}/H5D ${HDF5_F90_BINARY_DIR}/H5D)
ADD_SUBDIRECTORY (${HDF5_F90_SOURCE_DIR}/H5G ${HDF5_F90_BINARY_DIR}/H5G)
#ADD_SUBDIRECTORY (${HDF5_F90_SOURCE_DIR}/H5T ${HDF5_F90_BINARY_DIR}/H5T)
