% breaks = LOGTICKS(exponent, ticks, base, trunc)
% 
% LOGTICKS quickly and easily calculates the values breaks where
% 
%               breaks = ticks * base ^ exponent
% 
% For vectors of ticks and exponent, LOGTICKS saves you from having to use
% repmat, etc. This is useful when creating a vector of exponentially
% increasing values that don't only exist on the 10s (or whichever base).
% 
% Input arguments:
%   exponent: exponents where the final breaks will exist at
%   ticks: gives the tick locations within each magnitude
%   base: base of the exponential, defaults to 10, but commonly 2 or 'e'
%   trunc: removes all but the first tick of the final (greatest)
%          magnitude's exponent
% Warns for ticks less than 1 and ticks greater than or equal to the base.
% Output shape will be determined by the shape of the inputs.
%
% LOGTICKS(-1:0) returns
% [.1, .2, .3, ..., .9, 1, 2, 3, ..., 9]
%
% LOGTICKS(-1:0, [], [], true) returns
% [.1, .2, .3, ..., .9, 1]
%
% LOGTICKS(1:3, [1, 2.5, 5]) returns
% [10, 25, 50, 100, 250, 500, 1000, 2500, 5000]
% 
% LOGTICKS(-1:2, [1, 1.5], 2) returns
% [.5, .75, 1, 1.5, 2, 3, 4, 6]
% 
% LOGTICKS(0:1, [1, 1.5], 'e') returns
% [1, 1.5, 2.7183, 4.0774]
% 
% LOGTICKS([1, 1.5, 2], [1, 5]) returns
% [10, 50, 31.6228, 158.1139, 100, 500]
%
% EGC 6/1/16
% Updated and edited for MATLAB 6/19/16
% 

function breaks = logticks(exponent, ticks, base, trunc)

if nargin < 4
    trunc = false;
end
if nargin < 3 || isempty(base)
    base = 10;
elseif strcmpi(base, 'e')
    base = exp(1);
end
if nargin < 2 || isempty(ticks)
    ticks = 1:9;
end

if any(ticks < 1)
    warning('logticks::Ticks less than 1')
end
if any(ticks >= base)
    warning('logticks::Ticks greater than or equal to exponential base')
end

mag = base .^ exponent;
magRep = sort(repmat(mag, size(ticks)));
ticksRep = repmat(ticks, size(mag));
breaks = magRep .* ticksRep;

if trunc
    breaks = breaks(1:(end-length(ticks)+1));
end

