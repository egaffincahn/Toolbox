% From https://www.mathworks.com/matlabcentral/answers/139977-determine-number-of-bytes-per-element-under-program-control#answer_143470

% return size in bytes of numeric entity x

function y = sizeof(x, prefix)

w = whos('x');
bytes = w.bytes;

if nargin < 2
    y = bytes;
    return
end

switch prefix
    case 'kilo'
        y = bytes / 10^3;
    case 'mega'
        y = bytes / 10^6;
    case 'giga'
        y = bytes / 10^9;
    otherwise
        warning('Prefix not supported. Returning bytes.')
        y = bytes;
end

