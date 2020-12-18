#!/bin/bash
if [ -z ${1+x} ]
then 
  DEBUG=--debug="False"
else
  DEBUG=$1
fi
. ./createMatrix.sh --sub="sub-cort063" \
            --workdir="$PWD" \
            --datadir="/xdisk/yinghuichou/CORT/origdata" \
            --overwrite="False" \
            --viewimg="False" \
            --ses="ses-post" \
            --anatses="ses-pre" \
            --singimg="/xdisk/nkchen/chidi/repos/DTI-hippo/singularity/nklab-neuroproc/nklab-neuroproc-v0.3.sif" \
            --output="$PWD/output" \
            ${DEBUG}

