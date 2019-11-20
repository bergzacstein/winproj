
distortedPic=imread('images/building.tif');
figure('Name','Loaded Image');
imshow(distortedPic);
[x,y] = getpts;

x = int64(x(1:4));
y = int64(y(1:4));

xShifted = circshift(x,1);
yShifted = circshift(y,1);

middleX = abs(xShifted + x)/2;
middleY = abs(yShifted + y)/2;

hold on;
plot(middleX, middleY, 'rx', 'MarkerSize', 10, 'LineWidth',10);
hold off


resultX = [min(middleX), min(middleX), max(middleX), max(middleX)]
resultY = [min(middleY), max(middleY), max(middleY), min(middleY)]


hold on;
plot(resultX, resultY, 'go', 'MarkerSize', 2, 'LineWidth',2);
hold off

figure('Name','Transformed Image');

combinedXY = [x y];

targetSize = size(distortedPic);
targetSize(1) = max(resultX)-min(resultX);
targetSize(2) = max(resultY)-min(resultY);

tform = maketform('projective',double(combinedXY),double(combinedResultXY));
[resultPic, xData, yData] = imtransform(distortedPic,tform,'bicubic',...
                            'size',targetSize);
imshow(resultPic,'XData',xdata,'YData',ydata);     
                           
                           
                           
                           