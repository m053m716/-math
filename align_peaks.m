function X_a = align_peaks(X, n_pre, n_post)
%ALIGN_PEAKS Assort channel data by vertically centering channels
% according to the local peak closest to stim event rather than the stim event.
%
% Syntax:
%   X_a = math.align_peaks(X, n_pre, n_post);
%
% Inputs:
%   X        - double array containing the averaged segmented data (for the EMG grid)
%   n_pre    - Number of preceding samples.
%   n_post   - Number of samples after
%
% Output:
%   X_a      - double array where the max peak for each channel has been
%               aligned to n_pre index
%
% See also: Contents

if nargin < 3
    n_post = 70; 
end

[M,N] = size(X);
X_a = zeros(M,N);

% Find index of peaks for each channel
[~, idx] = max(X(:,1:n_pre+n_post),[],2);

for i=1:M
    dif = n_pre-idx(i);
    if dif > 0
        % Add zeros at beginning and trim end 
        X_a(i,:) = [repelem(0,dif),X(i,1:end-dif)];
    else
        % trim beginning, at zeros at end
        X_a(i,:) = [X(i,abs(dif)+1:end),repelem(0,abs(dif))];
    end
end


end

