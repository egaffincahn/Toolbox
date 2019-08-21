% Prints the estimated remaining time rt. Outputs the time in [hours
% minutes seconds]. Optional input str is a logical which converts the
% estimation to a useful string output. Default is false.
% 
% Usage:
%   t = PrintTimeRemaining(rt [, str])
% 
% EG Gaffin-Cahn
% 8/2019
% 

function t = PrintTimeRemaining(rt, str)

t = [0 0 0]; % initialize output remaining time: [hours minutes seconds]

hr = 3600;
min = 60;

if rt > hr % hours remaining
    t(1) = floor(rt / hr);
    rt = rt - hr*t(1);
end
if rt > min % minutes remaining
    t(2) = floor(rt / min);
    rt = rt - min*t(2);
end
t(3) = round(rt); % seconds remaining
if nargin == 2 && str
    t = sprintf('%d hours, %d minutes, %d seconds estimated remaining', t(1), t(2), t(3));
end
