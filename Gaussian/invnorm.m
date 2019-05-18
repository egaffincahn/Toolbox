function z = invnorm(p, mu, sigma)

if nargin < 3 || isempty(sigma)
    sigma = 1;
end
if nargin < 2 || isempty(mu)
    mu = 0;
end

z = mu + sqrt(2) * sigma .* erfinv(2 * p - 1);