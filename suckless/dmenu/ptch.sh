#!/bin/sh

FILES="config.def.h dmenu.c dmenu.1"
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

