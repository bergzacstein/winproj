function Volume = gaussianblur(Volume,Sigma,Direction_to_filter)
%==================================================================================
%USAGE                                                                            
%    Gauss_blur = gaussianblur(Volume,Sigma,Direction_to_filter)                  
%    The function blurs the image with a gaussian kernel                          
% PARAMETERS                                                                      
%    Volume              = Volume to blur.                                             
%    Sigma               = Standard deviation of the Gaussian kernel of size [-3*Sigma:3*Sigma].                                
%    Direction_to_filter = 1,2,or 3 [default]
%    Gauss_blur          = Gaussian blurred volume.                                     
%==================================================================================
if nargin == 2
    Direction_to_filter = 3;
end

%===========================================================
%  Select direction to filter
%===========================================================
if Direction_to_filter==1
    Volume = permute(Volume,[3 2 1]);
elseif Direction_to_filter==2
    Volume = permute(Volume,[3 1 2]);
end  

[M,N,P]    = size(Volume);

%===========================================================
%1. Create Gaussian Mask with scale=1 and Sigma as input
%===========================================================
      x          = [-1:1];
    Gauss_mask = 1/sqrt(2*pi*Sigma^2)*exp(-(x.^2)/2*Sigma)'*exp(-(x.^2)/2*Sigma^2);

%============================================================
%2. Normalize Gaussian Mask so that its sum=1
%============================================================
Gauss_mask = Gauss_mask/sum(Gauss_mask(:));   

%=============================================================
%3. Blur the volume with 2D convolution
%=============================================================
for p=1:P
    Volume(:,:,p) = xconv2(Volume(:,:,p),Gauss_mask);
end

%===========================================================
%  Re select direction to filter
%===========================================================
if Direction_to_filter==1
    Volume = ipermute(Volume,[3 2 1]);
elseif Direction_to_filter==2
    Volume = ipermute(Volume,[3 1 2]);
end  

