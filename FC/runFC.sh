#!/bin/bash

#singularity image with relevant python libraries included
SINGIMG=/xdisk/nkchen/chidi/repos/DTI-hippo/singularity/nklab-neuroproc/nklab-neuroproc-v0.4.sif

subpref=cort
SESSIONS="ses-pre ses-post"
for number in $(seq -f "%03g" 11 12)
do
    for SES in $SESSIONS
    do
         SUB=sub-${subpref}${number}
         echo "Running aparc2009 FC matrix generation for $SUB $SES"
         $PWD/runAPARC.sh $SUB $SES
         echo "Running hcpmmp FC matrix generation for $SUB $SES"
         $PWD/runHCPMMP.sh $SUB $SES
    done
done
