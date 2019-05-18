% LOGISTIC returns the probabilities at each value of x where the
% logistic is ascending at values x >= cut, and descending for values x <
% cut. The other input arguments apply for both halves of the function, and
% characterize its shape. Argument cut is optional. The final optional
% input argument specifies if you want the Regular, Inverse, or Derivative
% of the Logistic function.
% 
% p = LOGISTIC(x, alpha, beta, gamma, lambda [,cut] [,opt])
% p = LOGISTIC(varargin)

function p = Logistic(varargin)

if length(varargin)==1
    varargin = varargin{:};
end
x = varargin{1};
alpha = varargin{2};
beta = varargin{3};
gamma = varargin{4};
lambda = varargin{5};
if length(varargin) > 5
    cut = varargin{6};
elseif length(varargin) < 6 || isempty(varargin{6})
    cut = -Inf;
end
if length(varargin) > 6
    opt = varargin{7};
elseif length(varargin) < 6 || isempty(varargin{7})
    opt = 'Regular';
end

if strncmpi(opt,'Regular',3)
    PF = @(x,a,b,g,l) g + (1-g-l)./(1+exp(-b.*(x-a)));
elseif strncmpi(opt,'Derivative',3)
    PF = @(x,a,b,g,l) (1-g-l) .* (1+exp(-1*(b).*(x-a))).^-2 .* (exp(-1*(b).*(x-a))).*b;
elseif strncmpi(opt,'Inverse',3)
    PF = @(x,a,b,g,l) a - log( (1-l-x) ./ (x-g) ) ./ b;
elseif strncmpi(opt,'dInverse',3)
    PF = @(x,a,b,g,l) (1-l-g)./(b .* (1-l-x) .* (x-g));
else
    error('Invalid opt argument')
end

p = nan(size(x));
p(x>=cut) = PF(x(x>=cut), alpha, beta, gamma, lambda);
p(x<cut) = PF(x(x<cut), cut-alpha, -beta, gamma, lambda);
