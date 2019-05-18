% [x, y, z] = EXTRACTDATAFROMFIGURE(h)
% 
% EXTRACTDATAFROMFIGURE takes an input figure handle (or calls gcf if none
% is provided) and extracts the data used to create the figure. This is
% helpful when you have a saved .fig but the code used to create it has
% changed or you don't have access to it.
% 
% EG Gaffin-Cahn
% 12/2/16
% 

function [x, y, z] = extractDataFromFigure(h)

if ~nargin
    h = gcf;
end

axesObjs = get(h, 'Children');  % grab the axes handles
graphicsObjs = get(axesObjs, 'Children'); % grab the graphics objects
if length(graphicsObjs) > 1
    objTypes = cellfun(@class, graphicsObjs, 'UniformOutput', false); % get the object types
    dataObj = graphicsObjs{~cellfun(@isempty, strfind(objTypes, 'graphics'))}; % get the graphics object
else
    dataObj = graphicsObjs;
end

x = get(dataObj, 'XData');
y = get(dataObj, 'YData');
z = get(dataObj, 'ZData');
