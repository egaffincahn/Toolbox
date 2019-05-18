% Y = FUNN(X, FUN, DIMS)
% 
% FUNN applies a function FUN to X two or more times.
% 
% Usage:
% X = rand([4,3,2]); % create random array of dimensionality (4,3,2)
% Y = FUNN(X, @sum, [1,3]); % sum over the first and third dimension

function y = funn(x, fun, dims)

y_temp = x;
for i = 1:length(dims)
    y_temp = fun(y_temp, dims(i));
end
y = y_temp;