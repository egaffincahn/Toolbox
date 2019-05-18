% nll = NLOGLIK(nChoice, nTotal, PF, varargin)
% 
% NLOGLIK returns the negative log likelihood for a binary outcome measure
% using any function you supply and its parameters set the final argument.
% nChoice and nTotal are same-size vectors or matrices which correspond to
% the number of a specific answer (or correct, etc.) and number of total
% trials. PF is a function handle and its parameters are the final input
% arguments. The negative log likelihood is summed across the last
% non-singleton dimension.
% 
% Example:
% levels = 1:5; % stimulus levels
% nChoice = [2 8 17 28 35]; % number of "Yes" trials
% nTotal = 40; % nTotal must be a scalar or the same size as nChoice
% PF = @normcdf; % use the cumulative normal distribution
% mu = 3; sigma = 1.5; % estimates for normcdf parameters
% nll = nloglik(nChoice, nTotal, PF, levels, mu, sigma);
% 
% EG Gaffin-Cahn
% 02/2015

function nll = nloglik(nChoice,nTotal,PF,varargin)

assert(isequal(size(nTotal),size(nChoice)) || isscalar(nTotal),'Vectors nTotal and nChoice must be same size')

LL = nChoice .* log(PF(varargin{:})) + (nTotal-nChoice) .* log(1-PF(varargin{:}));

nll = -sum(LL,find(size(LL)>1,1,'last'));
