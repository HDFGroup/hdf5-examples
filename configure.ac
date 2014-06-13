#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.
#
# Copyright by The HDF Group.
# Copyright by the Board of Trustees of the University of Illinois.
# All rights reserved.
#
# This file is part of HDF5.  The full HDF5 copyright notice, including
# terms governing use, modification, and redistribution, is contained in
# the files COPYING and Copyright.html.  COPYING can be found at the root
# of the source code distribution tree; Copyright.html can be found at the
# root level of an installed copy of the electronic HDF5 document set and
# is linked from the top-level documents page.  It can also be found at
# http://hdfgroup.org/HDF5/doc/Copyright.html.  If you do not have
# access to either file, you may request a copy from help@hdfgroup.org.

AC_PREREQ(2.59)
AC_INIT(HDF5-examples, 0.1, nfortne2@hdfgroup.org)
dnl AM_INIT_AUTOMAKE takes a list of options that should be applied to
dnl every Makefile.am when automake is run.
AM_INIT_AUTOMAKE([foreign])
AM_CONFIG_HEADER(config.h)

# Turn off automake rebuild rules so make doesn't try to run automake
# (which probably won't work).
AM_MAINTAINER_MODE

# Argument for static linking
AC_ARG_ENABLE(shared,
    [AS_HELP_STRING([--disable-shared],
        [force static linking])],
    [if test "$enableval" = "no"; then
        shared_suffix=""
        echo lo!
    else
        shared_suffix=" -shlib"
    fi],
    [shared_suffix=" -shlib"])

# Sets compiler.
AC_PROG_CC([h5cc])
AC_PROG_FC([h5fc])
# Add the suffix to CC for shared linking.  Can't just set as an option
# because it must be first.
if test "$shared_suffix" && test ! `echo $CC | grep "$shared_suffix"`; then
    CC=${CC}${shared_suffix}
fi
# Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST

# Check which versions to build, if no environmental variables are set, build
# all.
if test ! "$H5EX_16" && test ! "$H5EX_18" && test ! "$H5EX_110"
then
  H5EX_16=1
  H5EX_18=1
  H5EX_110=1
fi
AM_CONDITIONAL(V16, test "$H5EX_16")
AM_CONDITIONAL(V18, test "$H5EX_18")
AM_CONDITIONAL(V110, test "$H5EX_110")

if test ! "$H5EX_G" && test ! "$H5EX_D" && test ! "$H5EX_T"
then
  H5EX_G=1
  H5EX_D=1
  H5EX_T=1
fi
AM_CONDITIONAL(H5G, test "$H5EX_G")
AM_CONDITIONAL(H5D, test "$H5EX_D")
AM_CONDITIONAL(H5T, test "$H5EX_T")

# Check if a Fortran 2003 compiler was used for h5fc
HAVE_FORTRAN_2003="no"

AC_MSG_CHECKING([if h5fc was compiled with Fortran 2003 enabled])
if (${FC} -showconfig 2>&1 | grep 'Fortran 2003 Compiler: yes') > /dev/null; then
  HAVE_FORTRAN_2003="yes"	
fi
echo $HAVE_FORTRAN_2003 

# Check if we have Fortran 2003 and Intel compiler; Intel doesn't work with RECURSIVE used by h5ex_g_traverse.f90
# The example will not be built when Intel compiler is used (EIP 2011/10/14)

if test "X$HAVE_FORTRAN_2003" = "Xyes"; then
  HAVE_FORTRAN_2003_NOTINTEL="yes"
  AC_MSG_CHECKING([if h5fc is an Intel Fortran compiler])
  if (${FC} -showconfig 2>&1 | grep 'Intel(R) Fortran ') > /dev/null; then
    HAVE_FORTRAN_2003_NOTINTEL="no"
  fi
  if test "X$HAVE_FORTRAN_2003_NOTINTEL" = "Xyes"; then
    echo "no"
  else
    echo "yes"
  fi 
fi
# End check if we have Fortran 2003 and Intel compiler.

AM_CONDITIONAL([FORTRAN_2003_CONDITIONAL_F], [test "X$HAVE_FORTRAN_2003" = "Xyes"])
AM_CONDITIONAL([FORTRAN_2003_NOTINTEL_CONDITIONAL_F], [test "X$HAVE_FORTRAN_2003_NOTINTEL" = "Xyes"])

# Set subdirectories
AC_CONFIG_FILES([makefile 
                 1_6/makefile 
                 1_6/C/makefile 
                 1_6/C/H5G/makefile 
                 1_6/C/H5G/test.sh 
                 1_6/C/H5D/makefile 
                 1_6/C/H5D/test.sh 
                 1_6/C/H5T/makefile 
                 1_6/C/H5T/test.sh 
                 1_8/makefile 
                 1_8/C/makefile 
                 1_8/C/H5G/makefile 
                 1_8/C/H5G/test.sh 
                 1_8/C/H5D/makefile 
                 1_8/C/H5D/test.sh 
                 1_8/C/H5T/makefile 
                 1_8/C/H5T/test.sh 
                 1_8/FORTRAN/makefile 
                 1_8/FORTRAN/H5G/makefile 
                 1_8/FORTRAN/H5G/test.sh 
                 1_8/FORTRAN/H5D/makefile 
                 1_8/FORTRAN/H5D/test.sh 
                 1_8/FORTRAN/H5T/makefile 
                 1_8/FORTRAN/H5T/test.sh 
                 1_10/makefile 
                 1_10/C/makefile 
                 1_10/C/H5G/makefile 
                 1_10/C/H5G/test.sh 
                 1_10/C/H5D/makefile 
                 1_10/C/H5D/test.sh 
                 1_10/C/H5T/makefile 
                 1_10/C/H5T/test.sh 
                 1_10/FORTRAN/makefile 
                 1_10/FORTRAN/H5G/makefile 
                 1_10/FORTRAN/H5G/test.sh 
                 1_10/FORTRAN/H5D/makefile 
                 1_10/FORTRAN/H5D/test.sh 
                 1_10/FORTRAN/H5T/makefile
                 1_10/FORTRAN/H5T/test.sh ])

# Configure
AC_OUTPUT
