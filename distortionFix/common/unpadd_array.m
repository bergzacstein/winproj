function Im = unpadd_array(Im_padd)
%==========================================================
% USAGE
%   Im = unpadd_array(Im_padd)
%==========================================================

[M,N] = size(Im_padd);
Xi    = 2:M-1;
Yi    = 2:N-1;
Im    = Im_padd(Xi,Yi);

