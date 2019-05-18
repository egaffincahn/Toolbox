% SIMPLELINEARINTERPOLATION performs a linear interpolation of the vector X
% at N timepoints. It assumes indices in x are equally spaced. If this is
% not the case, interp1 can perform a more complex version. NaNs anywhere
% in X will leave gaps in Y. The benefit of using this function over
% MATLAB's builtin interp1 is that this is considerably faster.
% 
% Usage:
% x = rand(10,1); n = 75;
% y = SimpleLinearInterpolation(x, n);
% plot(1:length(x), x, 'bo', linspace(1,length(x),n), y, '.:r')
% 
% EG Gaffin-Cahn
% 08/2015

function y = SimpleLinearInterpolation(x, n)

x = x(:)'; % turn x into row vector
j = linspace(1,length(x),n); % equally spaced locations along length of x
w = j - floor(j); % weights of previous index with next index
y = x(floor(j)) .* (1 - w) + x(ceil(j)) .* w; % weighted sum of two locations
