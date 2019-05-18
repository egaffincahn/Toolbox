% Weibull returns the probabilities at each value of x for slope defined
% jointly by alpha and beta, guess rate gamma, and lapse rate lambda. The
% final optional input argument specifies if you want the Regular, Inverse,
% or Derivative of the Weibull function.
% 
% p = Weibull(x, alpha, beta, gamma, lambda, [opt])

function p = Weibull(varargin)

if length(varargin)==1
    varargin = varargin{:};
end
x = varargin{1};
alpha = varargin{2};
beta = varargin{3};
gamma = varargin{4};
lambda = varargin{5};
if length(varargin) < 6 || isempty(varargin{6})
    opt = 'Regular';
else
    opt = varargin{6};
end


% shorten some of the full functions
pfx = 1 - gamma - lambda; % prefix to function
prth = 1 - (x - gamma) ./ pfx; % common in the parenthesis
expn = -(x./alpha).^beta; % common in the exponent


if strncmpi(opt,'Regular',3)
    p = gamma + pfx .* (1-exp(expn));
elseif strncmpi(opt,'Derivative',3)
    p = pfx .* (exp(expn) .* beta .* x.^(beta-1) ./ alpha.^beta);
elseif strncmpi(opt,'Inverse',3)
    p = alpha .* nthroot(-log(prth), beta);
elseif strncmpi(opt,'dInverse',3)
    p = -(alpha/beta) .* (-log(prth)).^(1/beta) ./ (pfx .* prth .* log(prth));
else
    error('Invalid opt argument')
end

% PF = @(x,a,b) 1 - exp(-(x/a).^b);
% a = 3; b = 3.5; xp = [0 1 1.6 2.2 2.8 3.4 4.8 6]; xn = [-6.5 -5.2 -4.5 -4 -3.4 -2.9 -2.1 -1.4 -.5 0];
% plot(xp, PF(xp,a,b), 'o'); hold on;
% plot(xn, PF(xn,-a,b), 'o');
