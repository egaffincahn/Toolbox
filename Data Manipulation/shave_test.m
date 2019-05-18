
%% test the methods on a benchmark

clear
format compact
iters = 100;
methods = 3;
t = nan(iters, methods);
for method = 1:methods
    rng(1)
    for i = 1:iters
        M = rand([100, 45, 20, 5, 2]);
        tic
        shave(M, method);
        t(i, method) = toc*1000;
        disp(i)
    end
end
boxplot(t)
xlabel('Method')
ylabel('ms')
disp('finished')


return

%% check different 

rng(1)
figure(2), clf, hold on
t = nan(15,5,2);
dimh = {'.', ':', '-.', '--', '-'};
methodh = {'b', 'r'};
iters = 50;
t_temp = nan(1, iters);
for method = 1:size(t,3)
    for dim = 1:size(t,2)
        for n = 1:size(t,1)
            sz = repmat(n, [1, dim]);
            if length(sz) == 1; sz = [1, sz]; end
            for i = 1:iters
                M = rand(sz);
                tic;
                shave(M, method);
                t_temp = toc;
            end
            t(n,dim,method) = mean(t_temp);
            fprintf('finish method = %d, dim = %d, n = %d\n', method, dim, n)
        end
        plot(1:n, t(:,dim,method), [dimh{dim}, methodh{method}])
    end        
end
set(gca, 'YScale', 'log')


