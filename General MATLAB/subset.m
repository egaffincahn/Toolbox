% B = SUBSET(A, X) simply performs B = A(X). Useful when you want to
% perform multiple consecutive subsets.
% 
% 
% Example
% 
% A = [1 1 2 3 5 8 13 21 34];
% Y = logical(round(rand(size(A)))); % random subset of A
% X = [2 3]; % 2nd and 3rd values of the subset of A
% 
% One method:
% C = A(Y);
% B = C(X);
% 
% Or:
% B = subset(A(Y), X)
% 
% 
% Example
% 
% A = 1:10;
% B = rand(size(A));
% R = logical(round(rand(size(A)))); % random subset of A and B
% 
% One method:
% X = A(R);
% Y = B(R) > .5;
% M = X(Y);
% 
% Or:
% M = subset(A(R), B(R) > .5)
% 

function B = subset(A, X)

B = A(X);