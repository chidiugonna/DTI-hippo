#!/bin/bash
#SBATCH --ntasks=28 
#SBATCH --ntasks-per-node=28 
#SBATCH --nodes=1 
#SBATCH --gres=gpu:1
#SBATCH --mem-per-cpu=5GB 
#SBATCH --time=50:00:00
#SBATCH --job-name=mrtrix3_connectome
#SBATCH --account=nkchen
#SBATCH --partition=standard

####################################
# Prepare Directories and Data for analysis
####################################
echo "mrtrix3_connectome Tractography Pipeline"
echo "Preparing Directories and Data for analysis"
########################################

SCRATCH=$SCRATCH/$SUB/$SES
mkdir -p $SCRATCH

OUTPUTDIR=$OUTPUT
BIDS=$OUTPUTDIR/CORT
mkdir -p $OUTPUTDIR
mkdir -p $BIDS
VERBOSE=4

## Prepare BIDS Data
ROOTDIR=$BIDS

if [ ! -d $ROOTDIR/sub-$SUB ] || [ ${OVERWRITE} = "True" ]
then
    echo "Copying Data from $DATADIR to $ROOTDIR in form that works with mrtrix3_connectome"
    cp -R $DATADIR/sub-$SUB $ROOTDIR 

    rm -rf $ROOTDIR/sub-$SUB/ses-$SES/anat/*
    rm -r  $ROOTDIR/sub-$SUB/ses-$SES/func
    rm -r  $ROOTDIR/sub-$SUB/ses-$SES/asl
    cp $ROOTDIR/sub-$SUB/$ANATSES/anat/sub-${SUB}_${ANATSES}_acq-nd_T1w.json $ROOTDIR/sub-$SUB/ses-$SES/anat/sub-${SUB}_ses-${SES}_T1w.json
    cp $ROOTDIR/sub-$SUB/$ANATSES/anat/sub-${SUB}_${ANATSES}_acq-nd_T1w.nii.gz $ROOTDIR/sub-$SUB/ses-$SES/anat/sub-${SUB}_ses-${SES}_T1w.nii.gz

    rm -r  $ROOTDIR/sub-$SUB/ses-pre

    RPE=$ROOTDIR/sub-$SUB/ses-$SES/misc/sub-${SUB}_ses-${SES}_acq-rpe_dwi
    dims=$(singularity exec $SINGIMG fslinfo $RPE | grep dim4 | head -1 | awk {'print $2'})

    cp ${RPE}.nii.gz $ROOTDIR/sub-$SUB/ses-$SES/dwi/sub-${SUB}_ses-${SES}_acq-rpe_dwi.nii.gz
    cp ${RPE}.json $ROOTDIR/sub-$SUB/ses-$SES/dwi/sub-${SUB}_ses-${SES}_acq-rpe_dwi.json
    cp $WORKDIR/common/${dims}.bval $ROOTDIR/sub-$SUB/ses-$SES/dwi/sub-${SUB}_ses-${SES}_acq-rpe_dwi.bval
    cp $WORKDIR/common/${dims}.bvec $ROOTDIR/sub-$SUB/ses-$SES/dwi/sub-${SUB}_ses-${SES}_acq-rpe_dwi.bvec

else
    echo "sub-$SUB already prepared"
fi

####################################
# MAIN Program starts here
TOTALDURATION=0
####################################
# Start Timing Block for Profiling
####################################
PREVSECS=$SECONDS
SECONDS=0
STARTTIME=$(date)
STEP=preproc
echo "mrtrix3_connectome Tractography Pipeline"
echo "Running step: $STEP"
echo "script start time: " $STARTTIME
########################################

if [ ! -d $OUTPUT/MRtrix3_connectome-preproc/sub-$SUB/ses-$SES ] || [ ${OVERWRITE} = "True" ]
then
   options="--participant_label=$SUB --session_label=$SES --skip-bids-validator --output_verbosity=$VERBOSE --scratch=$SCRATCH"
   analysis_level="preproc"
   singularity run --nv -B ${BIDS}:/mnt -B ${OUTPUTDIR}:/media ${SINGIMG} --homedir=$WORKDIR /src/mrtrix3_connectome.py /mnt /media $analysis_level ${options}
else
   echo "$STEP already run."
fi

#####################
# End Timing Block
#####################
echo "script start time was: $STARTTIME"
ENDTIME=$(date)
echo "script end time for $STEP is: $ENDTIME"
echo
duration=$SECONDS
TOTALDURATION=$(( duration + TOTALDURATION ))
echo "Time elapsed  for $STEP is $duration seconds."
echo "Time elapsed for $STEP is $(($duration / 60)) minutes and $(($duration % 60))."
echo "Time elapsed  for total pipeline is $TOTALDURATION seconds."
echo "Time elapsed for total preproc is $(($TOTALDURATION / 60)) minutes and $(($TOTALDURATION % 60))."

#------------------------------------------------------------------------------------------------------------

####################################
# Start Timing Block for Profiling
####################################
PREVSECS=$SECONDS
SECONDS=0
STARTTIME=$(date)
STEP="hcpmmp1 parcellation"
echo "mrtrix3_connectome Tractography Pipeline"
echo "Running step: $STEP"
echo "script start time: " $STARTTIME
########################################

PARCEL=hcpmmp1
options="--participant_label=$SUB --session_label=$SES --skip-bids-validator --output_verbosity=$VERBOSE --scratch=$SCRATCH"
parcellation="--parcellation=$PARCEL"
analysis_level="participant"
singularity run --nv -B ${BIDS}:/mnt -B ${OUTPUTDIR}:/media ${SINGIMG} --homedir=$WORKDIR /src/mrtrix3_connectome.py /mnt /media $analysis_level ${options} ${parcellation}

#####################
# End Timing Block
#####################
echo "script start time was: $STARTTIME"
ENDTIME=$(date)
echo "script end time for $STEP is: $ENDTIME"
echo
duration=$SECONDS
TOTALDURATION=$(( duration + TOTALDURATION ))
echo "Time elapsed  for $STEP is $duration seconds."
echo "Time elapsed for $STEP is $(($duration / 60)) minutes and $(($duration % 60))."
echo "Time elapsed  for total pipeline is $TOTALDURATION seconds."
echo "Time elapsed for total preproc is $(($TOTALDURATION / 60)) minutes and $(($TOTALDURATION % 60))."
#------------------------------------------------------------------------------------------------------------

####################################
# Start Timing Block for Profiling
####################################
PREVSECS=$SECONDS
SECONDS=0
STARTTIME=$(date)
STEP="destrieux parcellation"
echo "mrtrix3_connectome Tractography Pipeline"
echo "Running step: $STEP"
echo "script start time: " $STARTTIME
########################################

NEWDIR=$(ls -d $SCRATCH/*/freesurfer)
if [ ! -z ${NEWDIR+x} ]
then
   FREEDIR=$NEWDIR
fi

PARCEL=destrieux
options="--participant_label=$SUB --session_label=$SES --skip-bids-validator --output_verbosity=$VERBOSE --scratch=$SCRATCH --freesurfer-dir=$FREEDIR --backup"
parcellation="--parcellation=$PARCEL"
analysis_level="participant"
singularity run --nv -B ${BIDS}:/mnt -B ${OUTPUTDIR}:/media ${SINGIMG} --homedir=$WORKDIR /src/mrtrix3_connectome.py /mnt /media $analysis_level ${options} ${parcellation}

#####################
# End Timing Block
#####################
echo "script start time was: $STARTTIME"
ENDTIME=$(date)
echo "script end time for $STEP is: $ENDTIME"
echo
duration=$SECONDS
TOTALDURATION=$(( duration + TOTALDURATION ))
echo "Time elapsed  for $STEP is $duration seconds."
echo "Time elapsed for $STEP is $(($duration / 60)) minutes and $(($duration % 60))."
echo "Time elapsed  for total pipeline is $TOTALDURATION seconds."
echo "Time elapsed for total preproc is $(($TOTALDURATION / 60)) minutes and $(($TOTALDURATION % 60))."
#------------------------------------------------------------------------------------------------------------
## END
echo "-------------------------------------------------------------------------------------"
echo "Script completed."






