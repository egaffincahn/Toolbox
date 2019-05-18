% y = ALLEQ(varargin)
% 
% ALLEQ checks if all input arguments are the same
% 
% EG Gaffin-Cahn
% 12/1/16
% 

function y = alleq2(varargin)

if length(varargin) > 1
    args = varargin;
else
    args = varargin{:};
end
if length(args) == 2 % base case
    y = args{1} == args{2};
else
    y = alleq2(args(1:end-1));
end

% y = true(size(varargin{1}));
% for i = 1:length(varargin)
%     y_temp = varargin{1} == varargin{i};
%     y = y & y_temp;
% end