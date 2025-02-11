
# IAFPAF

This code was developed for resting-state EEG data (rsEEG) that have been processed in EEGLab. The code assumes that files are in .set format and that the EEGLab toolbox is installed (https://sccn.ucsd.edu/eeglab/).

The compute_IAFandPAF.m function reads in an EEGLab data structure and a single channel index and returns the Peak Alpha Frequency (PAF) and Individual Alpha Freuency (IAF) of the defined alpha band for that channel. The user may adjust the upper and lower limits of the alpha band.

power spectra: computed via the spectopo() EEGLab function

PAF: computed using the findpeaks() MATLAB function

IAF: computed using the center of gravity approach (Klimesch 1999)

An example of how to run the compute_IAFandPAF.m function is provided in the Demo Script.
