function Bin = my_get_roi(Im);
%==============================================
%  USAGE
%   Bin = my_get_roi(Im);
%==============================================


figure,my_imshow(Im);
P    = my_getpts;
Cont = vect2bin([P(:,2) P(:,1)], size(Im));
Bin  = contour2bw(Cont,'n');

subplot(1,3,3),my_imshow(Bin);
subplot(1,3,2),my_imshow(Cont);
subplot(1,3,1),my_imshow(Im);
