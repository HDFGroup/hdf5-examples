#!/bin/bash

if [ ! -d "examples" ]; then
   echo "ERROR: run script from top-level directory"
   exit 1
fi

# Generate C references

cd examples/C/H5D; ./maketestref.sh
cd ../H5G; ./maketestref.sh
cd ../H5T; ./maketestref.sh

# Generate FORTRAN references

cd ../../FORTRAN/H5D; ./maketestref.sh
cd ../H5G; ./maketestref.sh
cd ../H5T; ./maketestref.sh
