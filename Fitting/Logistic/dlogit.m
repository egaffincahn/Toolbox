function y = dlogit(x, cut)

alpha = 0;
beta = 1;
gamma = 0;
lambda = 0;
if nargin < 2 || isempty(cut); cut = -Inf; end
opt = 'dInverse';

y = Logistic(x, alpha, beta, gamma, lambda, cut, opt);