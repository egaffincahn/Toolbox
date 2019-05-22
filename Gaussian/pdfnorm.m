function y = pdfnorm(x, mu, sigma)

if nargin < 3 || isempty(sigma)
    sigma = 1;
end
if nargin < 2 || isempty(mu)
    mu = 0;
end

y = (1/sqrt(2*pi*sigma.^2)) .* exp(-(1/2) .* ((x-mu)./sigma) .^ 2);
