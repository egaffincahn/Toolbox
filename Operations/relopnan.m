% Z = RELOPNAN(OP, X, Y [,REMOVE])
% 
% Relative operators allowing for NaNs. Any operation that involves an NaN
% will evaluate to NaN. X and Y must be the same size unless one of them is
% a scalar. Second input is not required for operators that only require
% one input (such as NOT). This is slower than just using the operator, so
% use it only in the case that it is needed. REMOVE will remove the NaN
% indices from the result. Defaults to false. REMOVE on matrices will
% create a vector result.
% 
% z = [1 0 NaN] & 1; % fails
% z = relopnan(@and, [1 0 NaN], 1);
% z = relopnan(@lt, [-5 0 5], [0 0 NaN]); % less than
% z = relopnan(@not, [1 0 NaN]); % negate, only use one input
% z = relopnan(@and, [1 0 NaN], 1, true);
% 
% EG Gaffin-Cahn
% 10/13/2017
% Update 5/21/2019

function z = relopnan(op, x, y, remove)

assert(nargin(op) > 1 || nargin == 2 || isempty(y), 'Should not be two arguments for @%s', char(op))

szx = size(x);
if nargin < 3
    y = [];
end
if nargin < 4
    remove = false;
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
        % z is already set as nan
    end
    if isscalar(y)
        if isnan(y)
            % z is already set as nan
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
            % z is already set as nan
        else
            z(~isnan(x)) = op(x(~isnan(x)), y);
        end
    elseif isempty(y)
        z(~isnan(x)) = op(x(~isnan(x)));
    else % y is vec, matrix, array
        z(~isnan(x) & ~isnan(y)) = op(x(~isnan(x) & ~isnan(y)), y(~isnan(x) & ~isnan(y)));
    end
end

if remove
    z = z(~isnan(z));
end

