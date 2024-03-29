function [A, X, triggers,vec] = triggered_average(triggers, x, n_pre, n_post, rectify, do_smooth, align_peaks)
%TRIGGERED_AVERAGE  Computes triggered average from samples in vector x
%
% Syntax:
%   [A, X] = math.triggered_average(triggers, x, n_pre, n_post, ...
%               rectify, do_smooth, align_peaks);
%
% Inputs:
%   triggers -- Vector of samples to use as triggers
%   x        -- Data vector
%   n_pre    -- Number of samples before the trigger
%   n_post   -- Number of samples after the trigger
%   rectify  -- Apply rectification to individual data (prior to average)
%   do_smooth -- Applies low pass filter to individual trials
%   align_peaks -- Finds individual trial maxima and aligns them to that
%                   instead.
%
% Output:
%   A        -- The triggered average vector
%   X        -- All trials that went into the triggered average
%
% See also: Contents

arguments
    triggers double {mustBeVector}
    x double {mustBeVector}
    n_pre (1,1) double = 20;
    n_post (1,1) double = 80;
    rectify (1,1) logical = false;
    do_smooth (1,1) logical = false;
    align_peaks (1,1) logical = false;
end

vec = -n_pre : n_post;
if align_peaks
    n = numel(vec);
    n_off = round(n*0.25);
    vec = (vec(1)-n_off) : (vec(end)+n_off);
        
end
triggers = reshape(triggers, numel(triggers), 1);
idx = vec + triggers;
iBad = any(idx < 1, 2) | any(idx > numel(x), 2);
idx(iBad, :) = [];
triggers(iBad) = [];
X = x(idx);
if rectify
    X = abs(X);
end
if do_smooth
    X = sgolayfilt(X, 3, 21, [], 2);
end

if align_peaks
    [~, loc] = max(X, [], 2);
    deltas = reshape(vec(loc), numel(loc), 1);
    triggers = triggers + deltas;
    idx = (-n_pre : n_post) + triggers;
    iBad = any(idx < 1, 2) | any(idx > numel(x), 2);
    idx(iBad, :) = [];
    % triggers(iBad) = [];
    X = x(idx);
    if rectify
        X = abs(X);
    end
    if do_smooth
        X = sgolayfilt(X, 3, 21, [], 2);
    end
end

% X = X - median(X, 2);
A = mean(X, 1);
% A = A - min(A);

end