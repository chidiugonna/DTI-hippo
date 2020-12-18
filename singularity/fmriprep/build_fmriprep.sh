#!/bin/bash
module load singularity

mkdir -p /xdisk/nkchen/chidi/.singularity
export SINGULARITY_CACHEDIR=/xdisk/nkchen/chidi/.singularity

SINGNAME=fmriprep-20.2.0.sif
DOCKERURI=docker://poldracklab/fmriprep:20.2.0
singularity build $SINGNAME $DOCKERURI

