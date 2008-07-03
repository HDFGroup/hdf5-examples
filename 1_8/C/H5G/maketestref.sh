#! /bin/sh
./h5ex_g_create
h5dump h5ex_g_create.h5>h5ex_g_create.test
rm -f h5ex_g_create.h5

./h5ex_g_iterate>h5ex_g_iterate.test

./h5ex_g_traverse>h5ex_g_traverse.test

./h5ex_g_visit>h5ex_g_visit.test

./h5ex_g_compact>h5ex_g_compact.test
rm -f h5ex_g_compact1.h5
rm -f h5ex_g_compact2.h5

./h5ex_g_phase>h5ex_g_phase.test
rm -f h5ex_g_phase.h5

./h5ex_g_corder>h5ex_g_corder.test
rm -f h5ex_g_corder.h5

./h5ex_g_intermediate>h5ex_g_intermediate.test
rm -f h5ex_g_intermediate.h5
