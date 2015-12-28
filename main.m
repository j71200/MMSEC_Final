close all
clear
clc

attackType = 6;
% 1 - Shift down with Crop
%#2 - Shift down without Crop
%#3 - Shift right without Crop
% 4 - Rotate with Crop
%#5 - Rotate without Crop
%#6 - Scale without Crop
%#7 - Shearing in x without Crop
%#8 - Shearing in y without Crop
%#9 - Shearing in x&y without Crop
attack(attackType);

originalImage = imread('./airplane.bmp');
originalImage = double(rgb2gray(originalImage));

suspiciousImage = imread('./airplane_attacked.bmp');
suspiciousImage = double(rgb2gray(suspiciousImage));

normHeight = 512;
normWidth  = 512;
% [normalOriginImage, isOriginGood] = normalizeImage(originalImage, normHeight, normWidth, 0);
% [normalSuspImage, isSuspGood] = normalizeImage(suspiciousImage, normHeight, normWidth, 0);

normalOriginImage = normalizeImageRotate(originalImage, normHeight, normWidth, 0);
normalSuspImage = normalizeImageRotate(suspiciousImage, normHeight, normWidth, 0);






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
else
	disp(['size(normalOriginImage)=' num2str(size(normalOriginImage))]);
	disp(['size(normalSuspImage)=' num2str(size(normalSuspImage))]);

	leftUpImage = normalSuspImage(1:end-1, 1:end-1);
	rightUpImage = normalSuspImage(1:end-1, 2:end);
	leftDownImage = normalSuspImage(2:end, 1:end-1);
	rightDownImage = normalSuspImage(2:end, 2:end);
	
	leftUpDiff = leftUpImage - normalOriginImage;
	nnz(leftUpDiff)
	nnz(leftUpDiff) / nnz(normalOriginImage)
	psnr(leftUpImage, normalOriginImage)

	rightUpDiff = rightUpImage - normalOriginImage;
	nnz(rightUpDiff)
	nnz(rightUpDiff) / nnz(normalOriginImage)
	psnr(rightUpImage, normalOriginImage)

	leftDownDiff = leftDownImage - normalOriginImage;
	nnz(leftDownDiff)
	nnz(leftDownDiff) / nnz(normalOriginImage)
	psnr(leftDownImage, normalOriginImage)

	rightDownDiff = rightDownImage - normalOriginImage;
	nnz(rightDownDiff)
	nnz(rightDownDiff) / nnz(normalOriginImage)
	psnr(rightDownImage, normalOriginImage)

end



