% [M, EDGES1, ...] = NDBIN(X1, EDGES1, ...);
% 
% NDBIN bins data into multiple dimensions. Useful for turning x,y scatter
% data into a matrix.
%
% Input:
% X1, EDGES1, X2, EDGES2, ..., XN, EDGESN, R
% XN are the data to be binned in the Nth dimension. Must all be vectors of
% equal length.
% EDGESN can be empty (but must be specified as [], even for the final XN), or can be
% a scalar or vector as allowed in HISTCOUNTS. A shortcoming of this
% function is that all X values must be contained within the edges. That
% is, there cannot be X values that fall outside of an edge.
% R are the values of summation for ACCUMARRAY. Default is 1.
%
% Output:
% M is an array of size EDGES1-by-EDGES2-by-...-by-EDGESN with the accumulated
% values in it.
% The edges are returned in each subsequent varargout.
%
% Examples:
% n = 1000;
% x = rand(n, 1);
% y = rand(n, 1);
% z = rand(n, 1);
% 
% [M, xedges] = NDBIN(x, []); plot(xedges, M);
% [M, xedges] = NDBIN(x, 25); plot(xedges, M);
% [M, xedges] = NDBIN(x, 0:.2:1); plot(xedges, M);
% [M, xedges, yedges] = NDBIN(x, 8, y, 16); surf(xedges, yedges, M')
% [M, xedges, yedges, zedges] = NDBIN(x, [], y, [], z, []);
% 
% r = rand(n, 1) > .5;
% [Mr, xedges, yedges] = NDBIN(x, 10, y, 25, r);
% Mt = NDBIN(x, 10, y, 25);
% surf(xedges, yedges, (Mr ./ Mt)')
% set(gca, 'DataAspectRatio', [1 1 1])
% 
% M = NDBIN(x, [], y', []); % fails because different sizes
% M = NDBIN(x, [], y); % fails because no edge provided
% M = NDBIN(x, 0.5 : .1 : 1.5); % because values in x are outside the edges
%
% See also HISTCOUNTS, ACCUMARRAY
% 
% EG Gaffin-Cahn
% Written 5/12/17
% 


function [M, varargout] = ndbin(varargin)

N = floor(nargin / 2);

% put all the data into an M-by-N matrix for M data points (length of input
% data) and N dimensions
V = cellfun(@(x) x(:), varargin(1:2:N*2), 'UniformOutput', false);
assert(N == 1 || alleq(V), 'ndbin: All data to be binned must have the same size')
V = cell2mat(V);

% put all the edges (if provided) into a single cell array
edges = cell(1, size(V, 2));
for i = 2:2:nargin
    if ~isempty(varargin{i})
        assert(isscalar(varargin{i}) || isvector(varargin{i}), 'ndbin: Edges must be empty, scalar or vector')
        edges{i/2} = varargin{i};
    end
end

% handle summation values for accumarray
if mod(nargin, 2)
    r = varargin{nargin}(:);
else
    r = 1;
end
assert(isscalar(r) || length(r) == size(V, 1), 'ndbin:: r must be scalar or same length as data')

% use histcounts for each dimension, with the user's edges if provided and
% return the edges actually used
bin = cell(size(edges));
for i = 1:length(edges)
    if isempty(edges{i})
        [~,edges{i},bin{i}] = histcounts(V(:,i));
    else
        [~,edges{i},bin{i}] = histcounts(V(:,i), edges{i});
    end
end

% place the bin indices into the correct bin
% if 1D binning, turn sz into a row vector from a scalar
sz = cellfun(@(x) length(x), edges);
if N == 1; sz = [sz 1]; end
M = accumarray(bin, r, sz); % the output matrix, but padded with 0s

% The final index of each dimension will be all 0s because of the binning
% method, so we build a new logical matrix which will keep only the proper
% subset our binned N-D matrix. This will have to work for any N. The
% logic is to scroll through each dimension and figure out which indices
% are the final ones along that dimension.
subset = true(sz); % assume keep all indices
for i = 1:N
    keep = prod([sz(1:i-1) sz(i)-1]);
    eliminate = prod(sz(1:i-1));
    repeater = [ones(keep, 1); zeros(eliminate, 1)];
    reps = prod(sz(i+1:N));
    saved = logical(repmat(repeater, [reps, 1]));
    subset = subset(:) & saved;
end
M = reshape(M(subset), sz-1); % subset, reshape and reduce size of M

% do the same for the edges
varargout = cellfun(@(x) x(1:end-1), edges, 'UniformOutput', false);

% check if all the input sizes are equal
function bool = alleq(X)

sz = cell2mat(cellfun(@size, X', 'UniformOutput', false));
bool = all(all(diff(sz) == 0));
