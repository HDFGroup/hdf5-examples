return_val=0


echo -n "Testing 1_6/C/H5G/h5ex_g_create..."
./h5ex_g_create
h5dump h5ex_g_create.h5>tmp.test
rm -f h5ex_g_create.h5
cmp -s tmp.test $srcdir/h5ex_g_create.test
status=$?
if test $status -ne 0
then
	echo "  FAILED!"
else
	echo "  Passed"
fi
return_val=`expr $status + $return_val`


echo -n "Testing 1_6/C/H5G/h5ex_g_iterate..."
cp -u $srcdir/h5ex_g_iterate.h5 h5ex_g_iterate.h5 &>/dev/null
cpstatus=$?
./h5ex_g_iterate>tmp.test
if test $cpstatus -eq 0
then
	rm  -f h5ex_g_iterate.h5
fi
cmp -s tmp.test $srcdir/h5ex_g_iterate.test
status=$?
if test $status -ne 0
then
	echo "  FAILED!"
else
	echo "  Passed"
fi
return_val=`expr $status + $return_val`


echo -n "Testing 1_6/C/H5G/h5ex_g_traverse..."
cp -u $srcdir/h5ex_g_traverse.h5 h5ex_g_traverse.h5 &>/dev/null
cpstatus=$?
./h5ex_g_traverse>tmp.test
if test $cpstatus -eq 0
then
	rm  -f h5ex_g_traverse.h5
fi
cmp -s tmp.test $srcdir/h5ex_g_traverse.test
status=$?
if test $status -ne 0
then
	echo "  FAILED!"
else
	echo "  Passed"
fi
return_val=`expr $status + $return_val`


rm -f tmp.test
echo "$return_val tests failed in 1_6/C/H5G/"
exit $return_val
