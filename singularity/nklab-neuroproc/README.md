To build the nklab-neuroproc singularity image that is used in the custom pipeline then ensure that the following two files are copied into the `src` sub-directory:

* itksnap-3.6.0-20170401-Linux-x86_64.tar.gz - which can be obtained from http://www.itksnap.org/pmwiki/pmwiki.php?n=Downloads.SNAP3
* license.txt - which is a freesurfer license that can be obtained here https://surfer.nmr.mgh.harvard.edu/fswiki/License

then the singularity image can be built as follows:

./build.sh full
