function im = recons(image,mask,mode)

% recons(image,mask,mode) 
%
%   Computes the reconstruction of the image image using the marker mask 
%  by dilation (mode = 'dilation') or by erosion (mode = 'erosion')

se=makeSE('diamond',1);

switch mode
case 'dilation'

cond = 0;

temp=uint8(min(image,mask));
while cond==0
 im=uint8(min(image,dilation(temp,se)));
 if im==temp
  cond = 1;
 end
 temp=im;
end

case 'erosion'

cond = 0;

temp=uint8(max(image,mask));
while cond==0
 im=uint8(max(image,erosion(temp,se)));
 if im==temp
  cond = 1;
 end
 temp=im;
end


otherwise
   return
end

im = uint8(im);
