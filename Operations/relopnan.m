% Z = RELOPNAN(OP, X, Y)
% 
% Relative operators allowing for NaNs. Any operation that involves an NaN
% will evaluate to NaN. X and Y must be the same size unless one of them is
% a scalar. Second input is not required for operators that only require
% one input (such as NOT), and can have undesired behavior if included.
% This is slower than just using the operator, so use it only in the case
% that it is needed.
% 
% z = relopnan(@lt, [-1 0 1], [1 0 nan]); % less than
% z = relopnan(@not, [1 1 0 0 nan]); % negate, only use one input
% z = relopnan(@and, [1 1 0 0 nan], 1);
% 
% EG Gaffin-Cahn
% 10/13/2017
% 

function z = relopnan(op, x, y)

szx = size(x);
if nargin < 3
    y = [];
end
szy = size(y);

if length(szx) > 2
    z = nan(szx);
elseif length(szy) > 2
    z = nan(szy);
else
    z = nan(max(szx, szy));
end

if isscalar(x)
    if isnan(x)
        return % z is already set as nan
    end
    if isscalar(y)
        if isnan(y)
            return % z is already set as nan
        else % neither is nan
            z = op(x, y);
        end
    elseif isempty(y)
        z = op(x);
    else % y is vec, matrix, array
        z(~isnan(y)) = op(x, y(~isnan(y)));
    end
else
    if isscalar(y)
        if isnan(y)
            return % z is already set as nan
        else
            z(~isnan(x)) = op(x(~isnan(x)), y);
        end
    elseif isempty(y)
        z(~isnan(x)) = op(x(~isnan(x)));
    else % y is vec, matrix, array
        z(~isnan(x) & ~isnan(y)) = op(x(~isnan(x) & ~isnan(y)), y(~isnan(x) & ~isnan(y)));
    end
end

