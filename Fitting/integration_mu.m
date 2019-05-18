% combines means for optimal cue combination

function mu = integration_mu(mu1, mu2, w)

mu = w * mu1 + (1 - w) * mu2;
