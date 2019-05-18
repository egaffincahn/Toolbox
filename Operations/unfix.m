% UNFIX rounds x to the nearest integer away from 0, i.e., towards +Inf if
% sign(x) is +1 and towards -Inf if sign(x) is -1.
% 
% 7/15/2015
% EG Gaffin-Cahn
% 

function y = unfix(x)

c = x ~= round(x);
y = fix(x) + sign(x) .* c;