# Calculate structural connectivity using mrtrix3_connectome bids app

## Configure 

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


## Run the pipeline

Simple do `./submit_parcel.sh`
