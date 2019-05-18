% y = CONTINUOUS(x [, n]);
% 
% The simplest of linear interpolations.
% 
% CONTINUOUS takes a 1-D vector x and optional number of steps n and
% returns a 1-by-n vector from the minimum of x to the maximum of x. The
% purpose of this is for drawing smooth lines in function plots.
% 
% Example:
% x = -3:3; xc = continuous(x);
% plot(x, normcdf(x), 'b'); hold on;
% plot(xc, normcdf(xc), 'r');
% 
% 
% EG Gaffin-Cahn
% 12/2014

function y = continuous(x, n)

assert(isvector(x) && ~isscalar(x), 'Input x must be a 1-D vector')

if nargin < 2 || isempty(n)
    n = 1000;
end

% y = linspace(min(x), max(x), n);
y = linspace(x(1), x(end), n);

