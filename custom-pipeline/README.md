# Custom pipeline for creating connectivity matrices

This pipeline is based on Mrtrix3 (v3.0.2). All steps for the pipeline are contained in the script `createMatrix.sh`.
To run this pipeline you will need to pass a singularity image that contains mrtrix, FSL , ANTS and Freesurfer installed.

Pipeline assumes that data is in BIDS format and that freesurfer `recon-all` has previously been run. The Freesurfer references ($FREEDIR, $FREESURF) are unfortunately hardcoded into the main script `createMatrix.sh` for now. 

# steps for using Pipeline on PUMA

## submit as a batch job
This is the way to process each subject initially as the initial pipeline takes a reasonably long time (approx 10 hrs or so).

Open the script `submit-job.sh` and:
1. Confirm that the variables are correctly set. You should not need to change any values here if you want it to work using default settings.
   `WORKDIR` is used to create the output location at `$WORKDIR/tractography/$SUB`
   You can set `OVERWRITE` to `True` if you want to run the script a second time on the same subject.
   Keep `VIEWIMG` as `False` as you won't be able to view images when running as a batch script.
   
2. In the script  change the for loop to process the subjects you are interested in.
   For example `for number in $(seq -f "%03g" 12 12)` runs **only** subject 12
   and `for number in $(seq -f "%03g" 10 12)` runs subjects 10,11 and 12.
   For non-sequential subject numbers you will need to use a construct as follows
   
   ```
   for num in 1 2 4 5 9 10
   do number=$(printf "%0*d" 3 $num)

   ```

run as `./submit-job.sh`

## run as an interactive job
This is the way to run the pipeline after the initial run. Setting the parameter `--viewimg="True"` will display completed images for quality control purposes.
Open the script run-direct.sh and change --sub="sub-????"` to point to the subject you previously ran. Ensure that all other locations (--datadir etc) match the values you had in `submit-run.sh`.

run  as `./run-direct.sh`

## Debug mode
You can run the script in debug mode by sourcing the `setvars.sh` script as follows:

```
. ./setvars.sh
```

This will not running any of the commands but wil make all the variables in the script `createMatrix.sh` available to you so that you can run individual commands.



