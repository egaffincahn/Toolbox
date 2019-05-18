function y = dInvWeib(x)

alpha = 1;
beta = 1;
gamma = 0;
lambda = 0;
opt = 'dInverse';

y = Weibull(x, alpha, beta, gamma, lambda, opt);