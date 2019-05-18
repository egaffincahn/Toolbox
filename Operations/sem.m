function y = sem(x)

x = x(~isnan(x));

y = nanstd(x) ./ sqrt(length(x));