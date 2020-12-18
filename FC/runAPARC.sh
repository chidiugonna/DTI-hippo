#!/bin/bash
SUB=$1
SES=$2
SINGIMG=/xdisk/nkchen/chidi/repos/DTI-hippo/singularity/nklab-neuroproc/nklab-neuroproc-v0.4.sif

DWISES=ses-post
ANATSES=ses-pre
FMRIPREP=${PWD}/../FuncPreproc/fmrioutput
CUSTOMDWI=${PWD}/../custom-pipeline

ANAT=$FMRIPREP/fmriprep/$SUB/$ANATSES/anat/${SUB}_${ANATSES}_desc-preproc_T1w.nii.gz

FUNCT1=$FMRIPREP/fmriprep/$SUB/$SES/func/${SUB}_${SES}_task-rest_acq-std_space-T1w_desc-preproc_bold.nii.gz
FUNCT1RES=$FMRIPREP/fmriprep/$SUB/$SES/func/${SUB}_${SES}_task-rest_acq-std_space-T1w_desc-preproc_bold_resampled.nii.gz

if [ ! -f $FUNCT1RES ]
then
  singularity run $SINGIMG 3dresample -input $FUNCT1 -master $ANAT -prefix $FUNCT1RES
else
  echo "Resampling of FUNC to T1 space already performed"
fi

OUTPUT=$PWD/output/$SUB/$SES
mkdir -p $OUTPUT
MATRIXOUT=$OUTPUT/${SUB}_${SES}_aparc2009_FC_matrix.csv
LOGNAME=$OUTPUT/${SUB}_${SES}_aparc2009

NODES=$CUSTOMDWI/output/tractography/${SUB}/${SUB}_${DWISES}_aparc2009_nodes_T1w.nii.gz
NODELIST=$CUSTOMDWI/freesurfer_atlas/fs_a2009s.txt 
CONFOUNDFILE=$FMRIPREP/fmriprep/$SUB/$SES/func/${SUB}_${SES}_task-rest_acq-std_desc-confounds_timeseries.tsv
LPF=0.15
HPF=0.009
CONFOUNDHEADERS=${PWD}/headers.txt
SKIPROWS=21
TR=3

singularity run $SINGIMG python $DEBUG $PWD/createFCMatrix.py  \
$FUNCT1RES \
$NODES \
$NODELIST \
$MATRIXOUT \
--confound_file=$CONFOUNDFILE \
--TR=$TR \
--logname=$LOGNAME \
--low_pass=$LPF \
--high_pass=$HPF \
--confound_cols $CONFOUNDHEADERS \
--skip_rows $SKIPROWS \
--batchmode
