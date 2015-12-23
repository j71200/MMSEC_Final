close all
clear
clc

originalImage = imread('./airplane.bmp');
originalImage = double(rgb2gray(originalImage));

suspiciousImage = imread('./airplane_rotate.bmp');
suspiciousImage = double(rgb2gray(suspiciousImage));

normHeight = 512;
normWidth  = 512;
[normalOriginImage, isOriginGood] = normalizeImage(originalImage, normHeight, normWidth, 0);
[normalSuspImage, isSuspGood] = normalizeImage(suspiciousImage, normHeight, normWidth, 0);

% counter = 1;
% while (~isOriginGood || ~isSuspGood) && counter<=10
% 	normHeight = normHeight + 50;
% 	normWidth  = normWidth  + 50;
% 	[normalOriginImage, isOriginGood] = normalizeImage(originalImage, normHeight, normWidth, false);
% 	[normalSuspImage, isSuspGood] = normalizeImage(suspiciousImage, normHeight, normWidth, false);
% 	counter = counter + 1;
% end

figure
imshow(normalOriginImage);

figure
imshow(normalSuspImage);

if isequal( size(normalOriginImage), size(normalSuspImage) )
	diffImage = normalSuspImage - normalOriginImage;
	figure
	imshow(diffImage)
	colormap jet
	colorbar
	nnz(diffImage)
	nnz(diffImage) / nnz(normalOriginImage)
	psnr(normalSuspImage, normalOriginImage)
end




