close all
clear
clc

attackType = 9;
% 1 - Shift down with Crop
%#2 - Shift down without Crop
%#3 - Shift right without Crop
% 4 - Rotate with Crop
%#5 - Rotate without Crop
%#6 - Scale without Crop
%#7 - Shearing in x without Crop
%#8 - Shearing in y without Crop
%#9 - Shearing in x&y without Crop
attackNameList = { 'ShiftDownCrop', 'ShiftDown', 'ShiftRight', 'RotateCrop', 'Rotate', 'Scale', 'ShearingInX', 'ShearingInY', 'ShearingInXY' };
paraList = zeros(9, 1);
paraList(1) = 200;
paraList(2) = 200;
paraList(3) = 200;
paraList(4) = 30;
paraList(5) = 10;
paraList(6) = 1.5;
paraList(7) = 1;
paraList(8) = 1;
paraList(9) = 1;
attack(attackType, paraList(attackType));

originalImage = imread('./airplane.bmp');
originalImage = double(rgb2gray(originalImage));

suspiciousImage = imread('./airplane_attacked.bmp');
imwrite(suspiciousImage, ['./ShearingMatrixResult/' num2str(attackType) '_' attackNameList{attackType} '/' num2str(attackType) '_' attackNameList{attackType} '_' num2str(paraList(attackType)) '.png']);
suspiciousImage = double(rgb2gray(suspiciousImage));

normHeight = 512;
normWidth  = 512;
% [normalOriginImage, isOriginGood] = normalizeImage(originalImage, normHeight, normWidth, 0);
% [normalSuspImage, isSuspGood] = normalizeImage(suspiciousImage, normHeight, normWidth, 0);

normalOriginImage = normalizeImage(originalImage, normHeight, normWidth, 0);
normalSuspImage = normalizeImage(suspiciousImage, normHeight, normWidth, 0);

% counter = 1;
% while (~isOriginGood || ~isSuspGood) && counter<=10
% 	normHeight = normHeight + 50;
% 	normWidth  = normWidth  + 50;
% 	[normalOriginImage, isOriginGood] = normalizeImage(originalImage, normHeight, normWidth, false);
% 	[normalSuspImage, isSuspGood] = normalizeImage(suspiciousImage, normHeight, normWidth, false);
% 	counter = counter + 1;
% end

noi = figure;
imshow(normalOriginImage);
saveas(noi, ['./ShearingMatrixResult/' num2str(attackType) '_' attackNameList{attackType} '/' num2str(attackType) '_' attackNameList{attackType} '_' num2str(paraList(attackType)) '_orig.png']);

nsi = figure;
imshow(normalSuspImage);
saveas(noi, ['./ShearingMatrixResult/' num2str(attackType) '_' attackNameList{attackType} '/' num2str(attackType) '_' attackNameList{attackType} '_' num2str(paraList(attackType)) '_susp.png']);


[temp_height temp_width] = size(normalOriginImage);
normalOriginArea = temp_height * temp_width;
if isequal( size(normalOriginImage), size(normalSuspImage) )
	% diffImage = normalSuspImage - normalOriginImage;
	diffImage = uint8(abs(double(normalSuspImage)-double(normalOriginImage)));
	dif = figure;
	imshow(diffImage)
	colormap jet
	colorbar
	saveas(dif, ['./ShearingMatrixResult/' num2str(attackType) '_' attackNameList{attackType} '/' num2str(attackType) '_' attackNameList{attackType} '_' num2str(paraList(attackType)) '_diff.png']);

	nnz(diffImage)
	nnz(diffImage) / normalOriginArea
	psnr(normalSuspImage, normalOriginImage)

	fileID = fopen(['./ShearingMatrixResult/' num2str(attackType) '_' attackNameList{attackType} '/' num2str(attackType) '_' attackNameList{attackType} '_' num2str(paraList(attackType)) '.txt'], 'w');
	fprintf(fileID,'PSNR = %3.2f\nPixel Error Rate =  %3.4f\n', psnr(normalSuspImage, normalOriginImage), nnz(diffImage) / nnz(normalOriginImage));
	fclose(fileID);
else
	disp(['size(normalOriginImage)=' num2str(size(normalOriginImage))]);
	disp(['size(normalSuspImage)=' num2str(size(normalSuspImage))]);

	leftUpImage = normalSuspImage(1:end-1, 1:end-1);
	rightUpImage = normalSuspImage(1:end-1, 2:end);
	leftDownImage = normalSuspImage(2:end, 1:end-1);
	rightDownImage = normalSuspImage(2:end, 2:end);
	
	% leftUpDiff = leftUpImage - normalOriginImage;
	leftUpDiff = uint8(abs(double(leftUpImage)-double(normalOriginImage)));
	nnz(leftUpDiff)
	nnz(leftUpDiff) / normalOriginArea
	psnr(leftUpImage, normalOriginImage)

	% rightUpDiff = rightUpImage - normalOriginImage;
	rightUpDiff = uint8(abs(double(rightUpImage)-double(normalOriginImage)));
	nnz(rightUpDiff)
	nnz(rightUpDiff) / normalOriginArea
	psnr(rightUpImage, normalOriginImage)

	% leftDownDiff = leftDownImage - normalOriginImage;
	leftDownDiff = uint8(abs(double(leftDownImage)-double(normalOriginImage)));
	nnz(leftDownDiff)
	nnz(leftDownDiff) / normalOriginArea
	psnr(leftDownImage, normalOriginImage)

	% rightDownDiff = rightDownImage - normalOriginImage;
	rightDownDiff = uint8(abs(double(rightDownImage)-double(normalOriginImage)));
	nnz(rightDownDiff)
	nnz(rightDownDiff) / normalOriginArea
	psnr(rightDownImage, normalOriginImage)

	fileID = fopen(['./ShearingMatrixResult/' num2str(attackType) '_' attackNameList{attackType} '/' num2str(attackType) '_' attackNameList{attackType} '_' num2str(paraList(attackType)) '.txt'], 'w');
	fprintf(fileID,'LeftUp:\nPSNR = %3.2f\nPixel Error Rate =  %3.4f\n\n', psnr(leftUpImage, normalOriginImage), nnz(leftUpDiff) / normalOriginArea);
	fprintf(fileID,'RightUp:\nPSNR = %3.2f\nPixel Error Rate =  %3.4f\n\n', psnr(rightUpImage, normalOriginImage), nnz(rightUpDiff) / normalOriginArea);
	fprintf(fileID,'LeftDown:\nPSNR = %3.2f\nPixel Error Rate =  %3.4f\n\n', psnr(leftDownImage, normalOriginImage), nnz(leftDownDiff) / normalOriginArea);
	fprintf(fileID,'RightDown:\nPSNR = %3.2f\nPixel Error Rate =  %3.4f\n\n', psnr(rightDownImage, normalOriginImage), nnz(rightDownDiff) / normalOriginArea);
	fclose(fileID);
end







