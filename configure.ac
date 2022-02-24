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

AC_PREREQ(2.69)
AC_INIT(HDF5-examples, 0.1, help@hdfgroup.org)
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
H5C_exists=`h5cc --version > /dev/null 2>&1; echo $?`
if test "0" = "$H5C_exists"; then
  H5C="h5cc"
else
  H5C_exists=`h5pcc --version > /dev/null 2>&1; echo $?`
  if test "0" = "$H5C_exists"; then
     H5C="h5pcc"
  else
     AC_MSG_ERROR(failed to find h5cc or h5pcc)
  fi
fi      
AC_PROG_CC([$H5C])

H5FC_exists=`h5fc --version > /dev/null 2>&1; echo $?`
if test "x0" = "x$H5FC_exists"; then
     H5FC="h5fc"
else
  H5FC_exists=`h5pfc --version  > /dev/null 2>&1; echo $?`
  if test "x0" = "x$H5FC_exists"; then
     H5FC="h5pfc"
  fi
fi
AC_PROG_FC([$H5FC])

# Add the suffix to CC for shared linking.  Can't just set as an option
# because it must be first.
if test "$shared_suffix" && test ! `echo ${CC} | grep "$shared_suffix"`; then
    CC=${CC}${shared_suffix}
fi
# Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST

# Determine the version of the HDF5 Library
AC_MSG_CHECKING([the version of the HDF5 Library])

AC_SUBST([H5_LIBVER])
H5_LIBVER=$(${CC} -showconfig | grep -i "HDF5 Version:" | sed 's/^.* //g' | sed 's/[-].*//g')
AC_MSG_RESULT([$H5_LIBVER])

AC_MSG_CHECKING([the API mapping of the HDF5 Library])
AC_SUBST([H5_APIVER])
H5_APIVER=$(${CC} -showconfig | grep -i "Default API mapping:" | sed 's/^.* //g' | sed 's/v//g' | sed 's/1/1_/')
AC_MSG_RESULT([$H5_APIVER])

#if version is unreleased then bump to next official release.

AC_SUBST([H5_LIBVER_DIR])
H5_MAJORVER=$(echo $H5_LIBVER | cut -f1 -d'.'  | sed -r 's/\./_/g')
H5_MINORVER=$(echo $H5_LIBVER | cut -f2 -d'.'  | sed -r 's/\./_/g')

rem=$(( $H5_MINORVER % 2 ))
if test "$rem" != "0";then
 H5_MINORVER=$(($H5_MINORVER+1))
fi
H5_LIBVER_DIR=${H5_MAJORVER}_${H5_MINORVER}

# Test whether one version ($1) is greater than or equal to other ($2).
function version_gt {
    test "`printf '%s\n' "$@" | sort -V | head -n 1`" != "$1";
}

if test ! "$H5EX_G" && test ! "$H5EX_D" && test ! "$H5EX_T";then
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


# if HDF5 version is 1.8 and HDF5 used a 2003 Fortran compiler.
if (${FC} -showconfig 2>&1 | grep 'Fortran 2003 Compiler: yes') > /dev/null; then
  HAVE_FORTRAN_2003="yes"
else
# check if HDF5 version is > 1.8
 if version_gt "$H5_LIBVER" "1.9.0"; then   
     HAVE_FORTRAN_2003="yes"
 fi
fi

AC_MSG_RESULT([$HAVE_FORTRAN_2003])

# Check if we have Fortran 2003 and Intel compiler; Intel doesn't work with RECURSIVE used by h5ex_g_traverse.F90
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
else
  echo "no"
fi
# End check if we have Fortran 2003 and Intel compiler.

AM_CONDITIONAL([FORTRAN_2003_CONDITIONAL_F], [test "X$HAVE_FORTRAN_2003" = "Xyes"])
AM_CONDITIONAL([FORTRAN_2003_NOTINTEL_CONDITIONAL_F], [test "X$HAVE_FORTRAN_2003_NOTINTEL" = "Xyes"])
HDF5_GE112="no"
if version_gt "$H5_LIBVER" "1.11"; then
  HDF5_GE112="yes"
fi
AM_CONDITIONAL([HDF5_GE112], [test "X$HDF5_GE112" = "Xyes"])

HDF5_GE110="no"
if version_gt "$H5_LIBVER" "1.9"; then
  HDF5_GE110="yes"
fi
AM_CONDITIONAL([HDF5_GE110], [test "X$HDF5_GE110" = "Xyes"])
AC_SUBST([HDF5_GE110])

AC_CONFIG_FILES([Makefile
                 examples/Makefile
                 examples/C/Makefile
                 examples/C/H5D/Makefile
                 examples/C/H5G/Makefile
                 examples/C/H5T/Makefile
                 examples/FORTRAN/Makefile
                 examples/FORTRAN/H5D/Makefile
                 examples/FORTRAN/H5G/Makefile
                 examples/FORTRAN/H5T/Makefile
        ])

AC_CONFIG_FILES([examples/C/H5D/maketestref.sh], [chmod +x examples/C/H5D/maketestref.sh])
AC_CONFIG_FILES([examples/C/H5G/maketestref.sh], [chmod +x examples/C/H5G/maketestref.sh])
AC_CONFIG_FILES([examples/C/H5T/maketestref.sh], [chmod +x examples/C/H5T/maketestref.sh])
AC_CONFIG_FILES([examples/FORTRAN/H5D/maketestref.sh], [chmod +x examples/FORTRAN/H5D/maketestref.sh])
AC_CONFIG_FILES([examples/FORTRAN/H5G/maketestref.sh], [chmod +x examples/FORTRAN/H5G/maketestref.sh])
AC_CONFIG_FILES([examples/FORTRAN/H5T/maketestref.sh], [chmod +x examples/FORTRAN/H5T/maketestref.sh])

AC_CONFIG_FILES([examples/C/H5D/test.sh], [chmod +x examples/C/H5D/test.sh])
AC_CONFIG_FILES([examples/C/H5G/test.sh], [chmod +x examples/C/H5G/test.sh])
AC_CONFIG_FILES([examples/C/H5T/test.sh], [chmod +x examples/C/H5T/test.sh])
AC_CONFIG_FILES([examples/FORTRAN/H5D/test.sh], [chmod +x examples/FORTRAN/H5D/test.sh])
AC_CONFIG_FILES([examples/FORTRAN/H5G/test.sh], [chmod +x examples/FORTRAN/H5G/test.sh])
AC_CONFIG_FILES([examples/FORTRAN/H5T/test.sh], [chmod +x examples/FORTRAN/H5T/test.sh])

# Set subdirectories
#AC_CONFIG_FILES([Makefile vers/Makefile vers/1_6/makefile vers/1_6/C/makefile vers/1_6/C/H5G/makefile vers/1_6/C/H5D/makefile vers/1_6/C/H5T/makefile $list])

#AC_CONFIG_FILES([vers/1_6/C/H5G/test.sh], [chmod +x vers/1_6/C/H5G/test.sh]) 
#AC_CONFIG_FILES([vers/1_6/C/H5D/test.sh], [chmod +x vers/1_6/C/H5D/test.sh])
#AC_CONFIG_FILES([vers/1_6/C/H5T/test.sh], [chmod +x vers/1_6/C/H5T/test.sh])

#AC_CONFIG_FILES([vers/1_8/C/H5G/test.sh], [chmod +x vers/1_8/C/H5G/test.sh])
#AC_CONFIG_FILES([vers/1_8/C/H5D/test.sh], [chmod +x vers/1_8/C/H5D/test.sh])
#AC_CONFIG_FILES([vers/1_8/C/H5T/test.sh], [chmod +x vers/1_8/C/H5T/test.sh])
#AC_CONFIG_FILES([vers/1_8/FORTRAN/H5G/test.sh], [chmod +x vers/1_8/FORTRAN/H5G/test.sh])
#AC_CONFIG_FILES([vers/1_8/FORTRAN/H5D/test.sh], [chmod +x vers/1_8/FORTRAN/H5D/test.sh])
#AC_CONFIG_FILES([vers/1_8/FORTRAN/H5T/test.sh], [chmod +x vers/1_8/FORTRAN/H5T/test.sh])

#AC_CONFIG_FILES([vers/1_10/C/H5G/test.sh], [chmod +x vers/1_10/C/H5G/test.sh])
#AC_CONFIG_FILES([vers/1_10/C/H5D/test.sh], [chmod +x vers/1_10/C/H5D/test.sh])
#AC_CONFIG_FILES([vers/1_10/C/H5T/test.sh], [chmod +x vers/1_10/C/H5T/test.sh])
#AC_CONFIG_FILES([vers/1_10/FORTRAN/H5G/test.sh], [chmod +x vers/1_10/FORTRAN/H5G/test.sh])
#AC_CONFIG_FILES([vers/1_10/FORTRAN/H5D/test.sh], [chmod +x vers/1_10/FORTRAN/H5D/test.sh])
#AC_CONFIG_FILES([vers/1_10/FORTRAN/H5T/test.sh], [chmod +x vers/1_10/FORTRAN/H5T/test.sh])

#AC_CONFIG_FILES([vers/1_12/C/H5G/test.sh], [chmod +x vers/1_12/C/H5G/test.sh])
#AC_CONFIG_FILES([vers/1_12/C/H5D/test.sh], [chmod +x vers/1_12/C/H5D/test.sh])
#AC_CONFIG_FILES([vers/1_12/C/H5T/test.sh], [chmod +x vers/1_12/C/H5T/test.sh])
#AC_CONFIG_FILES([vers/1_12/FORTRAN/H5G/test.sh], [chmod +x vers/1_12/FORTRAN/H5G/test.sh])
#AC_CONFIG_FILES([vers/1_12/FORTRAN/H5D/test.sh], [chmod +x vers/1_12/FORTRAN/H5D/test.sh])
#AC_CONFIG_FILES([vers/1_12/FORTRAN/H5T/test.sh], [chmod +x vers/1_12/FORTRAN/H5T/test.sh])

#AC_CONFIG_FILES([vers/1_14/C/H5G/test.sh], [chmod +x vers/1_14/C/H5G/test.sh])
#AC_CONFIG_FILES([vers/1_14/C/H5D/test.sh], [chmod +x vers/1_14/C/H5D/test.sh])
#AC_CONFIG_FILES([vers/1_14/C/H5T/test.sh], [chmod +x vers/1_14/C/H5T/test.sh])
#AC_CONFIG_FILES([vers/1_14/FORTRAN/H5G/test.sh], [chmod +x vers/1_14/FORTRAN/H5G/test.sh])
#AC_CONFIG_FILES([vers/1_14/FORTRAN/H5D/test.sh], [chmod +x vers/1_14/FORTRAN/H5D/test.sh])
#AC_CONFIG_FILES([vers/1_14/FORTRAN/H5T/test.sh], [chmod +x vers/1_14/FORTRAN/H5T/test.sh])


# Configure
AC_OUTPUT
