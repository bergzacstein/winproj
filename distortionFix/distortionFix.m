
distortedPic=imread('distorted/third.jpg');
figure('Name','Loaded Image');
imshow(distortedPic);
[x,y] = getpts;



X = x(1:4);
Y = y(1:4);
[X Y] = sortPolyFromClockwiseStartingFromTopLeft( X, Y );
x = int64(X);
y = int64(Y);



xShifted = circshift(x,1);
yShifted = circshift(y,1);

middleX = abs(xShifted + x)/2;
middleY = abs(yShifted + y)/2;

hold on;
plot(middleX, middleY, 'rx', 'MarkerSize', 10, 'LineWidth',10);
hold off


resultX = [min(middleX), min(middleX), max(middleX), max(middleX)];
resultY = [min(middleY), max(middleY), max(middleY), min(middleY)];


hold on;
plot(resultX, resultY, 'go', 'MarkerSize', 2, 'LineWidth',2);
plot(X, Y, 'bo', 'MarkerSize', 5, 'LineWidth',2);
hold off


combinedXY = [x y];

targetSize = size(distortedPic);
targetSize(1) = max(resultX)-min(resultX);
targetSize(2) = max(resultY)-min(resultY);

% tform = maketform('projective',double(combinedXY),double(combinedResultXY));
% [resultPic, xData, yData] = imtransform(distortedPic,tform,'bicubic',...
%                             'size',targetSize);
% imshow(resultPic,'XData',xdata,'YData',ydata);     


x=[1;targetSize(1);targetSize(1);1];
y=[1;1;targetSize(2);targetSize(2)];
% c)
A=zeros(8,8);
A(1,:)=[X(1),Y(1),1,0,0,0,-1*X(1)*x(1),-1*Y(1)*x(1)];
A(2,:)=[0,0,0,X(1),Y(1),1,-1*X(1)*y(1),-1*Y(1)*y(1)];
A(3,:)=[X(2),Y(2),1,0,0,0,-1*X(2)*x(2),-1*Y(2)*x(2)];
A(4,:)=[0,0,0,X(2),Y(2),1,-1*X(2)*y(2),-1*Y(2)*y(2)];
A(5,:)=[X(3),Y(3),1,0,0,0,-1*X(3)*x(3),-1*Y(3)*x(3)];
A(6,:)=[0,0,0,X(3),Y(3),1,-1*X(3)*y(3),-1*Y(3)*y(3)];
A(7,:)=[X(4),Y(4),1,0,0,0,-1*X(4)*x(4),-1*Y(4)*x(4)];
A(8,:)=[0,0,0,X(4),Y(4),1,-1*X(4)*y(4),-1*Y(4)*y(4)];
v=[x(1);y(1);x(2);y(2);x(3);y(3);x(4);y(4)];
u=A\v;

U=reshape([u;1],3,3)';
w=U*[X';Y';ones(1,4)];
w=w./(ones(3,1)*w(3,:));

T=maketform('projective',U');
resultPic=imtransform(distortedPic,T,'XData',[1 targetSize(1)],'YData',[1 targetSize(2)]);

figure('Name','Transformed Image');
imshow(resultPic)
imwrite(resultPic,'result.png')
                           
                           
                           
                           