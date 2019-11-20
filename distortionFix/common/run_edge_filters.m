Im=imread('../images/zebras.jpg');
Im=double(Im(:,:,1));
[M,N] = size(Im);
h(1)=figure;h(2)=figure;

% Gradient
Filter = [1 -1];
Im_grad_h = abs(convn(Im,Filter));
Im_grad_h = Im_grad_h(1:M,1:N);
Filter = [1 -1]';
Im_grad_v = abs(convn(Im,Filter));
Im_grad_v = Im_grad_v(1:M,1:N);
figure(h(1)),my_imshow(Im_grad_h);title('grad horiz'),pause
figure(h(1)),my_imshow(Im_grad_v);title('grad vert'),pause
Im_grad = max(Im_grad_h,Im_grad_v);
figure(h(2)),subplot(2,2,1),my_imshow(Im_grad);title('grad'),pause

% roberts
Filter      = [0 1;-1 0];
Im_roberts = abs(convn(Im,Filter));
Im_roberts = Im_roberts(1:M,1:N);
figure(h(1)),my_imshow(Im_roberts);title('roberts (diagonal)'),pause
Im_grad_sob = max(Im_grad,Im_roberts);
figure(h(2)),subplot(2,2,2),my_imshow(Im_grad_sob);title('roberts + grad'),pause

% Prewitt
Filter      = [-1 0 1;-1 0 1;-1 0 1];
Im_prewitt_h = abs(convn(Im,Filter));
figure(h(1)),my_imshow(Im_prewitt_h);title('prewitt horz'),pause
Filter      = [-1 0 1;-1 0 1;-1 0 1]';
Im_prewitt_v = abs(convn(Im,Filter));
my_imshow(Im_prewitt_v);title('prewitt vert'),pause
Im_prewitt = max(Im_prewitt_h,Im_prewitt_v);
figure(h(2)),subplot(2,2,3),my_imshow(Im_prewitt);title('prewitt '),pause

% Sobel
Filter      = [-1 0 1;-2 0  2;-1 0 1];
Im_sobel_h = abs(convn(Im,Filter));
figure(h(1)),my_imshow(Im_sobel_h);title('sobel horz'),pause
Filter      = [-1 0 1;-2 0 2;-1 0 1]';
Im_sobel_v = abs(convn(Im,Filter));
my_imshow(Im_sobel_v);title('sobel vert'),pause
Im_sobel = max(Im_sobel_h,Im_sobel_v);
figure(h(2)),subplot(2,2,4),my_imshow(Im_sobel);title('sobel '),pause

%ROI
R =[   368   352   123   110];
h(3)=figure;
subplot(2,2,1),my_imshow(Im_grad(R(1):R(1)+R(3),R(2):R(2)+R(4)));
subplot(2,2,2),my_imshow(Im_roberts(R(1):R(1)+R(3),R(2):R(2)+R(4)));
subplot(2,2,3),my_imshow(Im_prewitt(R(1):R(1)+R(3),R(2):R(2)+R(4)));
subplot(2,2,4),my_imshow(Im_sobel(R(1):R(1)+R(3),R(2):R(2)+R(4)));


%=====================================================
% Image thresholding
%=====================================================
Thresh_grad = 0.5*( max(Im_grad(:))-min(Im_grad(:)));
Seg_grad    =  (Im_grad>Thresh_grad );

Thresh_roberts = 0.5*( max(Im_roberts(:))-min(Im_roberts(:)));
Seg_roberts   =  (Im_roberts>Thresh_roberts);

Thresh_prewitt = 0.5*( max(Im_prewitt(:))-min(Im_prewitt(:)));
Seg_prewitt    =  (Im_prewitt>Thresh_prewitt);

Thresh_sobel = 0.5*( max(Im_sobel(:))-min(Im_sobel(:)));
Seg_sobel    =  (Im_sobel>Thresh_sobel);

h(4)=figure;
subplot(2,2,1),my_imshow(Seg_grad(R(1):R(1)+R(3),R(2):R(2)+R(4)));
subplot(2,2,2),my_imshow(Seg_roberts(R(1):R(1)+R(3),R(2):R(2)+R(4)));
subplot(2,2,3),my_imshow(Seg_prewitt(R(1):R(1)+R(3),R(2):R(2)+R(4)));
subplot(2,2,4),my_imshow(Seg_sobel(R(1):R(1)+R(3),R(2):R(2)+R(4)));






