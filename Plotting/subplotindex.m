% subplot indices 
function index = subplotindex(rowi, coli, ncol)

index = (rowi - 1) * ncol + coli;