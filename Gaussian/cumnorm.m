function y = cumnorm(x, mu, sigma)

if nargin < 3 || isempty(sigma)
    sigma = 1;
end
if nargin < 2 || isempty(mu)
    mu = 0;
end

y = .5 * (1 + erf((x - mu) ./ (sqrt(2)*sigma)));