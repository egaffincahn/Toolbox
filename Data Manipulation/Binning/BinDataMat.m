% BINDATAMAT is centered around the MATLAB function histc. The data in
% vector X is binned according to certain rules dictated by the input
% arguments.
% 
% Input arguments:
%   X: Vector data to be binned
%   edgeType:
%       -'uniform' Equally spaced bins from min(X) to max(X) where the
%           number of bins is defined by edgeStep. If edgeStep is not
%           provided, 10 is used as default.
%       -'percentile' Creates bins with equal number of data
%           points per bin. If edgeStep is not provided, 10 is used as
%           default.
%       -'custom' The bin edges, defined by edgeStep must be provided,
%           including the upper and lower bounds of the outside bins. Use
%           Inf and -Inf to capture all data outside the second to last
%           edge.
%   edgeStep: Used in conjuction with edgeType.
%   exact: When True, rather than using bins whose edges define where the 
%       data fall, data in X will be put in the bin if and only if the
%       data are on an edge, not between them. Otherwise, values in a bin
%       are assigned to a bin defined by its lower boundary (as in histc).
%       If not provided, defaults to False.
% 
% Output arguments:
%   binCounts: A vector with length equal to the number of bins that
%       dictates how many data points fall in each bin. Equivalent to
%       output argument N from histc.
%   whichBin: A vector with length equal to length of X that dictates which
%       bin (if any) each data point falls into. Equivalent to output
%       argument BIN from histc.
%   binMeans: A vector with length equal to the number of bins that
%       dictates the mean of the data points from X that fall in that bin.
%   binStds: A vector with length equal to the number of bins that
%       dictates the standard deviation of the data points from X that fall
%       in that bin.
%   edges: The lower bound of the each of the bins.
% 
% Usage:
%   [binCounts, whichBin, binMeans, binStds, edges] = BinData(X, edgeType [,edgeStep] [,exact])
% 
% 
% EG Gaffin-Cahn
% 01/2015

function [binCounts, whichBin, binMeans, binStds, edges] = BinDataMat(X, edgeType, edgeStep, exact)

%#ok<*AGROW>
assert(isnumeric(X) && ~isscalar(X), 'X must be vector or matrix')
X = squeeze(X);
ndims = length(size(X)>1);

if nargin < 3 || isempty(edgeStep)
    edgeStep = 10 * ones(1, ndims);
end
if nargin < 4 || isempty(exact)
    exact = zeros(1, ndims);
end

% format edgeType
if length(edgeType) == 1 || ischar(edgeType)
    edgeType = repmat({char(edgeType)}, [1,ndims]);
elseif length(edgeType) ~= ndims
    error('edgeType must be length 1 or the same length as number of dimensions in X')
end

% format edgeStep
if iscell(edgeStep) && length(edgeStep) == 1
    edgeStep = repmat({cell2mat(edgeStep)}, [1,ndims]);
elseif isnumeric(edgeStep) && (length(edgeStep) == 1 || length(edgeStep) == ndims)
    edgeStep = repmat({edgeStep}, [1,ndims]);
elseif length(edgeStep) ~= ndims
    error('edgeStep must be length 1 or the same length as number of dimensions in X')
end

% format exact (must be vector or scalar)
if length(exact) == 1
    exact = repmat(exact, [1,ndims]);
elseif length(exact) ~= ndims
    error('exact must be length 1 or the same length as number of dimensions in X')
end

for i = 1:ndims
    if strcmpi(edgeType{i}, 'uniform')
        edges{i} = linspace(min(X,[],i), max(X,[],i), edgeStep{i}+1); % add one to include inner and outer bounds
    elseif strcmpi(edgeType{i}, 'percentile')
        edges{i} = prctile(X, linspace(0, 100, edgeStep{i}+1), i); % add one to include inner and outer bounds
    elseif strcmpi(edgeType{i}, 'custom')
        assert(nargin >= 3, 'edgeStep must be provided for edgeType vector')
        assert(isvector(edgeStep) && ~isscalar(edgeStep), 'edgeStep must be vector')
        edges{i} = edgeStep{i};
    else
        error('edgeType must be ''uniform'', ''percentile'', or ''custom''')
    end
end



if exact
    for i = 1:length(edges)
        binCounts(i) = sum(X==edges(i));
        whichBin(X==edges(i)) = i;
    end
else
    edges(end) = edges(end) + sqrt(eps); % include the final upper bound in the last bin
    [binCounts, whichBin] = histc(X, edges);
    binCounts(end) = [];
    edges(end) = [];
end

% can i make this better?
for i = 1:length(edges)
    binMeans(i) = mean(X(i==whichBin));
    binStds(i) = std(X(i==whichBin));
end

% function iterateSuperlative(X, ndims, current super)
% 
% for i = 1:ndims-1
%     
% end