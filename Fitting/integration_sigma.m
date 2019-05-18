% combines standard deviations for optimal cue combination

function sigma = integration_sigma(sigma1, sigma2)

sigma = sqrt(sigma1 .^ 2 * sigma2 .^ 2 / (sigma1 .^ 2 + sigma2 .^ 2));