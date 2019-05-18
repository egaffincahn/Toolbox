function y = logit(x, cut)

alpha = 0;
beta = 1;
gamma = 0;
lambda = 0;
if nargin < 2 || isempty(cut); cut = -Inf; end
opt = 'Inverse';

if any(x(:) < 0 | x(:) > 1)
    warning('logit only defined in real numbers when input 0 <= x <= 1')
end

y = Logistic(x, alpha, beta, gamma, lambda, cut, opt);