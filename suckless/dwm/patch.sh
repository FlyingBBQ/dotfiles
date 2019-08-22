#!/bin/sh
#
# Helper script for generating patches
#
# usage:
# 1. Before making a new patch run: patch.sh copy
# 2. When finished with new feature run: patch.sh manual
#    to generate the .diff file in tmpdir
# 3. Rename and copy the .diff to the patches/ dir
# 4. Run: patch.sh clean; go back to step 1


FILES="config.def.h dwm.c drw.h drw.c"
tmpdir=tmpp/
patchname=patch.diff

case "$1" in
    "copy" )
        mkdir $tmpdir
        for f in $FILES
        do
            cp $f $tmpdir
        done
        ;;
    "manual" )
        for f in $FILES
        do
            diff -u $tmpdir$f $f >> $tmpdir$patchname
        done
        ;;
    "clean" )
        rm -rf $tmpdir
        ;;
esac

