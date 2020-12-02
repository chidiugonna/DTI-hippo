import os
from nilearn import signal as sgl
from nilearn import image as img
from nilearn import plotting as plot
from nilearn import datasets
from nilearn import input_data
from nilearn.connectome import ConnectivityMeasure
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import bids

def extract_confounds(confound, fields ):
    confound_df = pd.read_csv(confound, delimiter='\t')
    confound_vars=fields
    confound_df = confound_df[confound_vars]
    return confound_df

parcel_file = '/xdisk/nkchen/chidi/DTI-HIPPO/tractography/sub-cort012/sub-cort012_ses-post_aparc.HCPMMP1+aseg_nodes_T1w.nii.gz'
hcpmmp1 = img.load_img(parcel_file)
hcpmmp1.shape

masker = input_data.NiftiLabelsMasker(labels_img=hcpmmp1,
                                      standardize=True,
                                      memory='nilearn_cache',
                                      verbose=1,
                                      detrend=True,
                                      low_pass = 0.08,
                                      high_pass = 0.009,
                                      t_r=3)

#singularity run $SINGIMG 3dresample -input $func -master $anat -prefix $funcnew

FUNCDIR='/xdisk/nkchen/chidi/xcp/fmrioutput/fmriprep/sub-cort012/ses-post/func/'
func_file=os.path.join(FUNCDIR,'sub-cort012_ses-post_acq-std_task-rest_space-T1w_desc-preproc_bold_resampled.nii.gz')
func_img = img.load_img(func_file)
func_img.shape
confound_file=os.path.join(FUNCDIR,'sub-cort012_ses-post_acq-std_task-rest_desc-confounds_regressors.tsv')

#Convert cnfounds file into required format
confounds = extract_confounds(confound_file,
                                 ['trans_x','trans_y','trans_z',
                                 'rot_x','rot_y','rot_z',
                                 'a_comp_cor_00','a_comp_cor_01'])
#confounds.head()
#Apply cleaning, parcellation and extraction to functional data
confounds_array=confounds.to_numpy()
time_series = masker.fit_transform(func_img,confounds_array)

correlation_measure = ConnectivityMeasure(kind='correlation')
correlation_matrix = correlation_measure.fit_transform([time_series])[0]

label_file='/xdisk/nkchen/chidi/repos/DTI-hippo/custom-pipeline/hcpmmp1_atlas/hcpmmp1_ordered.txt'
labelfile_df=pd.read_csv(label_file, header=None, usecols=[1],delim_whitespace=True, skiprows=18)

labels_array=labelfile_df.to_numpy()

np.fill_diagonal(correlation_matrix, 0)
plot.plot_matrix(correlation_matrix, figure=(10, 8), labels=labels_array,
                     vmax=0.8, vmin=-0.8, reorder=True)

hcpmmp1_df=pd.DataFrame(correlation_matrix)
hcpmmp1_df.to_csv("/xdisk/nkchen/chidi/nilearn/hcpmmp_func.csv")

# Destrieux
parcel_file = '/xdisk/nkchen/chidi/DTI-HIPPO/tractography/sub-cort012/sub-cort012_ses-post_aparc2009_nodes_T1w.nii.gz'
destrieux = img.load_img(parcel_file)

masker = input_data.NiftiLabelsMasker(labels_img=destrieux,
                                      standardize=True,
                                      memory='nilearn_cache',
                                      verbose=1,
                                      detrend=True,
                                      low_pass = 0.08,
                                      high_pass = 0.009,
                                      t_r=3)

FUNCDIR='/xdisk/nkchen/chidi/xcp/fmrioutput/fmriprep/sub-cort012/ses-pre/func/'
func_file=os.path.join(FUNCDIR,'sub-cort012_ses-pre_acq-std_task-rest_space-T1w_desc-preproc_bold_resampled.nii.gz')
func_img = img.load_img(func_file)
func_img.shape
confound_file=os.path.join(FUNCDIR,'sub-cort012_ses-pre_acq-std_task-rest_desc-confounds_regressors.tsv')

#Convert cnfounds file into required format
confounds = extract_confounds(confound_file,
                                 ['trans_x','trans_y','trans_z',
                                 'rot_x','rot_y','rot_z',
                                 'a_comp_cor_00','a_comp_cor_01'])
#confounds.head()
#Apply cleaning, parcellation and extraction to functional data
confounds_array=confounds.to_numpy()
time_series = masker.fit_transform(func_img,confounds_array)

correlation_measure = ConnectivityMeasure(kind='correlation')
correlation_matrix = correlation_measure.fit_transform([time_series])[0]

label_file='/xdisk/nkchen/chidi/repos/DTI-hippo/custom-pipeline/freesurfer_atlas/fs_a2009s.txt'
labelfile_df=pd.read_csv(label_file, header=None, usecols=[1],delim_whitespace=True, skiprows=21)
labels_array=labelfile_df.to_numpy()
np.fill_diagonal(correlation_matrix, 0)
plot.plot_matrix(correlation_matrix, figure=(10, 8), labels=labels_array,
                     vmax=0.8, vmin=-0.8, reorder=True)

hcpmmp1_df=pd.DataFrame(correlation_matrix)
hcpmmp1_df.to_csv("/xdisk/nkchen/chidi/nilearn/destrieux_pre_func.csv")