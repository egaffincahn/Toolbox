
function [gminparams, gmineval] = gridsearch2(f,lb,ub,nper,shrink, ...
    tol,miniter,constrain,jitter)

% minimize function f using iterative grid search
%
% lb and ub are the initial lower and upper bounds (vectors giving bounds
% for each parameter).
%
% nper is the number of samples per dimension on each iteration.
%
% On each iteration, the function is evaluated at each grid point. For the
% next iteration, the grid is centered on the previous best value, and the
% range of each parameter is shrunk by a factor of shrink. Iterations
% repeat until the function value changes by less than tol for at least
% miniter iterations in a row. If 'constrain' is nonzero, then the initial
% parameter range is absolute, so new ranges are shifted to lie within the
% initial range. 'constrain' can be a single indicator, or a vector of 
% indicators, in which case it specifies separately for each dimension
% whether that dimension is constrained. If a dimension is not
% constrained, and the current minimum is on either edges of the
% current range, that dimension is not shrunk. If 'jitter' is nonzero,
% on each iteration the grid center randomly jittered +/- 1/2 grid width
% to avoid repeating values. Note: the best value is kept, so that if the
% next iteration results in a poorer fit, the previously better value
% isn't forgotten. The next iteration's grid starts centered on the best
% value from all previous iterations.
%
% Note: You should not shrink so much that the shrunken grid is smaller
% than 3 grid squares. That is, after jittering, you want the new grid to
% completely include the grid squares between which the previous minimum
% was found.

if min(size(lb))>1 || min(size(ub))>1 || length(lb)~=length(ub)
    error('gridsearch2: lb/ub must be vectors of equal length');
end
if fix(nper)~=nper || nper < 4
    error('gridsearch2: nper must be an integer greater than 3');
end
if shrink <= 0 || shrink >= 1
    error('gridsearch2: shrink must lie between 0 and 1');
end
if fix(miniter)~=miniter || miniter<1
    error('gridsearch2: miniter must be a positive integer');
end
if length(constrain) > 1
    if length(constrain)~=length(lb)
        error('gridsearch2: contrain must be length 1 or n');
    end
    constrainv = constrain;
else
    constrainv = zeros(1,length(lb));
    constrainv(:) = constrain;
end

ncurriter = 0;
firstiter = 1;
initlb = lb;    % save for later use as a constraint
initub = ub;
ndim = length(lb);
neval = nper^ndim;
gridinds = zeros(neval,ndim);
ind = zeros(1,ndim);
jit = 0;        % in case no jitter
for evalnum = 1:neval
    gridinds(evalnum,:) = ind;
    for dim = 1:ndim
        newval = ind(dim) + 1;
        if newval >= nper
            ind(dim) = 0;
        else
            ind(dim) = newval;
            break;
        end
    end
end
while (1)
    incr = (ub-lb)/(nper-1);
    minparams = lb;
    mineval = f(minparams);
    for evalnum = 2:neval
        ind = squeeze(gridinds(evalnum,:));
        cparam = lb + ind.*incr;
        fval = f(cparam);
        if fval < mineval
            mineval = fval;
            minparams = cparam;
        end
    end
    if firstiter
        firstiter = 0;
        gminparams = minparams;
        gmineval = mineval;
    else
        chg = gmineval - mineval;
        if chg > 0  % if any improvement
            gminparams = minparams;
            gmineval = mineval;
        end
        if chg > tol    % if enough improvement
            ncurriter = 0;
        else
            ncurriter = ncurriter + 1;
            if ncurriter >= miniter
                break;
            end
        end
    end
    for i = 1:ndim
        if constrainv(i)
            newhalfrange = shrink*(ub(i)-lb(i))/2;
            if jitter
                jit = 2*(rand-.5) * newhalfrange/(nper - 1);
            end
            nlb = gminparams(i) - newhalfrange + jit;
            nub = gminparams(i) + newhalfrange + jit;
            if nlb < initlb(i)
                lb(i) = initlb(i);
                ub(i) = lb(i) + 2*newhalfrange;
            elseif nub > initub(i)
                ub(i) = initub(i);
                lb(i) = ub(i) - 2*newhalfrange;
            else
                lb(i) = nlb;
                ub(i) = nub;
            end
        else
            if gminparams(i) <= lb(i) || gminparams(i) >= ub(i)
                newhalfrange = (ub(i) - lb(i))/2;
            else
                newhalfrange = shrink*(ub(i)-lb(i))/2;
            end
            if jitter
                jit = 2*(rand-.5) * newhalfrange/(nper - 1);
            end
            lb(i) = gminparams(i) - newhalfrange + jit;
            ub(i) = gminparams(i) + newhalfrange + jit;
        end
    end
end