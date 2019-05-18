function Y = ndgridfun(x1, x2, fun)

[X1, X2] = ndgrid(x1, x2);

Y = feval(fun, X1, X2);