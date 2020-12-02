#!/bin/bash
./createMatrix.sh --sub="sub-cort012" \
            --workdir="/xdisk/nkchen/chidi/DTI-HIPPO" \
            --datadir="/xdisk/yinghuichou/CORT/origdata" \
            --overwrite="False" \
            --viewimg="False" \
            --ses="ses-post" \
            --anatses="ses-pre" \
            --singimg="/xdisk/yinghuichou/singularity3-images/nklab-neuroproc-v0.2.sif"


