#!/bin/bash
###########################
# Helper Functions
##########################
# opts_GetOpt1() is copied from HCPpipelines - https://raw.githubusercontent.com/Washington-University/HCPpipelines/master/global/scripts/opts.shlib
opts_GetOpt1() {
    sopt="$1"
    shift 1
    for fn in "$@" ; do
    if [ `echo $fn | grep -- "^${sopt}=" | wc -w` -gt 0 ] ; then
        echo "$fn" | sed "s/^${sopt}=//"
        return 0
    fi
    done
}

opts_DefaultOpt() {
    echo $1
}

opts_CheckFlag() {
    sopt="$1"
    shift 1
    for fn in "$@" ; do
    if [ `echo $fn | grep -- "^${sopt}=" | wc -w` -gt 0 ] ; then
        return 1
    fi
    done
    return 0
}

#####################################

pause () {
   read -p "Press any key to continue"
}

parseparams() {
###################################
# Parse Input Parameters
####################################

# Obtain the subject
flag="--sub"
default="sub-01"
opts_CheckFlag $flag $@
FlagExists=`echo $?`
if [ $FlagExists -eq 1 ]
then
SUB=`opts_GetOpt1 $flag $@`
echo $flag passed, parsed as $SUB
else
if [ -z ${SUB+x} ]; then echo "$flag not passed, will use default value $default"; else echo "$flag already set to '$SUB'"; fi
SUB=`opts_DefaultOpt $SUB $default`
fi
echo "Processing about to begin for subject $SUB"
export SUB

# Obtain the session
flag="--ses"
default="ses-post"
opts_CheckFlag $flag $@
FlagExists=`echo $?`
if [ $FlagExists -eq 1 ]
then
SES=`opts_GetOpt1 $flag $@`
echo $flag passed, parsed as $SES
else
if [ -z ${SES+x} ]; then echo "$flag not passed, will use default value $default"; else echo "$flag already set to '$SES'"; fi
SES=`opts_DefaultOpt $SES $default`
fi
echo "Processing to be done on session $SES"
export SES

# Obtain the anatomical session
flag="--anatses"
default="ses-pre"
opts_CheckFlag $flag $@
FlagExists=`echo $?`
if [ $FlagExists -eq 1 ]
then
ANATSES=`opts_GetOpt1 $flag $@`
echo $flag passed, parsed as $ANATSES
else
if [ -z ${ANATSES+x} ]; then echo "$flag not passed, will use default value $default"; else echo "$flag already set to '$ANATSES'"; fi
ANATSES=`opts_DefaultOpt $ANATSES $default`
fi
echo "Using Anatomical Session $ANATSES"
export ANATSES

# Obtain the working directory
flag="--workdir"
default="/home/u8/chidiugonna/HPCWORKSHOP/DOESNTEXIST"
opts_CheckFlag $flag $@
FlagExists=`echo $?`
if [ $FlagExists -eq 1 ]
then
WORKDIR=`opts_GetOpt1 $flag $@`
echo $flag passed, parsed as $WORKDIR
else
if [ -z ${WORKDIR+x} ]; then echo "$flag not passed, will use default value $default"; else echo "$flag already set to '$WORKDIR'"; fi
WORKDIR=`opts_DefaultOpt $WORKDIR $default`
fi
echo "Using working directory $WORKDIR"
if [ ! -d $WORKDIR ]
then
  echo "$WORKDIR doesn't exist - please pass a valid Working directory"
  exit 1
fi
export WORKDIR

# Obtain the data directory
flag="--datadir"
default="/home/u8/chidiugonna/HPCWORKSHOP/DATADIRDOESNTEXIST"
opts_CheckFlag $flag $@
FlagExists=`echo $?`
if [ $FlagExists -eq 1 ]
then
DATADIR=`opts_GetOpt1 $flag $@`
echo $flag passed, parsed as $DATADIR
else
if [ -z ${DATADIR+x} ]; then echo "$flag not passed, will use default value $default"; else echo "$flag already set to '$DATADIR'"; fi
DATADIR=`opts_DefaultOpt $DATADIR $default`
fi
echo "Using data directory $DATADIR"
if [ ! -d $DATADIR ]
then
  echo "$DATADIR doesn't exist - please pass a valid data directory"
  exit 1
fi
export DATADIR

# Obtain the singularity image location
# module load singularity -  Not needed on PUMA
flag="--singimg"
default="/xdisk/nkchen/singularity3-images/nklab-neuroproc-v0.2.sif"
opts_CheckFlag $flag $@
FlagExists=`echo $?`
if [ $FlagExists -eq 1 ]
then
SINGIMG=`opts_GetOpt1 $flag $@`
echo $flag passed, parsed as $SINGIMG
else
if [ -z ${SINGIMG+x} ]; then echo "$flag not passed, will use default value $default"; else echo "$flag already set to '$SINGIMG'"; fi
SINGIMG=`opts_DefaultOpt $SINGIMG $default`
fi
echo "Using Singularity Image $SINGIMG"
if [ ! -f $SINGIMG ]
then
  echo "$SINGIMG doesn't exist - please pass a valid singularity image"
  exit 1
fi
export SINGIMG

# View data after each step - for interactive analysis
flag="--viewimg"
default="False"
VIEWIMG=`opts_GetOpt1 $flag $@`
VIEWIMG=`opts_DefaultOpt $VIEWIMG $default`
echo "View Image Flag set to $VIEWIMG"
export VIEWIMG

# debug flag
flag="--debug"
default="False"
DEBUG=`opts_GetOpt1 $flag $@`
DEBUG=`opts_DefaultOpt $DEBUG $default`
echo "Debug Flag set to $DEBUG"
export DEBUG

# overwrite data if it already exists
flag="--overwrite"
default="False"
OVERWRITE=`opts_GetOpt1 $flag $@`
OVERWRITE=`opts_DefaultOpt $OVERWRITE $default`
echo "Overwrite Image Flag set to $OVERWRITE"
if [ ${OVERWRITE} = "True" ]
then
   FORCE="-force"
else
   FORCE=""
fi
export OVERWRITE

# Obtain the output directory
flag="--output"
default="$WORKDIR/tractography/$SUB"
opts_CheckFlag $flag $@
FlagExists=`echo $?`
if [ $FlagExists -eq 1 ]
then
OUTPUT=`opts_GetOpt1 $flag $@`
echo $flag passed, parsed as $OUTPUT
else
if [ -z ${OUTPUT+x} ]; then echo "$flag not passed, will use default value $default"; else echo "$flag already set to '$OUTPUT'"; fi
OUTPUT=`opts_DefaultOpt $OUTPUT $default`
fi
echo "Using output directory $OUTPUT/tractography/$SUB"
export OUTPUT=$OUTPUT/tractography/$SUB

WORK=$OUTPUT/work
echo "Using work directory $WORK"
export WORK
}

