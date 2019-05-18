% finds optimal weight for cue combination

function w = integration_w(sigma1, sigma2)

sigma_max = max(sigma1, sigma2); % pick which is greater
sigma_min = min(sigma1, sigma2);
p1 = 1 ./ sigma_max .^ 2; % precisions
p2 = 1 ./ sigma_min .^ 2;
w = p1 / (p1 + p2);
if sigma2 > sigma1
    w = 1 - w;
end