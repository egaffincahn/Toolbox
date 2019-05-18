% [tri, h] = SCATTER2SURF(x, y, z [, plotfun = @trisurf] [, trifun = @delaunay])
% 
% SCATTER2SURF takes equal length vectors x, y, and z which could be
% plotted as a scatterplot, performs a triangulation and plots a 3D
% surface. Alternatively, x can be an Nx3 matrix of points. The default
% triangulation function is the @delaunay function and the default plotting
% function is @trisurf. Accidental plotting function calls @mesh and @surf
% are converted to @trimesh and @trisurf. SCATTER2SURF returns the
% triangulation matrix and figure handle.
% 
% Example:
%   n = 30;
%   SCATTER2SURF(rand(n,1), rand(n,1), rand(n,1));
% 
% EG Gaffin-Cahn
% 6/24/2016
% 

function [tri, H] = scatter2surf(x, y, z, plotfun, trifun, varargin)

if nargin < 5 || isempty(trifun)
    trifun = @delaunay;
end
if nargin < 4 || isequal(plotfun, @surf) || isempty(plotfun)
    plotfun = @trisurf;
end
if isequal(plotfun, @mesh)
    plotfun = @trimesh;
end

if ismatrix(x) && ~isvector(x) && length(size(x))==2 && any(size(x)==3)
    if size(x, 1) == 3; x = x'; end
    z = x(:,3);
    y = x(:,2);
    x = x(:,1);
end

tri = trifun(x, y);
H = plotfun(tri, x, y, z, varargin{:});
