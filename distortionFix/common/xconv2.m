function Volume_res = xconv2(Volume,Mask)
%==============================================================
% USAGE
%   Volume_res = xconv2(Volume,Mask)
% PARAMETERS
%   Volume     = Original data
%   Mask       = Mask of filter
%   Volume_res = Image convolved with the mask 
%==============================================================

[M,N]        = size(Volume);
[M1,N1]      = size(Mask);
Limit_left   = floor([M N]/2);
Limit_left1  = floor([M1 N1]/2);
Limit_right  = [M N] - Limit_left;
Limit_right1 = [M1 N1] - Limit_left1;

Ml_right = M1;
Nl_right = floor(N1/2);

%=======================
% avoid border effects
%=======================
Volume      = my_padarray(Volume,[M1 N1],'circular','both');
Dim_original = [M,N];
[M,N]        = size(Volume);


%=======================
% avoid aliasing
%=======================
FI         = fft2(Volume,M+M1-1,N+N1-1); 
FG         = fft2(Mask,M+M1-1,N+N1-1);

Volume_res = FI.*FG;
Volume_res = real(ifftn(Volume_res));
Crop_left  = [M1 N1] + Limit_left1;
Volume_res = Volume_res(1+Crop_left(1):Dim_original(1)+Crop_left(1),1+Crop_left(2):Dim_original(2)+Crop_left(2));

%=======================
%=======================
