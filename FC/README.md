# Calculate Functional Connectivity Matrix

Ensure that fmriprep has been run for the subjects in question in folder **FuncPreproc**.

Also Ensure that the **custom-pipeline** Structural connectivity pipeline has been run - the structural nodes for aparc2009 and hcpmmp used for the parcellation are created as a byproduct of that pipeline.

Once these steps are complete then the functional connectivity matrix is obtained by running the following:

```
./runFC.sh
```

You will need to edit runFC.sh to specify what subjects to run the pipeline on.

This in turns calls `runAPARC.sh` and `runHCPMMP.sh` to calculate the FC for the aparc2009 and the hcpmmp1 atlases.

The following may need to changed in `runAPARC.sh` and `runHCPMMP.sh`

```
LPF=0.15    #low pass filter cutoff
HPF=0.009   #high pass filter cutoff
CONFOUNDHEADERS=${PWD}/headers.txt #the confounds to be regressed out
```

Edit the `headers.txt` file to change the confounds regressed out before FC is calculated.
