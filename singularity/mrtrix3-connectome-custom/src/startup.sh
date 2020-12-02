#!/bin/bash
########################################################## 
#  Start-up script for singularity images
##########################################################
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

opts_CheckFlagBasic() {
    sopt="$1"
    shift 1
    for fn in "$@" ; do
    if [ `echo $fn | grep -- "^${sopt}" | wc -w` -gt 0 ] ; then
        return 1
    fi
    done
    return 0
}

###########################################################
# Processing starts
IMAGE=$(head -1 /opt/bin/version*)
echo "Starting Singularity image: $IMAGE" 

#################################
# if no flag passed then print out version and help
if [ -z ${1+x} ]
then
   VERSION="True"
   HELP="True"
fi

################################
# Version 
flag="--version"
default="False"
opts_CheckFlagBasic $flag $@
FlagExists=`echo $?`
if [ $FlagExists -eq 1 ]
then  
  opts_CheckFlag $flag $@
  FlagExists=`echo $?`
  if [ $FlagExists -eq 1 ]
  then 
     VERSION=`opts_GetOpt1 $flag $@`
  else
     # flag passed but without = sign; decide what to do next
     VERSION=`opts_DefaultOpt $VERSION True`
  fi
shift 1
else
# flag wasn't passed - what do you want to do?
VERSION=`opts_DefaultOpt $VERSION $default`
fi

#################################
# Help
flag="--help"
default="False"
opts_CheckFlagBasic $flag $@
FlagExists=`echo $?`
if [ $FlagExists -eq 1 ]
then  
  opts_CheckFlag $flag $@
  FlagExists=`echo $?`
  if [ $FlagExists -eq 1 ]
  then 
     HELP=`opts_GetOpt1 $flag $@`
  else
     # flag passed but without = sign; decide what to do next
     HELP=`opts_DefaultOpt $HELP True`
  fi
shift 1
else
# flag wasn't passed - what do you want to do?
HELP=`opts_DefaultOpt $HELP $default`
fi


#################################
# Homedir 
flag="--homedir"
default="/tmp"
opts_CheckFlagBasic $flag $@
FlagExists=`echo $?`
if [ $FlagExists -eq 1 ]
then  
  opts_CheckFlag $flag $@
  FlagExists=`echo $?`
  if [ $FlagExists -eq 1 ]
  then 
     HOMEDIR=`opts_GetOpt1 $flag $@`
     if [ ! -d $WORKDIR ]
     then
       echo "--homedir $HOMEDIR doesn't exist - using $default instead"
       HOMEDIR=`opts_DefaultOpt $HOMEDIR $default`
     fi
  else
     # flag passed but without = sign; decide what to do next
     HOMEDIR=`opts_DefaultOpt $HOMEDIR $default`
  fi
shift 1
else
# flag wasn't passed - pass on default
HOMEDIR=`opts_DefaultOpt $HOMEDIR $default`
fi

#################################
# Priority 
flag="--priority"
default=""
PRIORITYPASSED="False"
opts_CheckFlagBasic $flag $@
FlagExists=`echo $?`
if [ $FlagExists -eq 1 ]
then  
  opts_CheckFlag $flag $@
  FlagExists=`echo $?`
  if [ $FlagExists -eq 1 ]
  then 
     PRIORITY=`opts_GetOpt1 $flag $@`
     PRIORITYPASSED="True" 
     echo "--priority parsed"
     if [ ! -d $PRIORITY ]
     then
       echo "--priority $PRIORITY doesn't exist - path may not be found"
     fi
  else
     # flag passed but without = sign; ignore
     echo "--priority needs an included path"
  fi
shift 1
#else
# flag wasn't passed - ignore
fi

#################################
# Retrieve 
flag="--retrieve"
default=""
cpcommand=""
RETRIEVEPASSED="False"
opts_CheckFlagBasic $flag $@
FlagExists=`echo $?`
if [ $FlagExists -eq 1 ]
then  
  opts_CheckFlag $flag $@
  FlagExists=`echo $?`
  if [ $FlagExists -eq 1 ]
  then 
     RETRIEVE=`opts_GetOpt1 $flag $@`
     if [ ! -f $RETRIEVE ]
     then
        echo "$RETRIEVE not accessible as a file"
        if [ -d $RETRIEVE ]
        then
           echo "$RETRIEVE is accessible as a directory"
           RETRIEVEPASSED="True"
           cpcommand="cp -R "
        fi
     else
        RETRIEVEPASSED="True"
        cpcommand="cp "
     fi
  else
     # flag passed but without = sign; ignore
     echo "--retrieve needs an included path"
  fi
shift 1
#else
# flag wasn't passed - ignore
fi

#################################
# SourcePre
flag="--sourcepre"
default=""
SOURCEPREPASSED="False"
opts_CheckFlagBasic $flag $@
FlagExists=`echo $?`
if [ $FlagExists -eq 1 ]
then  
  opts_CheckFlag $flag $@
  FlagExists=`echo $?`
  if [ $FlagExists -eq 1 ]
  then 
     SOURCEPRE=`opts_GetOpt1 $flag $@`
     if [ ! -f $SOURCEPRE]
     then
        echo "$SOURCEPRE not accessible as a file"
     else
        SOURCEPREPASSED="True"
     fi
  else
     # flag passed but without = sign; ignore
     echo "--retrieve needs an included path"
  fi
shift 1
#else
# flag wasn't passed - ignore
fi

#################################
# SourcePost
flag="--sourcepost"
default=""
SOURCEPOSTPASSED="False"
opts_CheckFlagBasic $flag $@
FlagExists=`echo $?`
if [ $FlagExists -eq 1 ]
then  
  opts_CheckFlag $flag $@
  FlagExists=`echo $?`
  if [ $FlagExists -eq 1 ]
  then 
     SOURCEPOST=`opts_GetOpt1 $flag $@`
     if [ ! -f $SOURCEPOST]
     then
        echo "$SOURCEPOST not accessible as a file"
     else
        SOURCEPOSTPASSED="True"
     fi
  else
     # flag passed but without = sign; ignore
     echo "--retrieve needs an included path"
  fi
shift 1
#else
# flag wasn't passed - ignore
fi


######################################
# act on flags
# --priority
if [ $PRIORITYPASSED = "True" ]
then
   export $PATH=$PRIORITY:$PATH
   echo "Current PATH shown below:"
   echo $PATH
fi

# --homedir
echo "Navigating to $HOMEDIR"
cd $HOMEDIR

# --retrieve 
if [ $RETRIEVEPASSED = "True" ]
then
   echo "copying $RETRIEVE to $PWD - you may need to use --homedir to provide an accessible current directory"
   $cpcommand $RETRIEVE $PWD
fi


# --version
if [ $VERSION = "True" ]
then
    more /opt/bin/version* 
fi

# --help
if [ $HELP = "True" ]
then
   more /opt/bin/readme*
fi

# --sourcepre
if [ $SOURCEPREPASSED = "True" ]
then
   echo "Sourcing $SOURCEPRE"
   . $SOURCEPRE
fi


######################################
# Source for freesurfer and FSL - revise this to be more flexible

# stable version of freesurfer sourced by default
export FREESURFER_HOME=/opt/freesurfer
export PATH=${FREESURFER_HOME}/bin:$PATH

# latest version of FSL sourced by default
export FSLDIR=/opt/fsl     
export FSL_DIR=/opt/fsl   
export PATH=${FSLDIR}/bin:$PATH

# Source Freesurfer and FSL
echo "Sourcing Freesurfer and FSL"
. $FREESURFER_HOME/SetUpFreeSurfer.sh
. $FSLDIR/etc/fslconf/fsl.sh

###################################
# --sourcepost
if [ $SOURCEPOSTPASSED = "True" ]
then
   echo "Sourcing $SOURCEPOST"
   . $SOURCEPOST
fi

############################################
# Run trailing command by passing on to shell
$*
