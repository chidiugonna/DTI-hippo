#!/bin/bash
# working directory
WORKDIR=$PWD
#PARENTDIR=$(dirname $PWD)

PROJ=CORT
ORIGDATADIR=/xdisk/yinghuichou/${PROJ}/origdata
DATADIR=$WORKDIR/${PROJ}
subpref=cort

# general hpc job globals
EMAIL=chidiugonna@email.arizona.edu
PI=nkchen
QUEUE=standard
CPUT=10
NPROCS=20
CPUTTOTAL=$(( $CPUT * $NPROCS ))
MEMGB=5GB

#TEMPLATE FLOW DIRECTORY
#TEMPLATEFLOW=$PARENTDIR/templateflow
TEMPLATEFLOW=$WORKDIR/templateflow
mkdir -p $TEMPLATEFLOW

# pipeline global variables
FMRIPROCS=16
FMRIMEM=14400
FMRIWORKDIR=$WORKDIR/fmriworkdir
FMRIOUTPUT=$WORKDIR/fmrioutput

# pipeline global variables
SINGLOC=/xdisk/nkchen/chidi/repos/DTI-hippo/singularity/fmriprep/fmriprep-20.2.0.sif

# PBS directory
PBSDIR=$WORKDIR/PBS
mkdir -p $PBSDIR
mkdir -p $FMRIOUTPUT
mkdir -p $FMRIWORKDIR/home
mkdir -p $FMRIWORKDIR/tmp
mkdir -p $FMRIWORKDIR/work
#cp ${HOME}/license.txt $FMRIWORKDIR


# subject loop
#NUMBERS="011 012"
#for number in $NUMBERS
for number in $(seq -f "%03g" 11 12)
do
         SUB=sub-${subpref}${number}

         # copy data over and transform into more accesible form for fmriprep
         $WORKDIR/prepareData.sh $SUB $ORIGDATADIR

         # set up loop params
         JOBFILE=${PBSDIR}/fmriprep_${SUB}_${PROJ}.pbs
         JOBNAME=${SUB}_fmriprep_${PROJ}

         cp $WORKDIR/00_run-fmriprep_tplt.pbs $JOBFILE

         # general parameters
         sed -i "s#<<EMAIL>>#$EMAIL#g" $JOBFILE
         sed -i "s#<<QUEUE>>#$QUEUE#g" $JOBFILE 
         sed -i "s#<<PI>>#$PI#g" $JOBFILE
         sed -i "s#<<JOBNAME>>#$JOBNAME#g" $JOBFILE
         sed -i "s#<<NPROCS>>#$NPROCS#g" $JOBFILE
         sed -i "s#<<CPUT>>#$CPUT#g" $JOBFILE
         sed -i "s#<<CPUT_TOTAL>>#$CPUTTOTAL#g" $JOBFILE
         sed -i "s#<<MEMGB>>#$MEMGB#g" $JOBFILE
         sed -i "s#<<TEMPLATEFLOW>>#$TEMPLATEFLOW#g" $JOBFILE

	 # pipeline specific parameters
         sed -i "s#<<SUB>>#${SUB}#g" $JOBFILE
         sed -i "s#<<WORKDIR>>#${WORKDIR}#g" $JOBFILE
	     sed -i "s#<<DATADIR>>#${DATADIR}#g" $JOBFILE
	     sed -i "s#<<SINGLOC>>#${SINGLOC}#g" $JOBFILE
	     sed -i "s#<<FMRIOUTPUT>>#${FMRIOUTPUT}#g" $JOBFILE
	     sed -i "s#<<FMRIWORKDIR>>#${FMRIWORKDIR}#g" $JOBFILE
	     sed -i "s#<<FMRIMEM>>#${FMRIMEM}#g" $JOBFILE
	     sed -i "s#<<FMRIPROCS>>#${FMRIPROCS}#g" $JOBFILE

         cd $PBSDIR
         chmod +x $JOBFILE
         sbatch $JOBFILE
         cd $WORKDIR
done
