% [THETA_SAMPLE, P_SAMPLE, IND_SAMPLE] = SAMPLE(P, THETA, N)
% 
% Samples from probability distribution or likelihood given by
% probabilities P, an unnormalized distribution (not log) over parameters
% given by THETA, a vector of parameters if P is one dimension, or a cell
% array for dimensions > 1 . Samples N times with replacement.
% 
% If P is not provided, assumes uniform distribution over THETA. If THETA
% is not provided, assumes paramters are just indices (1:size(P, dim) for
% every dimension). At least one of P or THETA must be provided. If N is
% not provided, assumes 1000 samples.
% 
% Returns the sampled values, the samples' probabilities given by P, and
% the indices of P that were sampled.
% 
% Usage:
% 
% theta_sample = sample(rand(5,5), {[1 2 3 4 5], [-2 -1 0 1 2]}, 10);
% 
% The likelihood does not need to be normalized, but must not be log
% transformed.
% nll_max = max(nll(:));
% nll_max0 = nll - nll_max;
% likelihood = exp(nll_max0);
% theta_sample = sample(likelihood, theta, N);
% 
% 

function [theta_sample, P_sample, ind_sample] = sample(P, theta, N)

assert(nargin >= 1 && (~isempty(P) || ~isempty(theta)), 'Too few input arguments')

if nargin == 1 || isempty(theta)
    theta = arrayfun(@(x) {1:x}, size(P));
    if isvector(P)
        theta = fliplr(theta);
    end
end
if isvector(theta) && ~iscell(theta)
    theta = {theta};
end
if length(theta) == 1
    theta{2} = 1;
end
if isempty(P)
    P = ones(cellfun(@length, theta));
    P = P / numel(P);
end
if nargin < 3
    N = 1e4;
end

P_in = P;

if isvector(P)
    nd = 2;
    P = P(:); % make P column vector
else
    nd = ndims(P);
end
if nargin < 2 || isempty(theta)
    theta = arrayfun(@(i) 1:size(P,i), 1:nd, 'UniformOutput', false);
end
if isnumeric(theta)
    theta = {theta(:)', 1};
end

% get rid of later dimensions (dim>2) that have length==1
singleton_dims = find(cellfun(@length, theta) ~= 1, 1, 'last')+1:length(theta);
theta_lopped = theta(singleton_dims);
if ~isempty(theta_lopped) && singleton_dims(end) == 2; theta_lopped = []; end
if ~isempty(singleton_dims); theta = theta(1:singleton_dims(1)-1); end

assert(isvector(theta), 'theta must be a numeric vector or a cell vector of numeric types')
assert(all(P(:)>=0), 'P should be unnormalized probability distribution - not log')
assert(length(theta) == 1 || ndims(P) == length(theta) && all(cellfun(@length, theta) == size(P)), 'P and theta do not match in size')
    
P = P ./ sum(P(:));
cdf = cumsum(P(:));

% ensure the final value of the cdf is exactly 1
unique_cdf = unique(cdf);
cdf(cdf == unique_cdf(end)) = 1;
cdf(cdf > 1) = 1; % some underflow errors

% get the indices of cdf that each random element falls into
rands = rand([N,1]);
if verLessThan('matlab','8.5') % for MATLAB R2014b or earlier
    cdf = cdf + sqrt(eps) * (0:length(cdf)-1)';
    cdf = [0; cdf];
    ind_sample = floor(interp1(cdf, 1:length(cdf), rands));
else % for MATLAB R2015a or later (slightly faster)
    ind_sample = discretize(rands, [0; cdf]);
end

ind_sample = ceil(ind_sample);

if isvector(P)
    X = ind2sub(size(P), ind_sample);
    theta_sample = theta{1}(X)';
else
    str = '] = ind2sub(size(P), ind_sample);';
    for i = nd:-1:1
        str = [',X{', num2str(i), '}', str]; %#ok<AGROW>
    end
    str(1) = '[';
    eval(str)
    theta_sample = nan(N,nd);
    for i = 1:nd
        theta_sample(:,i) = theta{i}(X{i}); %#ok<NODEF>
    end
end

P_sample = P_in(ind_sample);

% add back on "samples" of likelihood dimensions of length 1
for dim = 1:length(theta_lopped)
    theta_sample(:,end+1) = theta_lopped{dim}; %#ok<AGROW>
end

