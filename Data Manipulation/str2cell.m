% STR2CELL creates a cell array with formatSpec in each cell and a single
% string or character vector inserted into it. Does not have functionality
% for multiple items in a single cell.
% 
% C = STR2CELL('w^%d', 0:2)
% 
% EG Gaffin-Cahn
% Created Nov 2015
% Updated Feb 2017


function C = str2cell(formatSpec, v)

C = cell(1, length(v));
for i = 1:length(v)
    C{i} = sprintf(formatSpec, v(i));
end