# Calculate structural connectivity using mrtrix3_connectome bids app

## Configure submit_parcel.sh

simply edit `submit_parcel.sh` to process the subjects you want:

If the subjects are sequential then just use the following
    ```
    for number in $(seq -f "%03g" 11 12)
    do
    ```

for non-sequential subjects then either do this
   ```
   for num in 1 2 4 5 9 10
   do number=$(printf "%0*d" 3 $num)

   ```

or this

   ```
   NUMBER="001 002 004 005 009 010"
   for number in $NUMBER
   do

   ```

### configure do-connectome.sh
Main change to make here is to ensure that the SBATCH parameters are set correctly. You will nneed to make sure that the --account parameter is set properly to reflect your group. Otherwise defaults below should work well on Puma.

```
#SBATCH --ntasks=28 
#SBATCH --ntasks-per-node=28 
#SBATCH --nodes=1 
#SBATCH --gres=gpu:1
#SBATCH --mem-per-cpu=5GB 
#SBATCH --time=50:00:00
#SBATCH --job-name=mrtrix3_connectome
#SBATCH --account=nkchen
#SBATCH --partition=standard
```

## Run the pipeline

Simple do `./submit_parcel.sh`


## Outputs

The folder ./output/CORT contains a restructured form or the original data which is adapted to work with the pipeline.

The connectomes are created in ./output/MRtrix3_connectome-participant/$SUB/$SES*****/connectome/*_connectome.csv

The folder ./output/MRtrix3_connectome-preproc contains the preprocessed DWI data.




