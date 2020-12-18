#!/bin/bash
SES=post
VERBOSE=4
WORKDIR=$PWD 
DATADIR=/xdisk/yinghuichou/CORT/origdata
SINGIMG=/xdisk/nkchen/chidi/repos/DTI-hippo/singularity/mrtrix3-connectome-custom/mrtrix3-connectome-v0.5.sif
ANATSES=ses-pre
OVERWRITE=False
OUTPUT=$PWD/output
# make sure you don't call the scratch directory "scratch"! 
SCRATCH=$PWD/myscratch


for number in $(seq -f "%03g" 11 12)
do
SUB=cort$number
sbatch --export=ALL,SUB=$SUB,SES=$SES,ANATSES=$ANATSES,WORKDIR=$WORKDIR,DATADIR=$DATADIR,OVERWRITE=$OVERWRITE,SINGIMG=$SINGIMG,OUTPUT=$OUTPUT,FREEDIR=$FREEDIR,SCRATCH=$SCRATCH do-connectome.sh 
done
