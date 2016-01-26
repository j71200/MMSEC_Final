close all
clear
clc

originalImage = imread('./Experiment/lena.bmp');
originalImage = rgb2gray(originalImage);

originalImage = imresize(originalImage, [128, 128]);

cropedImage = cropCircle(originalImage);

figure
imshow(cropedImage)

[height width] = size(cropedImage);
cropedImage_dbl = double(cropedImage);

n = 2;
m = 2;

A = 0;

% radius = (height-1) / 2;
originalX = (height+1) / 2;
originalY = (width+1) / 2;
radius = height - originalX;
for idx = 1:height
	for jdx = 1:width
		x = (idx - originalX) / radius;
		y = (jdx - originalY) / radius;
		A = A + cropedImage_dbl(idx, jdx) * zernikePoly(n, -m, x, y);
	end
end

A = A * (n+1) / pi;
abs(A)


% ===============

cropedImage = imrotate(cropedImage, 90);
cropedImage_dbl = double(cropedImage);
figure
imshow(cropedImage)

n = 1;
m = 1;

A = 0;

% radius = height / 2;
originalX = (height+1) / 2;
originalY = (width+1) / 2;
radius = height - originalX;
for idx = 1:height
	for jdx = 1:width
		x = (idx - originalX) / radius;
		y = (jdx - originalY) / radius;
		A = A + cropedImage_dbl(idx, jdx) * zernikePoly(n, -m, x, y);
	end
end

A = A * (n+1) / pi;
abs(A)




