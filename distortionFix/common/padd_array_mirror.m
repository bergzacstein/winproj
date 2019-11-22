function Im_padd = padd_array_mirror(Im)
%=====================================================
% USAGE
%  Im_padd = padd_array_mirror(Im)
% PARAMETERS 
% Im      = Image (size [M N])
% Im_padd = Image padded with mirror extension (size [M+2,N+2])
%=====================================================


[M,N] = size(Im);
Yi    = 2:M+1;
Xi    = 2:N+1;
Im_padd = zeros(M+2,N+2);

Im_padd(Yi,Xi)           = Im;
Im_padd([1 M+2],[1 N+2]) = Im_padd([3 M],[3 N]);       % mirror corners
Im_padd([1 M+2],Xi)      = Im_padd([3 M],Xi);          % mirror left and right boundary
Im_padd(Yi,[1 N+2])      = Im_padd(Yi,[3 N]);          % mirror top and bottom boundary
