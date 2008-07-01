return_val=0


echo -n "Testing 1.8/C/H5G/h5ex_g_create..."
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


echo -n "Testing 1.8/C/H5G/h5ex_g_iterate..."
if test -f h5ex_g_iterate.h5
then
    ./h5ex_g_iterate>tmp.test
else
    cp $srcdir/h5ex_g_iterate.h5 h5ex_g_iterate.h5
    ./h5ex_g_iterate>tmp.test
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


echo -n "Testing 1_8/C/H5G/h5ex_g_traverse..."
if test -f h5ex_g_traverse.h5
then
    ./h5ex_g_traverse>tmp.test
else
    cp $srcdir/h5ex_g_traverse.h5 h5ex_g_traverse.h5
    ./h5ex_g_traverse>tmp.test
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


echo -n "Testing 1_8/C/H5G/h5ex_g_visit..."
if test -f h5ex_g_visit.h5
then
    ./h5ex_g_visit>tmp.test
else
    cp $srcdir/h5ex_g_visit.h5 h5ex_g_visit.h5
    ./h5ex_g_visit>tmp.test
    rm  -f h5ex_g_visit.h5
fi
cmp -s tmp.test $srcdir/h5ex_g_visit.test
status=$?
if test $status -ne 0
then
	echo "  FAILED!"
else
	echo "  Passed"
fi
return_val=`expr $status + $return_val`


echo -n "Testing 1_8/C/H5G/h5ex_g_compact..."
./h5ex_g_compact>/dev/null
h5dump h5ex_g_compact1.h5>tmp.test
h5dump h5ex_g_compact2.h5>>tmp.test
cmp -s tmp.test $srcdir/h5ex_g_compact.test
status=$?
if test $status -ne 0
then
	echo "  FAILED!"
else
	echo "  Passed"
fi
return_val=`expr $status + $return_val`
rm -f h5ex_g_compact1.h5
rm -f h5ex_g_compact2.h5


echo -n "Testing 1_8/C/H5G/h5ex_g_phase..."
./h5ex_g_phase>tmp.test
cmp -s tmp.test $srcdir/h5ex_g_phase.test
status=$?
if test $status -ne 0
then
	echo "  FAILED!"
else
	echo "  Passed"
fi
return_val=`expr $status + $return_val`
rm -f h5ex_g_phase.h5


echo -n "Testing 1_8/C/H5G/h5ex_g_corder..."
./h5ex_g_corder>tmp.test
cmp -s tmp.test $srcdir/h5ex_g_corder.test
status=$?
if test $status -ne 0
then
	echo "  FAILED!"
else
	echo "  Passed"
fi
return_val=`expr $status + $return_val`
rm -f h5ex_g_corder.h5


echo -n "Testing 1_8/C/H5G/h5ex_g_intermediate..."
./h5ex_g_intermediate>tmp.test
cmp -s tmp.test $srcdir/h5ex_g_intermediate.test
status=$?
if test $status -ne 0
then
	echo "  FAILED!"
else
	echo "  Passed"
fi
return_val=`expr $status + $return_val`
rm -f h5ex_g_intermediate.h5


rm -f tmp.test
echo "$return_val tests failed in 1_8/C/H5G/"
exit $return_val
