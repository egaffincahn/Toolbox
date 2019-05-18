function y = invlogit(x, cut)

alpha = 0;
beta = 1;
gamma = 0;
lambda = 0;
if nargin < 2 || isempty(cut); cut = -Inf; end
opt = 'Regular';

y = Logistic(x, alpha, beta, gamma, lambda, cut, opt);