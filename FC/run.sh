createMatrix.py  \
/xdisk/nkchen/chidi/xcp/fmrioutput/fmriprep/sub-cort012/ses-post/func/sub-cort012_ses-post_acq-std_task-rest_space-T1w_desc-preproc_bold_resampled.nii.gz \
/xdisk/nkchen/chidi/DTI-HIPPO/tractography/sub-cort012/sub-cort012_ses-post_aparc.HCPMMP1+aseg_nodes_T1w.nii.gz \
/xdisk/nkchen/chidi/repos/DTI-hippo/custom-pipeline/hcpmmp1_atlas/hcpmmp1_ordered.txt \
/xdisk/nkchen/chidi/nilearn/hcpmmp_func.csv \
--confound_file=/xdisk/nkchen/chidi/xcp/fmrioutput/fmriprep/sub-cort012/ses-post/func/sub-cort012_ses-post_acq-std_task-rest_desc-confounds_regressors.tsv \
--TR=3 \
--low_pass=0.08 \
--high_pass=0.0009 \
--confound_cols= ['trans_x','trans_y','trans_z', \
                                     'rot_x','rot_y','rot_z', \
                                     'a_comp_cor_00','a_comp_cor_01'] \