% ima=imread('brain.tif');
% image(name);
% imshow(name);
% plotim(name); % nie działa
% figure(2)
% hist(double(ima(:)),[0:255]);

% modfft=log(abs(fftshift(fft2(ima)))+0.1);
% plotim(modfft)
% 
% phifft=angle(fftshift(fft2(ima)));
% plotim(phifft)
cell=imread('images/bat.tif');
% imshow(cell);

se = makeSE('disk', 1);

ero=erosion(cell,se);
dil=dilation(cell,se);
open=opening(cell,se);
close=closing(cell,se);
% 
% imshow(cell);
% figure(4);
% imshow(ero);
% figure(2);
% imshow(open);

tophat = cell-open;
morphGrad = dil-ero;
figure(3);
imshow(morphGrad);