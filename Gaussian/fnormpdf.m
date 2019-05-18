function y = fnormpdf(x, mu, sigma)

y = exp(-(x-mu).^2 ./ (2*sigma.^2)) + exp(-((x-mu).^2 ./ (2*sigma.^2)));
y = y ./ (sigma * sqrt(2*pi));