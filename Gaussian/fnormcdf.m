function y = fnormcdf(x, mu, sigma)

denom = sqrt(2)*sigma;
nump = x + mu;
numn = x - mu;
y = erf(nump./denom) + erf(numn./denom);
y = y / 2;