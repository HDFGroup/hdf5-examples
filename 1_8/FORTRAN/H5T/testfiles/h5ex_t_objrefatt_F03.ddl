**********************
*  Output of h5dump  *
**********************

HDF5 "h5ex_t_objrefatt_F03.h5" {
GROUP "/" {
   DATASET "DS1" {
      DATATYPE  H5T_STD_I32LE
      DATASPACE  NULL
      DATA {
      }
      ATTRIBUTE "A1" {
         DATATYPE  H5T_REFERENCE
         DATASPACE  SIMPLE { ( 2 ) / ( 2 ) }
         DATA {
         (0): GROUP 1400 /G1 , DATASET 800 /DS2 
         }
      }
   }
   DATASET "DS2" {
      DATATYPE  H5T_STD_I32LE
      DATASPACE  NULL
      DATA {
      }
   }
   GROUP "G1" {
   }
}
}