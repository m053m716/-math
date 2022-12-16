function [X,Y] = data_2_pls_format(data, varargin)
%DATA_2_PLS_FORMAT  Convert data from data cell struct to [X,Y] used in plsregress.
%
% Syntax:
%   [X,Y] = math.data_2_pls_format(data);
%
% Inputs:
%   data - Data cell struct
%
% Output:
%   X - Predictors matrix. Rows are observations, columns are variables.
%   Y - Responses matrix. Rows are observations, columns are variables.
%
% See also: Contents

pars = struct;
pars.MovVarWindow = 200; % Samples for computing moving variance window

pars = utils.parse_parameters(pars, varargin{:});


dx = diff(data.x,1,1);
dy = diff(data.y,1,1);
Y = [data.x', dx', data.y', dy'];

a = data.uni;
b = movvar(zscore(a, 0, 2), pars.MovVarWindow, 0, 2);

nSamples = size(b,2);
nChannels = size(b,1);
nTrials = size(b,3);

X = nan(nTrials, nChannels * nSamples);
for ii = 1:nTrials
    vec = 1:nSamples;
    for ik = 1:nChannels
        X(ii, vec) = b(ik, :, ii);
        vec = vec + nSamples;
    end
end

end