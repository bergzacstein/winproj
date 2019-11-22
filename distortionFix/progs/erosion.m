function im = erosion(image,se)

% erosion(image,se) 
%
%   Computes the erosion of the image image using the structuring element se

im = 255 - dilation(255-image,se);

% Image size and type

%[vert,hor] = size(image);

%[radius1,radius2] = size(se);
%radius1 = (radius1 - 1) /2;
%radius2 = (radius2 - 1) /2;

%i = 0;
%j = 0;


% Add a border to the image

%image = [ 255* ones(radius1 ,hor);image ; 255* ones(radius1,hor)];
%image = [ 255* ones(vert + 2*radius1, radius2 ) , image , 255* ones(vert + 2*radius1 , radius2 )];

% Erosion 

%for j = radius2 + 1 : radius2 + hor        
%    for i = radius1 + 1: radius1 + vert
%        masquage = image(i- radius1:i+radius1, j-radius2 : j+radius2).*se;
%        for k1= 1 : radius1*2+1
%            for k2= 1 : radius2*2+1
%                if se(k1,k2)==0
%                    masquage(k1,k2)=255;
%                end
%            end
%        end
%        im(i,j) = min(min(masquage));
%    end
%end


%im = uint8(im(radius1+1:radius1+vert , radius2+1:radius2+hor));

%    imshow(im);
