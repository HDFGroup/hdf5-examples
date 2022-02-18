#! /bin/sh
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

VER_DIR=$(echo $(basename $(dirname $(dirname $PWD))))

case $FC in
*/*)    H5DUMP=`echo $FC | sed -e 's/\/[^/]*$/\/h5dump/'`;
        test -x $H5DUMP || H5DUMP=h5dump;;
*)      H5DUMP=h5dump;;
esac

case `echo "testing\c"; echo 1,2,3`,`echo -n testing; echo 1,2,3` in
  *c*,-n*) ECHO_N= ECHO_C='
' ;;
  *c*,*  ) ECHO_N=-n ECHO_C= ;;
  *)       ECHO_N= ECHO_C='\c' ;;
esac
ECHO_N="echo $ECHO_N"

exout() {
    $*
}

dumpout() {
    $H5DUMP $*
}
topics="vlstring"

topicsf03="$topics arrayatt_F03 array_F03 bitatt_F03 bit_F03 \
  cmpdatt_F03 cmpd_F03  enumatt_F03 \
  enum_F03 floatatt_F03 float_F03 intatt_F03 int_F03 \
  opaqueatt_F03 opaque_F03 \
  stringCatt_F03 stringC_F03 \
  string_F03 vlenatt_F03 vlen_F03"

if ($FC -showconfig 2>&1 | grep 'Fortran 2003 Compiler: yes') > /dev/null; then
  topics="$topics $topicsf03"
else
 CHCK_HDF5VER=`${FC} -showconfig | grep -i "HDF5 Version:" | sed 's/^.* //g' | sed 's/[-].*//g'`
 function version_gt { 
         test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$1";
 }
 if version_gt $CHCK_HDF5VER "1.9"; then
  topics="$topics $topicsf03"
 fi
fi

for topic in $topics
do
    fname=h5ex_t_$topic
    $ECHO_N "Creating test reference file for 1.8/FORTRAN/H5T/$fname...$ECHO_C"
    exout ./$fname >testfiles/$fname.tst
    dumpout $fname.h5 >testfiles/$fname.ddl
    rm -f $fname.h5
    echo "  Done."
done

topics="objrefatt_F03 objref_F03 \
  regrefatt_F03 regref_F03"

VERS=""
CHCK_HDF5VER=`$H5DUMP -V | grep -i "Version " | sed 's/^.* //g' | sed 's/[-].*//g'`
function version_gt { 
     test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$1"; 
}
if version_gt $CHCK_HDF5VER "1.8"; then
   VERS="110"  
fi

for topic in $topics
do
    fname=h5ex_t_$topic
    $ECHO_N "Creating test reference file for $VER_DIR/FORTRAN/H5T/$fname...$ECHO_C"
    exout ./$fname >testfiles/$fname.tst
    dumpout $fname.h5 >testfiles/$fname$VERS.ddl
    rm -f $fname.h5
    echo "  Done."
done

#######Non-standard tests#######

#fname=h5ex_t_cpxcmpd
#$ECHO_N "Creating test reference file for 1.8/C/H5T/$fname...$ECHO_C"
#exout ./$fname >testfiles/$fname.tst
#dumpout -n $fname.h5 >testfiles/$fname.ddl
#rm -f $fname.h5
#echo "  Done."
#
#fname=h5ex_t_cpxcmpdatt
#$ECHO_N "Creating test reference file for 1.8/C/H5T/$fname...$ECHO_C"
#exout ./$fname >testfiles/$fname.tst
#dumpout -n $fname.h5 >testfiles/$fname.ddl
#rm -f $fname.h5
#echo "  Done."

#fname=h5ex_t_convert
#$ECHO_N "Creating test reference file for 1.8/C/H5T/$fname...$ECHO_C"
#exout ./$fname >$fname.test
#echo "  Done."
