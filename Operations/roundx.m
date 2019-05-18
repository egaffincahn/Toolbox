% ROUNDX rounds X to the nearest Rth place using the function determined by
% the function handle FUNC. X and R can be a scalar, vector, or matrix.
% However, if both X and R are not scalars, then their size must be
% identical. For iterative calculations of vectors and matrices of
% different sizes, use repmat or bsxfun. FUNC can be the built-in MATLAB
% functions round, floor, ceil, or fix. FUNC can also be unfix, which
% rounds away from zero. Making WARN false turns off warnings for
% unorthodox cases.
% 
% Two unorthodox uses are possible: R is not required to have the form 1eN
% for some integer N. For example, instead of rounding to the nearest
% integer (where R = 1), round to the nearest even number (R = 2). It is
% also possible to have one of the input numeric values X or R not be
% floating point precision. While not prohibited, this will produce some
% curious effects.
% 
% Usage: Y = ROUNDX(X, R [, FUNC] [,WARN])
% 
% Orthodox example:      roundx(12.3456, .1, @ceil)       returns 12.4000
% Unorthodox example 1:  roundx(12.3456, .2, @floor)      returns 12.2000
% Unorthodox example 1b: roundx(12.3456, 2, @ceil)        returns 14
% Unorthodox example 2:  roundx(int8(12.3456), 5, @floor) returns 10
% Unorthodox example 2b: roundx(int8(12.3456), 5, @ceil)  returns 10
% 
% 7/15/2015 written
% 4/24/2015 included optional suppressing of the warning
% EG Gaffin-Cahn

function y = roundx(x, r, func, warn)

% set defaults
if nargin < 4 || isempty(warn)
    warn = true;
end
if nargin < 3 || isempty(func)
    func = @round;
end
if nargin < 2 || isempty(r)
    r = 1;
end

% enforce size constraints
assert(isscalar(x) || isscalar(r) || all(size(x)==size(r)), ...
    'ROUNDX:incongruentSize', ...
    'X and R must either be scalars or have the same size. See @repmat or @bsxfun.')

% enforce valid function handle
assert(any(strcmpi(char(func),{'round','floor','ceil','fix','unfix'})), ...
    'ROUNDX:unrecognizedFunction', ...
    sprintf('Unrecognized rounding function handle %s.', char(func)))

% check rounder is 1 * 10^N for some integer N
if warn && ~all(all(round(log10(r)) == log10(r)))
    warning('ROUNDX:RthPlace', 'Take caution when R does not take the form 1eN')
end

% check inputs have floating point precision
if warn && ~isa([x(:); r(:)], 'single') && ~isa([x(:); r(:)], 'double')
    warning('ROUNDX:classError', 'Take caution when X or R does not have floating point precision')
end


y = feval(func, x ./ r) .* r;

