function im = opening(image,se)

% opening(image,se) 
%
%   Computes the opening of the image image using the structuring element se

im = dilation(erosion(image,se),se);
