function K = gaus_kernel(x)
%GAUS_KERNEL  Return filter kernel K given vector x
%
% Syntax:
%   K = math.gaus_kernel(x);
%
% Inputs:
%   x - Numeric zero-centered vector (e.g. -2:2) that we will use to return
%       a square, 2D matrix computed with a gaussian kernel.
%
% Output:
%   K - Values over [Xg,Yg] = meshgrid(x), essentially.
%
% See also: Contents, exp, sqrt
K = exp(-sqrt(x.^2 + (x').^2));
end