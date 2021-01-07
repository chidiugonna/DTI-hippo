#!/bin/bash

WORKDIR=$PWD
DATADIR="/xdisk/yinghuichou/CORT/origdata"
OVERWRITE="False"
VIEWIMG="False"
SES="ses-post"
ANATSES="ses-pre"
SINGIMG="/xdisk/nkchen/chidi/repos/DTI-hippo/singularity/nklab-neuroproc/nklab-neuroproc-v0.4.sif"
OUTPUT=$PWD/output
DEBUG="False"

#NUMS="017 018 020"
#for number in $NUMS
for number in $(seq -f "%03g" 17 17)
do
SUB=sub-cort$number
sbatch --export=ALL,SUB=$SUB,SES=$SES,ANATSES=$ANATSES,WORKDIR=$WORKDIR,DATADIR=$DATADIR,OVERWRITE=$OVERWRITE,VIEWIMG=$VIEWIMG,SINGIMG=$SINGIMG,OUTPUT=$OUTPUT,DEBUG=$DEBUG $WORKDIR/createMatrix.sh 
done
