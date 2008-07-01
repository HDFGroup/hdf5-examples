topics="int intatt float floatatt enum enumatt bit bitatt opaque opaqueatt \
array arrayatt vlen vlenatt string stringatt vlstring vlstringatt \
cmpd cmpdatt objref objrefatt regref regrefatt"


return_val=0


for topic in $topics
do
    fname=h5ex_t_$topic
    echo -n "Testing 1.8/C/H5T/$fname..."
    ./$fname>tmp.test
    h5dump $fname.h5>>tmp.test
    rm -f $fname.h5
    cmp -s tmp.test $srcdir/$fname.test
    status=$?
    if test $status -ne 0
    then
        echo "  FAILED!"
    else
        echo "  Passed"
    fi
    return_val=`expr $status + $return_val`
done


#######Non-standard tests#######

fname=h5ex_t_cpxcmpd
echo -n "Testing 1.8/C/H5T/$fname..."
./$fname>tmp.test
h5dump -n $fname.h5>>tmp.test
rm -f $fname.h5
cmp -s tmp.test $srcdir/$fname.test
status=$?
if test $status -ne 0
then
    echo "  FAILED!"
else
    echo "  Passed"
fi
return_val=`expr $status + $return_val`


fname=h5ex_t_cpxcmpdatt
echo -n "Testing 1.8/C/H5T/$fname..."
./$fname>tmp.test
h5dump -n $fname.h5>>tmp.test
rm -f $fname.h5
cmp -s tmp.test $srcdir/$fname.test
status=$?
if test $status -ne 0
then
    echo "  FAILED!"
else
    echo "  Passed"
fi
return_val=`expr $status + $return_val`


fname=h5ex_t_convert
echo -n "Testing 1.8/C/H5T/$fname..."
./$fname>tmp.test
cmp -s tmp.test $srcdir/$fname.test
status=$?
if test $status -ne 0
then
    echo "  FAILED!"
else
    echo "  Passed"
fi
return_val=`expr $status + $return_val`


rm -f tmp.test
echo "$return_val tests failed in 1_8/C/H5T/"
exit $return_val
