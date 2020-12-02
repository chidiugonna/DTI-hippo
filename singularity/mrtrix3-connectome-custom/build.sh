#!/bin/bash
CON=mrtrix3_connectome
VER=`cat ./src/version | grep version | awk {'print $2'}`
if [ -z ${1+x} ]
then 
    echo  "Specify sandbox, full or convert" 
elif [ $1 = "sandbox" ]
then
   echo  "Building sandbox image.."
   sudo singularity build --sandbox ${CON}-v${VER}.sandbox Singularity 2>&1 | tee output.txt
elif [ $1 = "full" ]
then
   echo "Performing full build..."
   sudo singularity build ${CON}-v${VER}.sif Singularity 2>&1 | tee output.txt
else [ $1 = "convert" ]
   echo "converting sandbox to sif.."
   sudo singularity build ${CON}-v${VER}.sif ${CON}-v${VER}.sandbox 
fi

