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

def logtext(logfile, textstr):
    stamp=datetime.datetime.now().strftime("%m-%d-%y %H:%M:%S%p")
    textstring=stamp + '  ' + str(textstr)
    print(textstring)
    logfile.write(textstring+'\n')

def get_parser():
    from argparse import ArgumentParser
    from argparse import RawTextHelpFormatter

    parser = ArgumentParser(description="Create FC connection Matrix using nilearn."
        "fMRI data should have been processed by fmriprep and should be in same space as parcellation file.",formatter_class=RawTextHelpFormatter)
    parser.add_argument('func_file', action='store',
        help='The functional MRI as a  NIFTI. Processed by fMRIprep.')
    parser.add_argument('parcel_file', action='store',
        help='The parcellation as a NIFTI used to define nodes in matrix. Should be in the same space as functional MRI.')
    parser.add_argument('label_file', action='store',
        help='label file for parcellation')
    parser.add_argument('output_file', action='store',
        help='output file ')
    parser.add_argument('--confound_file', action='store',
        help='Confound file created by fMRIprep.')
    parser.add_argument('--confound_cols', action='store',type=str, nargs='*',
        help='Confound columns to use')
    parser.add_argument('--workdir', action='store',
        help='Work directory for output of log file and other temporary files')
    parser.add_argument('--logname', action='store',
        help='name for the log file (without extension) which will be created in work directory.')
    parser.add_argument('--TR', action='store',
        help='Repetition Time of functional in seconds.')
    parser.add_argument('--high_pass', action='store',
        help='High pass frequency in Hz.')
    parser.add_argument('--low_pass', action='store',
        help='Low pass frequency in Hz.')


def main():

    opts = get_parser().parse_args()

    # work directory
    if opts.workdir:
        WORKDIR=os.path.abspath(opts.workdir)
    else:
        WORKDIR=os.getcwd()

    # log name
    if opts.logname:
        BASELOGNAME=opts.logname
    else:
        BASELOGNAME='createFCMatrix' 

    # create log file 
    TIMESTAMP=datetime.datetime.now().strftime("%m%d%y%H%M%S%p")
    LOGFILENAME=BASELOGNAME + '_' + TIMESTAMP + '.log'
    LOGFILE = open(os.path.join(WORKDIR,LOGFILENAME), 'w')

    # functional MRI
    func_file=os.path.abspath(opts.func_file)
    parcel_file=os.path.abspath(opts.parcel_file)
    label_file=os.path.abspath(opts.label_file)
    
    parcel = img.load_img(parcel_file)
    logtext(LOGFILE,"parcellation "+parcel_file + " has dimensions " + str(parcel.shape)
    
    if opts.confound_file:
        confound_file=os.path.abspath(opts.confound_file)
    
    # Repetition Time
    if opts.TR:
        TR=opts.TR
        logtext(LOGFILE,"Repetition Time passed is " + str(TR) + " seconds"
    else:
         logtext(LOGFILE,"No repetition time passed. This is necessary for filtering."

    # high pass 
    if opts.high_pass:
        high_pass=opts.high_pass
        logtext(LOGFILE,"High pass cutoff " + str(high_pass) + " Hz"
    else:
         logtext(LOGFILE,"No high pass filter passed. This is necessary for filtering."

    # work directory
    if opts.low_pass:
        low_pass=opts.low_pass
        logtext(LOGFILE,"Low pass cutoff is " + str(low_pass) + " Hz"
    else:
         logtext(LOGFILE,"No low pass filter passed. This is necessary for filtering."
    
    masker = input_data.NiftiLabelsMasker(labels_img=parcel,
                                          standardize=True,
                                          memory='nilearn_cache',
                                          verbose=1,
                                          detrend=True,
                                          low_pass=low_pass,
                                          high_pass=high_pass,
                                          t_r=TR)
    
    func_img = img.load_img(func_file)
    logtext(LOGFILE,"func_file "+parcel_file + " has dimensions " + str(func_img.shape)

    
    #Convert cnfounds file into required format
    confounds = extract_confounds(confound_file,
                                    confound_cols)
    #confounds.head()
    #Apply cleaning, parcellation and extraction to functional data
    confounds_array=confounds.to_numpy()
    time_series = masker.fit_transform(func_img,confounds_array)
    
    correlation_measure = ConnectivityMeasure(kind='correlation')
    correlation_matrix = correlation_measure.fit_transform([time_series])[0]
    
    labelfile_df=pd.read_csv(label_file, header=None, usecols=[1],delim_whitespace=True, skiprows=18)
    
    labels_array=labelfile_df.to_numpy()
    
    np.fill_diagonal(correlation_matrix, 0)
    plot.plot_matrix(correlation_matrix, figure=(10, 8), labels=labels_array,
                         vmax=0.8, vmin=-0.8, reorder=True)
    
    parcel_df=pd.DataFrame(correlation_matrix)
    parcel_df.to_csv(output_file,index=False, header=False)
    

# This is the standard boilerplate that calls the main() function.
if __name__ == '__main__':
    main()