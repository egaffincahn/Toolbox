% accepts any number of inputs
function y = outerProduct(varargin)

len = length(varargin);
sz = cellfun(@length, varargin);
y = ones(sz);
for i = 1:length(varargin)
    rshp = ones(1,len);
    rshp(i) = length(varargin{i});
    rpmt = sz;
    rpmt(i) = 1;
    y = y .* repmat(reshape(varargin{i}(:), rshp), rpmt);
end


end