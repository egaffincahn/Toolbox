function [V, M, xedge, yedge] = bin2d(x, y, z, xedge, yedge, fun)

if nargin < 3 && ismatrix(x) && ~isvector(x) && length(size(x))==2 && any(size(x)==3)
    if size(x, 1) == 3; x = x'; end
    z = x(:,3);
    y = x(:,2);
    x = x(:,1);
end
if nargin < 4 || isempty(xedge)
    xedge = 10;
end
if isscalar(xedge)
    xedge = linspace(min(x), max(x), xedge);
end
if nargin < 5 || isempty(yedge)
    yedge = 10;
end
if isscalar(yedge)
    yedge = linspace(min(y), max(y), yedge);
end
if nargin < 6
    fun = @nanmean;
end

[~, xbin] = histc(x, xedge);
[~, ybin] = histc(y, yedge);

M = nan(length(xedge), length(yedge));
V = nan(0, 3);
for i = 1:length(xedge)
    for j = 1:length(yedge)
        zbin = fun(z(xbin==i & ybin ==j));
        V(end+1,:) = [xedge(i), yedge(j), zbin]; %#ok<AGROW>
        M(i,j) = zbin;
    end
end
