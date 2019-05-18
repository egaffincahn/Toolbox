function logEvidence = getModelEvidence(LL, stepSizes, logPrior)
% This function takes the likelihood function computed using the grid
% method, and marginalises over all dimensions. If a posterior distribution
% is supplied, it will be applied to the likelihood before marginalisation.
% If it is not supplied, a flat prior over the parameter space will be
% assumed.
%
% Created by EG May 2018, edits SML August 2018, useful hints from EN!

% Defaults:
if nargin < 3
    logPrior = [];
end

% Check input:
assert(ndims(LL) == length(stepSizes), 'Incorrect dimensions')
assert(all(LL(:) <= 0 | isnan(LL(:))), 'Use log likelihood, not negative')

% Apply supplied prior:
if ~isempty(logPrior)
    assert(all(size(LL) == size(logPrior)), 'Likelihood and prior do not match in size')
    LL = LL + logPrior;
end

% Marginalise across each paramter dimension:
LL_max = max(LL(:)); % peak of the log-likelihood
LL_max0 = LL - LL_max; % shift everything up so peak at 0
LL_max1 = exp(LL_max0); % exponentiate, peak now at 1, min at 0
marginal = LL_max1;
for dim = 1:length(stepSizes) % EACH dimension
    marginal = nansum(marginal, dim) * stepSizes(dim); % marginaliz(/s)e!
end
logEvidence = log(marginal) + LL_max; % shift back!

% Apply flat prior if alternative not supplied:
if isempty(logPrior)
    k = 1/(prod(size(LL).*stepSizes));
    logEvidence = logEvidence - log(k);
end

end
