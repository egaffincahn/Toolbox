% yj = JITTER(y [,jitt] [,opt]);
% 
% JITTER vertically jitters input data for better visualizations,
% especially when plotting the raw binary outcome data with few or
% categorical independent variable levels.
% 
% Optional input jitt determines amount of jitter. Defaults to 1/10th the
% mean value of the input. Optional input opt, if TRUE, brings binary data
% closer to center so no values < 0 or > 1. Defaults to FALSE.
% 
% Example:
% n = 80; % n total trials
% x = round(rand(n,1) * 5); % 5 data levels
% y = round(rand(n,1)); % binary outcome data
% yj = jitter(y, [], true); % jittered data
% subplot(1,2,1); plot(x, y, 'o'); title('No Jitter');
% subplot(1,2,2); plot(x, yj, 'o'); title('Jitter');
% 
% EG Gaffin-Cahn
% 12/2014

function yj = jitter(y, jitt, opt)

if nargin < 3 || isempty(opt) || ~opt % default
    
    if nargin < 2 || isempty(jitt)
        jitt = .10 * nanmean(y);
    end
    
    yj = y + 2 * jitt * rand(size(y)) - jitt;
    
else % brings binary data closer to center (so no values < 0 or > 1)
    
    if ~all(y==0 | y==1)
        warning('Input vector x must be binary')
    end
    y = logical(y);
    
    if nargin < 2 || isempty(jitt)
        jitt = .05;
    end
    
    yj = jitt * rand(size(y));
    
    yj(y) = -yj(y);
    
    yj = double(y) + yj;
    
end

