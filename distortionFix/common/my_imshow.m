function my_imshow(Im)
%==========================
% USAGE
%    my_imshow(Im)
%==========================


%==========================
% Colormap
%==========================
Maxi  = max(Im(:));
Mini  = min(Im(:));
Range = double(Maxi-Mini+1);
colormap(gray);
%colormap(gray(Range));

%==========================
% Image display
%==========================
imagesc(Im);
axis off