#!/bin/sh

tmpdir=tmpp/
dwmh=config.def.h
dwmc=dwm.c
patchname=patch.diff

case "$1" in
    "copy" )
        mkdir $tmpdir
        cp $dwmh $dwmc $tmpdir
        ;;
    "manual" )
        diff -u $tmpdir$dwmh $dwmh > $tmpdir$patchname
        diff -u $tmpdir$dwmc $dwmc >> $tmpdir$patchname
        ;;
    "clean" )
        rm -rf $tmpdir
        ;;
esac

