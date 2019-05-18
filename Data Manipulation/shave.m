function M = shave(M, method)

sz = size(M);
N = length(sz);

if method == 1
    S.type = '()';
    for i = 1:N
        S.subs = cellfun(@(x) ':', cell([1, length(sz)]), 'UniformOutput', false);
        S.subs{i} = sz(i);
        M = subsasgn(M,S,[]);
    end

elseif method == 2
    subset = reshape(true(sz), [prod(sz), 1]); % start by keeping all indices
    for i = 1:N
        keep = prod([sz(1:i-1) sz(i)-1]);
        eliminate = prod(sz(1:i-1));
        repeater = [true(keep, 1); false(eliminate, 1)];
        reps = prod(sz(i+1:N));
        saved = repmat(repeater, [reps, 1]);
        subset = subset & saved;
    end
    M = reshape(M(subset), sz-1); % subset, reshape and reduce size of M
    
elseif method == 3
    for i = 1:N
        subs = '';
        for j = 1:N
            if i == j
                subs = [subs, 'end'];
            else
                subs = [subs, ':'];
            end
            if j < N
                subs = [subs, ','];
            end
        end
        
        eval(['M(' subs ') = [];'])
    end
    
elseif method == 4
    S.type = '()';
    S.subs = arrayfun(@(x) ['1:' num2str(x-1)], sz, 'UniformOutput', false);
    M_new = nan(M, sz-1);
    M_new = subsasgn(M_new,S,M);
    
elseif method == 5
    
    M_new = nan(sz - 1);
    for i = 1:N
        keep = prod([sz(1:i-1) sz(i)-1]);
        eliminate = prod(sz(1:i-1));
        repeater = [true(keep, 1); false(eliminate, 1)];
        reps = prod(sz(i+1:N));
        saved = reshape(repmat(repeater, [reps, 1]), sz);
        M_new
        subset = subset & saved;
    end
    
    % waiting on a white knight
    
end