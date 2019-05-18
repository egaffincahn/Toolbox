% Wrapper for spm_BMS
% 
% See also spm_BMS.

function [alpha,exp_r,xp,pxp,bor] = EP(varargin)

[alpha,exp_r,xp,pxp,bor] = spm_BMS(varargin);