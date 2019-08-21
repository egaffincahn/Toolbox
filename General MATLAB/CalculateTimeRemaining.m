% Calculates the estimated remaining time based on the elapsed time and how
% far along we are. Outputs the time in [hours minutes seconds]. Inputs are
% the current position and the total steps, respectively. Make sure to call
% TIC before this function, but outside of your loop so that it does not
% reset each iteration.
% 
% Usage:
%   t = CalculateTimeRemaining(n, N [, str])
% 
% EG Gaffin-Cahn
% 4/2015
% Updated to add string time 3/2017
% Updated to create PrintTimeRemaining as separate function 8/2019
% 

function t = CalculateTimeRemaining(n, N, str)

if nargin < 3
    str = false;
end

dt = toc; % elapsed time
T = dt * N / n; % total time
rt = T - dt; % remaining time

t = PrintTimeRemaining(rt, str);
