HDF5 "h5ex_d_transform.h5" {
GROUP "/" {
   DATASET "DS1" {
      DATATYPE  H5T_STD_I32LE
      DATASPACE  SIMPLE { ( 7, 4 ) / ( 7, 4 ) }
      DATA {
      (0,0): 1, 1, 1, 1,
      (1,0): 0, 1, 2, 3,
      (2,0): -1, 1, 3, 5,
      (3,0): -2, 1, 4, 7,
      (4,0): -3, 1, 5, 9,
      (5,0): -4, 1, 6, 11,
      (6,0): -5, 1, 7, 13
      }
   }
}
}
