function Gradient_Image=gradient_image(Image,delta_x,delta_y)
%========================================================
% Gradient_Image=gradient_image(Image,delta_x,delta_y)  =	
% Sqrt(d(Image)/dx^2+d(Image)/dy^2)		                 =
%========================================================

%===============================
%     Get size of the image    =
%===============================
[M,N]=size(Image);

for i=1:M
   for j=2:N-1
      Gradx_Image(i,j)=(Image(i,j+1)+Image(i,j-1)-2*Image(i,j))/(2*delta_y);
   end
   Gradx_Image(i,N)=0;
   Gradx_Image(i,1)=0;
end

for j=1:N
   for i=2:M-1
      Grady_Image(i,j)=(Image(i+1,j)+Image(i-1,j)-2*Image(i,j))/(2*delta_x);
   end
   Grady_Image(1,j)=0;
   Grady_Image(M,j)=0;
end

Gradient_Image=sqrt(Gradx_Image.^2+Grady_Image.^2);
