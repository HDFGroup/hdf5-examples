#-----------------------------------------------------------------------------
# Define Sources, one file per application
#-----------------------------------------------------------------------------
set (examples
    h5ex_d_alloc.F90
    h5ex_d_checksum.F90
    h5ex_d_chunk.F90
    h5ex_d_compact.F90
    h5ex_d_extern.F90
    h5ex_d_fillval.F90
    h5ex_d_hyper.F90
#    h5ex_d_nbit.F90
    h5ex_d_rdwr.F90
#    h5ex_d_soint.F90
    h5ex_d_transform.F90
    h5ex_d_unlimmod.F90
#    h5ex_d_shuffle.F90
#    h5ex_d_sofloat.F90
#    h5ex_d_unlimadd.F90
#    h5ex_d_unlimgzip.F90
)
# uncomment if reference files added
#if (HDF5_ENABLE_Z_LIB_SUPPORT)
#  set (examples ${examples} h5ex_d_gzip.F90)
#endif ()
#if (HDF5_ENABLE_SZIP_SUPPORT)
#  set (examples ${examples} h5ex_d_szip.F90)
#endif ()