% AUROC = DP2AUROC(DP) converts d' (d-prime) to Area Under the ROC (AUROC/AUC).
%
% Equation from Simpson & Fitter (1973).
%

function auroc = dp2auroc(dp)

auroc = cumnorm(dp/sqrt(2));
