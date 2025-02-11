
% Developed by Anna Chaiken (MSc)
% Data Analyst
% Stanford University - Brain Stimulation Lab
% AUGUST 2023

% File type is assumed .set (EEGLAB data structure). Folder structure
% should be a singular directory containing all relevant recordings.

% This script saves a csv with output. The output is the mean 
% PAF/IAF for the recording. This is calculated by averaging across the 
% channels of interest.

%% Housekeeping
clear
close all 

%% Main Script

% Parameters
channels = [2 34 35 62]; %frontal ROI
num_chans = length(channels);

inpt = [];
inpt.fmin = 7; % lower bound of frequency range in Hz
inpt.fmax = 14; % upper bound of frequency range in Hz
inpt.samplingrate = 1000; % in Hz
inpt.winsize = 2; % in seconds (for pwelch)
inpt.overlap = 1; % in seconds (for pwelch)
inpt.pafmethod = "peak"; % use 'max' or 'peak' method to estimate PAF

pwd
files = dir('*.set');

for f = 1:size(files,1)
    EEG = pop_loadset(files(f).name);
    channel_names = {EEG.chanlocs.labels};

    PAF_allchans = zeros(1,num_chans);
    IAF_allchans = zeros(1,num_chans);
    spectra = zeros(size(files,1), num_chans);

    for c = 1:num_chans
        [PAF, IAF, spectra, freqs] = compute_IAFandPAF(inpt, channels(c), EEG);

        PAF_allchans(c) = PAF;
        IAF_allchans(c) = IAF;
        spectra_allchans(c, :) = spectra;
    end
        
    PAF_nan = sum(isnan(PAF_allchans));
    channel_nums_nan = find(isnan(PAF_allchans) == 1);
    channel_names_nan = channel_names(channels(channel_nums_nan));
    PAF_allchans_nonan = PAF_allchans(~isnan(PAF_allchans));
    IAF_allchans_nonan = IAF_allchans(~isnan(IAF_allchans));

    PAF_allchans = PAF_allchans_nonan;
    IAF_allchans = IAF_allchans_nonan;

    df_PAFIAF(f).fname = files(f).name;
    df_PAFIAF(f).PAF = mean(PAF_allchans);
    df_PAFIAF(f).IAF= mean(IAF_allchans);
    df_PAFIAF(f).nanChans = channel_names_nan;
    df_PAFIAF(f).spectra = {mean(spectra_allchans,1)};
end

dfT = struct2table(df_PAFIAF);
writetable(dfT(:,1:end-1),'IAFPAF-OUTPUT.csv');



        