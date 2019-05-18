% B = FOLDOVER(A, FUNC, [,DIR] [,DIM] [,SELF])
% 
% FOLDOVER returns the matrix A folded over itself, with the function
% handle FUNC applied from the half in direction DIR to the other half
% across optional dimension DIM. Output matrix B will be half the size as A
% (rounded up, as any middle vector will not be treated by FUNC) in
% dimension DIM. DIR refers to which half of the input matrix will fold
% over, while the other half remains in place. If DIR is not supplied,
% 'last' will be used. If DIM is not supplied, the first non-singleton
% dimension will be used. If SELF is 1, any leftover middle vector will be
% applied to itself, otherwise it will be left alone. If SELF is not
% supplied, it will default to 0.
%
% Examples:
% 
% Fold over first rows of A and multiply by the final rows of A
%   A = [3 0 5; 1 2 3; 2 4 -1];
%   B = FoldOver(A,@times,'first',1,0);
% 
% Take the mean of folded over columns
%   A = [3 0 5; 1 2 3; 2 4 -1];
%   B = FoldOver(A,@plus,'last',2,1) / 2;
% 
% 
% EG Gaffin-Cahn
% 01/2015

function B = FoldOver(A, FUNC, DIR, DIM, SELF)

sz = size(A);

if ~exist('DIR','var') || isempty(DIR)
    DIR = 'last';
end
if ~exist('DIM','var') || isempty(DIM)
    DIM = max([find(sz>1,1,'first'), 1]);
end
if ~exist('SELF','var') || isempty(SELF)
    SELF = 0;
end
assert(any(strcmpi(DIR,{'first','last'})), 'DIR must be ''first'' or ''last''')
assert(DIM <= length(sz), 'DIM must be a dimension along matrix A')


B_sz = sz;
B_sz(DIM) = sz(DIM)/2;
parts = {'base','static','fold'};


% build the base for B and what to fold over
for i = 1:length(parts)
    eval([parts{i} ' = ''A('';']); % initialize the part
end
for dim = 1:length(B_sz)
    
    if dim == DIM % when this is the dimension we fold over
        
        if SELF
            base = [base '1:' num2str(ceil(B_sz(dim)))];
            static = [static '[]'];
            fold = [fold 'end:-1:' num2str(1+sz(dim)-ceil(B_sz(dim)))]; % and in this case flip the order
        else
            base = [base '1:' num2str(floor(B_sz(dim)))];
            static = [static num2str(1+floor(B_sz(dim))) ':' num2str(sz(dim)-floor(B_sz(dim)))];
            fold = [fold 'end:-1:' num2str(1+sz(dim)-floor(B_sz(dim)))]; % and in this case flip the order
        end
        
    else % otherwise just take all values in the dimension
        for i = 1:length(parts)
            eval([parts{i} ' = [' parts{i} ' '':''];'])
        end
    end
    
    % move to next dimension with comma or close parenthesis
    for i = 1:length(parts)
        if dim < length(B_sz)
            eval([parts{i} ' = [' parts{i} ' '',''];'])
        else
            eval([parts{i} ' = [' parts{i} ' '')''];'])
        end
    end
end

base = eval(base);
static = eval(static);
fold = eval(fold);

B = cat(DIM, FUNC(base,fold), static);
if strcmp(DIR,'first')
    B = flip(B,DIM);
end
