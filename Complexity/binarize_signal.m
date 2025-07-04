% Developed by Anna Chaiken (MSc)
% Data Analyst
% Stanford University - Brain Stimulation Lab
% 2024
%
% INPUT: 3D matrix representing EEG signal envelope (channels x samples x epochs)
% and binarization method ('mean' or 'median).
%
% OUTPUT: 3D matrix representing EEG signal binarized 

function [binary_data] = binarizeSig(env,binmethod)

S_length = size(env,3); % 3rd dimension: SEGMENTS (e.g. epochs)
M_length = size(env,2); % 2nd dimension: OBSERVATIONS (e.g. samples)
N_length = size(env,1); % 1st dimension: SOURCES (e.g. channels)

binary_data = zeros(size(env));

switch binmethod
    case 'mean'
        N_mean = reshape(mean(env,2), N_length, S_length); %calculates mean for each channel in each segment
        %N_mean = mean(reshape(env, N_length, M_length*S_length),2); % returns the mean value for each channel. across entire recording.

        % Binarize each source/segment by thresholds (ti) stored in N_mean
        for s=1:S_length %loop segments

            for n=1:N_length %loop sources
                ti = N_mean(n,s);

                for m=1:M_length %loop samples
                    if env(n,m,s) < ti
                        binary_data(n,m,s) = 0; % if less than mean = 0
                    else
                        binary_data(n,m,s) = 1; % if more than mean = 1
                    end
                end
            end
        end

    case 'median'
        N_med = reshape(median(env,2), N_length, S_length); %calculates median for each channel in each segment
        %N_med = median(reshape(env, N_length, M_length*S_length),2); % returns the median value for each channel. across entire recording.

        % Binarize each source/segment by thresholds (ti) stored in Nmean
        for s=1:S_length %loop segments

            for n=1:N_length %loop sources
                ti = N_med(n,s);

                for m=1:M_length %loop samples
                    if env(n,m,s) < ti
                        binary_data(n,m,s) = 0; % if less than mean = 0
                    else
                        binary_data(n,m,s) = 1; % if more than mean = 1
                    end
                end
            end
        end

    otherwise
        error('Undefined binarization method. Use either ''median'' or ''mean''');
end

end