/************************************************************

  This example shows a way to recursively traverse the file
  using H5Literate.  The method shown here guarantees that
  the recursion will not enter an infinite loop, but does
  not prevent objects from being visited more than once.
  The program prints the directory structure of the file
  specified in FILE.  The default file used by this example
  implements the structure described in the User's Guide,
  chapter 4, figure 26.

  This file is intended for use with HDF5 Library verion 1.8

 ************************************************************/

#include "hdf5.h"
#include <stdio.h>

#define FILE       "h5ex_g_traverse.h5"

/*
 * Define operator data structure type for H5Literate callback.
 * During recursive iteration, these structures will form a
 * linked list that can be searched for duplicate groups,
 * preventing infinite recursion.
 */
struct opdata {
    unsigned        recurs;         /* recursion level.  0=root */
    struct opdata   *prev;          /* pointer to previous opdata */
    haddr_t         addr;           /* group address */
};

/*
 * Operator function to be called by H5Literate.
 */
herr_t op_func (hid_t loc_id, const char *name, const H5L_info_t *info,
            void *operator_data);

/*
 * Function to check for duplicate groups in a path.
 */
int group_check (struct opdata *od, haddr_t target_addr);

int
main (void)
{
    hid_t           file;           /* handle */
    herr_t          status;
    H5O_info_t      infobuf;
    struct opdata   od;

    /*
     * Open file and initialize the operator data structure.
     */
    file = H5Fopen (FILE, H5F_ACC_RDONLY, H5P_DEFAULT);
    status = H5Oget_info (file, &infobuf);
    od.recurs = 0;
    od.prev = NULL;
    od.addr = infobuf.addr;

    /*
     * Print the root group and formatting, begin iteration.
     */
    printf ("/ {\n");
    status = H5Literate (file, H5_INDEX_NAME, H5_ITER_NATIVE, NULL, op_func,
                (void *) &od);
    printf ("}\n");

    /*
     * Close and release resources.
     */
    status = H5Fclose (file);

    return 0;
}


/************************************************************

  Operator function.  This function prints the name and type
  of the object passed to it.  If the object is a group, it
  is first checked against other groups in its path using
  the group_check function, then if it is not a duplicate,
  H5Literate is called for that group.  This guarantees that
  the program will not enter infinite recursion due to a
  circular path in the file, as long as reference counts
  have not been improperly manipulated.

 ************************************************************/
herr_t op_func (hid_t loc_id, const char *name, const H5L_info_t *info,
            void *operator_data)
{
    herr_t          status, return_val = 0;
    H5O_info_t      infobuf;
    struct opdata   *od = (struct opdata *) operator_data;
                                /* Type conversion */
    unsigned        spaces = 2*(od->recurs+1);
                                /* Number of whitespaces to prepend
                                   to output */

    /*
     * Get type of the object and display its name and type.
     * The name of the object is passed to this function by
     * the Library.
     */
    status = H5Oget_info_by_name (loc_id, name, &infobuf, H5P_DEFAULT);
    printf ("%*s", spaces, "");     /*Format output*/
    switch (infobuf.type) {
        case H5O_TYPE_GROUP:
            printf ("Group: %s {\n", name);

            /*
             * Check group address against linked list of operator
             * data structures.  Only necessary if there is more
             * than 1 link to the group.
             */
            if ( (infobuf.rc > 1) && group_check (od, infobuf.addr) ) {
                printf ("%*s  Warning: Loop detected!\n", spaces, "");
            }
            else {

                /*
                 * Initialize new operator data structure and
                 * begin recursive iteration on the discovered
                 * group.  The new opdata structure is given a
                 * pointer to the current one.
                 */
                struct opdata nextod;
                nextod.recurs = od->recurs + 1;
                nextod.prev = od;
                nextod.addr = infobuf.addr;
                return_val = H5Literate_by_name (loc_id, name, H5_INDEX_NAME,
                            H5_ITER_NATIVE, NULL, op_func, (void *) &nextod,
                            H5P_DEFAULT);
            }
            printf ("%*s}\n", spaces, "");
            break;
        case H5O_TYPE_DATASET:
            printf ("Dataset: %s\n", name);
            break;
        case H5O_TYPE_NAMED_DATATYPE:
            printf ("Datatype: %s\n", name);
            break;
        default:
            printf ( "Unknown: %s\n", name);
    }

    return return_val;
}


/************************************************************

  This function recursively searches the linked list of
  opdata structures for one whose address matches
  target_addr.  Returns 1 if a match is found, and 0
  otherwise.

 ************************************************************/
int group_check (struct opdata *od, haddr_t target_addr)
{
    if (od->addr == target_addr)
        return 1;       /* Addresses match */
    else if (!od->recurs)
        return 0;       /* Root group reached with no matches */
    else
        return group_check (od->prev, target_addr);
                        /* Recursively examine the next node */
}
