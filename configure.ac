#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.59)
AC_INIT(HDF5-examples, 0.1, nfortne2@hdfgroup.org)
AM_INIT_AUTOMAKE(HDF5-examples, 0.1)

# Sets compiler.
AC_PROG_CC([h5cc])

# Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST

# Check which versions to build, if no environmental variables are set, build
# all.
if test ! "$H5EX_16" && test ! "$H5EX_18"
then
	H5EX_16=1
	H5EX_18=1
fi
AM_CONDITIONAL(V16, test "$H5EX_16")
AM_CONDITIONAL(V18, test "$H5EX_18")

if test ! "$H5EX_G" && test ! "$H5EX_T"
then
	H5EX_G=1
	H5EX_T=1
fi
AM_CONDITIONAL(H5G, test "$H5EX_G")
AM_CONDITIONAL(H5T, test "$H5EX_T")

# Set subdirectories
AC_CONFIG_FILES([makefile 1_6/makefile 1_6/C/makefile 1_6/C/H5G/makefile \
1_8/makefile 1_8/C/makefile 1_8/C/H5G/makefile 1_8/C/H5T/makefile])

# Configure
AC_OUTPUT
