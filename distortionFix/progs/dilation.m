function im = dilation(image,se)

% dilation(image,se) 
%
%   Computes the dilation of the image image using the structuring element se

% Image size and type

[vert,hor] = size(image);
%image = double(image);

[radius1,radius2] = size(se);
radius1 = (radius1 - 1) /2;
radius2 = (radius2 - 1) /2;

i = 0;
j = 0;

% Add a border to the image

image = [ zeros(radius1 ,hor);image ; zeros(radius1,hor)];

image = [ zeros(vert + 2*radius1, radius2 ) , image , zeros(vert + 2*radius1 , radius2 )];

% dilation 

for j = radius2 + 1 : radius2 + hor        
    for i = radius1 + 1: radius1 + vert
        masquage = image(i- radius1:i+radius1, j-radius2 : j+radius2).*se;
        im(i,j) = max(max(masquage));
    end
end


im = uint8(im(radius1+1:radius1+vert , radius2+1:radius2+hor));

%    imshow(im);
