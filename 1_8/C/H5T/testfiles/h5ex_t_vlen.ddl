**********************
*  Output of h5dump  *
**********************

HDF5 "h5ex_t_vlen.h5" {
GROUP "/" {
   DATASET "DS1" {
      DATATYPE  H5T_VLEN { H5T_STD_I32LE}
      DATASPACE  SIMPLE { ( 2 ) / ( 2 ) }
      DATA {
      (0): (3, 2, 1), (1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144)
      }
   }
}
}
