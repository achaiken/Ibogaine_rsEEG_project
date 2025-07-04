% Code shared in Schartner et al., 2015 was adapted from python -> matlab
% https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0133532

% INPUT: A 1D binary string (e.g., '100010101')
%
% OUTPUT: The dictionary of unique elements and the size of the dictionary
% as computed by method of Lempel-Ziv-Welch.

function [dict, len]=compute_LZcomplexity(binarystr)

kstr = binarystr;

dict = {}; 
w = [];
i = 1;
for c=1:length(kstr)
    wc = [w kstr(c)];

    if sum(ismember(dict, wc)) >= 1 %if dict already contains pattern update w
        w = wc;

    else %else add pattern to dict and increase the counter
        dict{i}=wc;
        w = kstr(c);
        i = i + 1;
    end
end

len = length(dict);