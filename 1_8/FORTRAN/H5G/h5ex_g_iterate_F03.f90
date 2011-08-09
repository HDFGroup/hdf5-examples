!************************************************************
!
!  This example shows how to iterate over group members using
!  H5Literate.
!
!  This file is intended for use with HDF5 Library version 1.8
!  with --enable-fortran2003 
!
!
!************************************************************
MODULE liter_cb_mod
  
  USE HDF5
  USE ISO_C_BINDING
  IMPLICIT NONE

  ! Custom group iteration callback data
  TYPE, bind(c) ::  iter_info
     CHARACTER(LEN=1), DIMENSION(1:10) :: name ! The name of the object
     INTEGER(c_int) :: type    ! The type of the object
     INTEGER(c_int) :: command ! The type of return value
  END TYPE iter_info

  TYPE, bind(c) :: union_t
     INTEGER(haddr_t) :: address
     INTEGER(size_t) :: val_size
  END TYPE union_t

  TYPE, bind(c) :: H5L_info_t
     INTEGER(c_int) :: type
     INTEGER(c_int64_t) :: corder
     INTEGER(c_int) :: cset
     TYPE(union_t) :: u
  END TYPE H5L_info_t

CONTAINS

!************************************************************
!
!  Operator function.  Prints the name and type of the object
!  being examined.
!
! ************************************************************

  INTEGER FUNCTION op_func(loc_id, name, info, operator_data) bind(C)
    
    USE HDF5
    USE ISO_C_BINDING
    IMPLICIT NONE
    
    INTEGER(HID_T), VALUE :: loc_id
    CHARACTER(LEN=1), DIMENSION(1:10) :: name ! must have LEN=1 for bind(C) strings
    TYPE (H5L_info_t) :: info
    TYPE(iter_info) :: operator_data
    
    INTEGER   :: status, i

    TYPE(H5O_info_t), TARGET :: infobuf 
    TYPE(C_PTR) :: ptr
    CHARACTER(LEN=10) :: name_string

    !
    ! Get type of the object and display its name and type.
    ! The name of the object is passed to this FUNCTION by
    ! the Library.
    !

    DO i = 1, 10
       name_string(i:i) = name(i)(1:1)
    ENDDO
    ptr = C_LOC(infobuf)

    CALL H5Oget_info_by_name_f(loc_id, name_string, ptr, status)

    IF(infobuf%type.EQ.H5O_TYPE_GROUP_F)THEN
       WRITE(*,*) "Group: ", name_string
    ELSE IF(infobuf%type.EQ.H5O_TYPE_DATASET_F)THEN
       WRITE(*,*) "Dataset: ", name_string
    ELSE IF(infobuf%type.EQ.H5O_TYPE_NAMED_DATATYPE_F)THEN
       WRITE(*,*) "Datatype: ", name_string
    ELSE
       WRITE(*,*) "Unknown: ", name_string
    ENDIF

    op_func = 0 ! return successful

  END FUNCTION op_func

END MODULE liter_cb_mod


PROGRAM main

  USE HDF5
  USE ISO_C_BINDING
  USE liter_cb_mod
  
  IMPLICIT NONE

  CHARACTER(LEN=17), PARAMETER :: filename  = "h5ex_g_iterate.h5"
  INTEGER(HID_T) :: file ! Handle
  INTEGER :: status
  TYPE(C_FUNPTR) :: funptr
  TYPE(C_PTR) :: ptr
  INTEGER(hsize_t) idx
  TYPE(iter_info), TARGET :: info
  INTEGER :: ret_value

  !
  ! Open file.
  !
  CALL H5Fopen_f(filename, H5F_ACC_RDONLY_F, file, status)

  !
  ! Begin iteration.
  !
  WRITE(*,'(A)') "Objects in root group:"

  idx = 0
  funptr = C_FUNLOC(op_func)
  ptr = C_LOC(info)

  CALL H5Literate_f(file, H5_INDEX_NAME_F, H5_ITER_NATIVE_F, idx, funptr, ptr, ret_value, status)

  !
  ! Close and release resources.
  !
  CALL H5Fclose_f(file, status)

END PROGRAM main

