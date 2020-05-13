% DP = AUROC2DP(AUROC) converts Area Under the ROC (AUROC/AUC) to d' (d-prime).
%
% Equation from Simpson & Fitter (1973).
%

function dp = auroc2dp(auroc)

dp = invnorm(auroc)*sqrt(2);
