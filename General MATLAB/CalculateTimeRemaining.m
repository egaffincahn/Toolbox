% Calculates the estimated remaining time based on the elapsed time and how
% far along we are. Outputs the time in [hours minutes seconds]. Inputs are
% the current position and the total steps, respectively. Make sure to call
% TIC before this function, but outside of your loop so that it does not
% reset each iteration.
% 
% Usage:
%   t = CalculateTimeRemaining(n, N [, str] [,tt])
% 
% EG Gaffin-Cahn
% 4/2015
% Updated to add string time 3/2017
% Updated to create PrintTimeRemaining as separate function; tt 8/2019
% 

function t = CalculateTimeRemaining(n, N, str, tt)

if nargin < 3 || isempty(str)
    str = false;
end
if nargin < 4 || isempty(tt)
    dt = toc; % elapsed time from last tic
else
    dt = toc(tt); % elapsed time since tic saved in tt
end

T = dt * N / n; % total time
rt = T - dt; % remaining time

t = PrintTimeRemaining(rt, str);
