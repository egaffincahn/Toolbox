% index = SUBPLOTINDEX(rowi, coli, ncol)
%
% Scroll through columns first. ncol is innermost for loop.
% 

function index = subplotindex(rowi, coli, ncol)

index = (rowi - 1) * ncol + coli;
