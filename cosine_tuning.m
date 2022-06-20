function [b0, b1, b2, theta0, R, I] = cosine_tuning(Y)
%COSINE_TUNING  Return regression coefficients, PD, fit, and modulation index for cosine tuning curve.
%
% Syntax:
%   [b0, b1, b2, theta0, R, I] = math.cosine_tuning(Y);
%
% Inputs:
%   Y - [nChannel x 8] vector, where each column corresponds to some data
%                      to be tuned for a different angle/target.
%
% Output:
%   [b0, b1, b2] - Regression coefficients for cosine tuning model.
%   theta0       - Preferred direction (for rows of Y)
%   R            - Regression fit indicator
%   I            - Index of modulation
%
% See also: Contents

% Reshape into nChannel x 8
if numel(Y) > 8
    if size(Y, 1) == 8
        Y = Y';         
    end
end

% Least-square unbiased estimators:
b0 = mean(Y, 2);
b1 = ((Y(:, 2) + Y(:, 4) - Y(:, 6) - Y(:, 8)) ./ sqrt(2) + (Y(:, 3) - Y(:, 7))) ./ 4;
b2 = ((Y(:, 2) - Y(:, 4) - Y(:, 6) + Y(:, 8)) ./ sqrt(2) + (Y(:, 1) - Y(:, 5))) ./ 4;

theta0 = atan2(b1, b2);
R = 4 * (b1.^2 + b2.^2) ./ sum((Y - b0).^2, 2);
I = sqrt(b1.^2 + b2.^2) ./ b0;
end