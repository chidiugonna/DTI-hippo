#!/bin/bash
CON=neuroproc
VER=`cat ./src/version | grep version | awk {'print $2'}`
if [ -z ${1+x} ]
then 
    echo  "Specify sandbox, full or convert" 
elif [ $1 = "sandbox" ]
then
   echo  "Building sandbox image.."
   sudo singularity build --sandbox nklab-${CON}-v${VER}.sandbox nklab-${CON}-def 2>&1 | tee output.txt
elif [ $1 = "full" ]
then
   echo "Performing full build..."
   sudo singularity build nklab-${CON}-v${VER}.sif nklab-${CON}-def 2>&1 | tee output.txt
else [ $1 = "convert" ]
   echo "converting sandbox to sif.."
   sudo singularity build nklab-${CON}-v${VER}.sif nklab-${CON}-v${VER}.sandbox 
fi

