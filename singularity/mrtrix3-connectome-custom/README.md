This image is built from https://github.com/BIDS-Apps/MRtrix3_connectome

We used the commit:2f4f793a5d339f0abc03a42bc0269f4605a1b068 of Nov 17 11:13:01 2020 by Robert Smith (README: Updates for 0.5.0) to obtain the Singularity definition file and mrtrix3_connectome.py and a few other files.


The Singularity file has been modified to includethe installation of the cuda 9.1 toolbox. The altred version is available in the ./src folder and has been copied to the main folder.

We are using a modification of the mrtrix3_connectome.py that is included in the ./src directory which has 2 new flags --backup (to make a copy of the session directory for multiple parcellations) and --freesurfer-dir to prevent the running of freesurfer for subsequent parcellations. You will need to run the first parcellation with output-verbosity level of 4 and pass the `freesurfer` directory output to subsequent parcellations.

Image can bbe built as follows:

./build.sh full
