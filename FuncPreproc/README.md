# use FMRIPrep to preprocess resting stated data

This step is necessary before the functional connectivity in folder `FC` can be calculated. Just edit the line `for number in $(seq -f "%03g" 11 12)` in `run-fmriprep.sh` for sequential subjects.

If subjects are not sequential then you can use the construct below instead.

```
NUMBERS="011 012"
for number in $NUMBERS
```

You will also need a freesurfer license called `license.txt` in the current location i.e. in the same directory as ./run-fmriprep.sh


Start the pipeline as follows:

`./run-fmriprep.sh`
