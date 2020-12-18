#!/bin/bash
ROOTDIR=$PWD/CORT

mkdir -p $ROOTDIR

SUB=$1
DATADIR=$2

cp -R $DATADIR/$SUB $ROOTDIR 

rm -rf $ROOTDIR/$SUB/*/func/*moco*
rm -rf $ROOTDIR/$SUB/*/dwi
rm -rf $ROOTDIR/$SUB/*/misc
rm -rf $ROOTDIR/$SUB/*/asl

rm -rf $ROOTDIR/$SUB/ses-post/anat

mv $ROOTDIR/$SUB/ses-pre/anat/${SUB}_ses-pre_acq-nd_T1w.json $ROOTDIR/$SUB/ses-pre/anat/${SUB}_ses-pre_T1w.json
mv $ROOTDIR/$SUB/ses-pre/anat/${SUB}_ses-pre_acq-nd_T1w.nii.gz $ROOTDIR/$SUB/ses-pre/anat/${SUB}_ses-pre_T1w.nii.gz
rm -rf $ROOTDIR/$SUB/ses-pre/anat/*acq*
rm -rf $ROOTDIR/$SUB/ses-pre/anat/*run*
