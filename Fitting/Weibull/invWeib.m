function y = invWeib(x)

alpha = 1;
beta = 1;
gamma = 0;
lambda = 0;
opt = 'Inverse';

if any(x(:) < 0 | x(:) > 1)
    error('invWeib only defined in real numbers when input 0 <= x <= 1')
end

y = Weibull(x, alpha, beta, gamma, lambda, opt);