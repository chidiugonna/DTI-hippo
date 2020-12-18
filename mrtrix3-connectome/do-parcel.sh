#!/bin/bash
#SBATCH --ntasks=28 
#SBATCH --ntasks-per-node=28 
#SBATCH --nodes=1 
#SBATCH --gres=gpu:1
#SBATCH --mem-per-cpu=5GB 
#SBATCH --time=50:00:00
#SBATCH --job-name=017-connectome
#SBATCH --account=nkchen
#SBATCH --partition=standard


####################################
# Start Timing Block for Profiling
####################################
PREVSECS=$SECONDS
SECONDS=0
STARTTIME=$(date)
echo "mrtrix3_connectome Tractography Pipeline"
echo "script start time: " $STARTTIME
########################################

BIDS=$WORKDIR/CORT
OUTPUTDIR=$WORKDIR/output
mkdir -p $OUTPUTDIR
VERBOSE=4

options="--participant_label=$SUB --session_label=$SES --skip-bids-validator --output_verbosity=$VERBOSE --freesurfer-dir=$FREEDIR --backup"
parcellation="--parcellation=$PARCEL"
analysis_level="participant"
#echo singularity run --nv -B ${BIDS}:/mnt -B ${OUTPUTDIR}:/media ${SINGIMG} /src/mrtrix3_connectome.py /mnt /media $analysis_level ${options} ${parcellation}
# remove -B $WORKDIR/src:/src just for debugging
#singularity run --nv -B ${BIDS}:/mnt -B $WORKDIR/src:/src -B ${OUTPUTDIR}:/media ${SINGIMG} --homedir=$WORKDIR /src/mrtrix3_connectome.py /mnt /media $analysis_level ${options} ${parcellation}

echo singularity run --nv -B ${BIDS}:/mnt -B ${OUTPUTDIR}:/media ${SINGIMG} --homedir=$WORKDIR /src/mrtrix3_connectome.py /mnt /media $analysis_level ${options} ${parcellation}
singularity run --nv -B ${BIDS}:/mnt -B ${OUTPUTDIR}:/media ${SINGIMG} --homedir=$WORKDIR /src/mrtrix3_connectome.py /mnt /media $analysis_level ${options} ${parcellation}

#####################
# End Timing Block
#####################
echo "script start time for destrieux was: $STARTTIME"
ENDTIME=$(date)
echo "script end time for destrieux is: $ENDTIME"
echo
duration3=$SECONDS
echo "Time elapsed is $duration3 seconds."
echo "Time elapsed is $(($duration3 / 60)) minutes and $(($duration3 % 60))."
#------------------------------------------------------------------------------------------------------------



## TOTAL
echo "-------------------------------------------------------------------------------------"
echo "TOTAL run:"
echo 
duration=$((duration1 + duration2 + duration3 ))
echo "Total Time elapsed is $duration seconds."
echo "Total Time elapsed is $(($duration / 60)) minutes and $(($duration % 60))."





