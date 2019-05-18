function Y = linspacemat(X1, X2, N)
%LINSPACE Linearly spaced vector.
%   LINSPACE(X1, X2) generates a row vector of 100 linearly
%   equally spaced points between X1 and X2.
%
%   LINSPACE(X1, X2, N) generates N points between X1 and X2.
%   For N = 1, LINSPACE returns X2.
%
%   Class support for inputs X1,X2:
%      float: double, single
%
%   See also LOGSPACE, COLON.

%   Copyright 1984-2013 The MathWorks, Inc.



assert(isequal(size(X1),size(X2)), 'X1 and X2 must be the same size')
for i = 1:length(X1)
    
    d1 = X1(i);
    d2 = X2(i);
    if nargin == 2
        n = 100;
    elseif length(N) == 1
        n = floor(double(N));
    else
        n = floor(double(N(i)));
    end
    
    n1 = n-1;
    c = (d2 - d1).*(n1-1); %check intermediate value for appropriate treatment
    if isinf(c)
        if isinf(d2 - d1) %opposite signs overflow
            y = d1 + (d2/n1).*(0:n1) - (d1/n1).*(0:n1);
        else
            y = d1 + (0:n1).*((d2 - d1)/n1);
        end
    else
        y = d1 + (0:n1).*(d2 - d1)/n1;
    end
    if ~isempty(y)
        y(1) = d1;
        y(end) = d2;
    end
    
    Y(i,:) = y;
    
end
