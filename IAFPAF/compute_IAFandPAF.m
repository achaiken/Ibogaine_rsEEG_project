
% Developed by Anna Chaiken (MSc)
% Data Analyst
% Stanford University - Brain Stimulation Lab
% AUGUST 2023

% Compute PAF (Peak alpha) and IAF (center of gravity method). This
% function requires the EEGlab tolbox. 
%
% INPUT
%   inpt (type: structure)
%       .fmin -- bottom of frequency range in Hz
%       .fmax -- top of frequency range in Hz
%       .samplingrate -- sampling rate in Hz
%       .winsize -- size of window in seconds
%       .overlap -- length of overlap in seconds
%       .pafmethod -- determines how PAF is calculated ('max' or 'peak': Peak is more accurate and recommended)
%
%   channel (type: numeric) -- index of a channel. Handles single channels only. 
%
%   EEG (type: EEGLab Structure) -- EEGlab structure
%
% OUTPUT
%   PAF (type: numeric) -- The peak frequency of the defined band
%   IAF (type: numeric) -- The dominant frequency of the defined band using
%                          the center of gravity method (Klimesch 1999). 
%
%                               Equation: (sum((power1*f1),(power2*f2))/(sum(power1, power2))
% 
%                          power = spectral value at given frequeny
%                          f = frequency in Hz
%                          1 & 2 = the band min and max
%
%   spectra (type: numeric array) -- The power spectrum of the specified
%                                channel
%
function [PAF, IAF_cog, spectra, freqs] = compute_iaf(inpt, channel, EEG)
    
    fmin = inpt.fmin;                
    fmax = inpt.fmax;                
    sr = inpt.samplingrate;         
    winsize = inpt.winsize * sr;     
    overlap = inpt.overlap * sr;     
    freqres = 1/inpt.winsize;        
    
    % get log PSD spectra of specific channel in EEG data
    [spectra_psd,freqs] = spectopo(EEG.data(channel,:,:), 0, sr, 'winsize', winsize, 'overlap', overlap, 'limits', [0 25 nan nan nan nan], 'plot', 'off');
    spectra_abs = 10.^(spectra_psd/10); %absolute power 
    spectra = spectra_abs; 

    % extract frequency indices and spectra of interest
    freq_idx = find(freqs>=fmin & freqs<=fmax);
    
    % Equation handle for center of gravity (cog) frequency estimation.
    cog_handle = @(f, psd) (sum(psd.*f))/(sum(psd));


    switch inpt.pafmethod
        
        % 'max' returns the index of the maximum value in the spectrum. NOT RECOMMENDED. 
        case 'max'
            spectra_band = spectra(freq_idx);
            PAF_idx = find(spectra==max(spectra_band));
            PAF = freqs(PAF_idx);
            IAF_cog = cog_handle([fmin:freqres:fmax], spectra_band);
        
        % 'peak' uses the findpeaks function to identify peaks and returns the index of the highest peak. 
        % If no peak is found in the spectrum PAF is assigned a value of NaN
        case 'peak'
            spectra_band = spectra([freq_idx(1)-1:freq_idx(end)+1]); %psd +/- a bin to accuratley estimate peak
            PAF_peaks = findpeaks(spectra_band);

            if isempty(PAF_peaks) == 0
                PAF_idx = find(spectra==max(PAF_peaks));
                PAF = freqs(PAF_idx);
                IAF_cog = cog_handle([fmin:freqres:fmax], spectra(freq_idx));
            else
                PAF = NaN;
                IAF_cog = NaN;
            end
    end

    
