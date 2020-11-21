#!/bin/bash

WORKDIR=$PWD
DATADIR="/xdisk/yinghuichou/CORT/origdata"
OVERWRITE="False"
VIEWIMG="False"
SES="ses-post"
ANATSES="ses-pre"
SINGIMG="/xdisk/yinghuichou/singularity3-images/nklab-neuroproc-v0.2.sif"

for number in $(seq -f "%03g" 12 12)
do
SUB=sub-cort$number
sbatch --export=ALL,SUB=$SUB,SES=$SES,ANATSES=$ANATSES,WORKDIR=$WORKDIR,DATADIR=$DATADIR,OVERWRITE=$OVERWRITE,VIEWIMG=$VIEWIMG,SINGIMG=$SINGIMG $WORKDIR/createMatrix.sh 
done
