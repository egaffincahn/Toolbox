function test_outerProduct

%%
filetext = fileread('outerProduct.m');
assert(~contains(filetext,'regexp'))

%%
y = outerProduct([],[]);
assert(isempty(y))

%%
x = randi(100);
y = randi(100);
assert(isequal(outerProduct(x,y),x*y))

%%
x = randi(100,[1 100]);
y = randi(100,[1 90]);
assert(isequal(outerProduct(x,y),x.'*y))
assert(isequal(outerProduct(x.',y),x.'*y))
assert(isequal(outerProduct(x,y.'),x.'*y))

%%
x = randi(100,[1 1000]);
xc = num2cell(x);
assert(isequal(outerProduct(xc{:}),prod(x)))