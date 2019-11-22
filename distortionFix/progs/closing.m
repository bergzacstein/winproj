function im = closing(image,se)

% closing(image,se) 
%
%   Computes the closing of the image image using the structuring element se

im = erosion(dilation(image,se),se);
