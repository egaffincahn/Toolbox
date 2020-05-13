% coef = CCF(x, y) returns the cross-correlation coefficients for all lags
% 0:n-1 where x and y are vectors of length n. Vectors do not wrap around or
% zero-pad.
% 
% coef = CCF(x, y, K) returns the ccf for only lags K.
% 
% coef = CCF(x) returns the autocorrelation of x for all lags.
% 
% coef = CCF(x, K) returns the autocorrelation of x for lag K. K must be a
% scalar.
% 
% coef = CCF(x, [], K) is the required notation or autocorrelation at
% multiple lags in K.
% 
% [coef, K] = CCF(x, ...) returns the lags.
% 
% EG Gaffin-Cahn 03/2020
% 

function varargout = ccf(x, varargin)

n = length(x);

if nargin == 1
    y = x;
    K = 0:n-1;
elseif nargin == 2 && isscalar(varargin{:})
    y = x;
    K = varargin{:};
elseif nargin == 2 && isvector(varargin{:})
    y = varargin{:};
    K = 0:n-1;
elseif nargin == 3 && isempty(varargin{1})
    y = x;
    K = varargin{2};
elseif nargin == 3
    y = varargin{1};
    K = varargin{2};
else
    error('ccf: Argument error')
end

assert(length(x) == length(y), 'ccf: length of x not equal to length of y')
assert(n > 1 && isvector(x) && isvector(y), 'ccf: x and y must be vectors')

x = x(:);
y = y(:);

coef = nan(1,length(K));

for i = 1:length(K)
    k = K(i);
    numer = x(1:n-k)' * y(k+1:n) - sum(x(1:n-k)) * sum(y(1+k:n)) / (n - k);
    denom = sqrt(sum(x(1:n-k) .^ 2) - (sum(x(1:n-k)) .^ 2) / (n - k)) * sqrt(sum(y(1+k:n) .^ 2) - (sum(y(1+k:n)) .^ 2) / (n - k));
    coef(i) = numer ./ denom;
end

if nargout == 2
    varargout = {coef, K};
else
    varargout = {coef};
end


