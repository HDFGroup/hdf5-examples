topics="int intatt float floatatt enum enumatt bit bitatt opaque opaqueatt \
array arrayatt vlen vlenatt string stringatt vlstring vlstringatt \
cmpd cmpdatt objref objrefatt regref regrefatt commit"

for topic in $topics
do
    fname=h5ex_t_$topic
    echo -n "Creating test reference file for 1.8/C/H5T/$fname..."
    ./$fname>$fname.test
    h5dump $fname.h5>>$fname.test
    rm -f $fname.h5
    echo "  Done."
done

#######Non-standard tests#######

fname=h5ex_t_cpxcmpd
echo -n "Creating test reference file for 1.8/C/H5T/$fname..."
./$fname>$fname.test
h5dump -n $fname.h5>>$fname.test
rm -f $fname.h5
echo "  Done."

fname=h5ex_t_cpxcmpdatt
echo -n "Creating test reference file for 1.8/C/H5T/$fname..."
./$fname>$fname.test
h5dump -n $fname.h5>>$fname.test
rm -f $fname.h5
echo "  Done."

fname=h5ex_t_convert
echo -n "Creating test reference file for 1.8/C/H5T/$fname..."
./$fname>$fname.test
echo "  Done."