% affineTransform

close all
clear
clc

originalImage = imread('./airplane.bmp');
[height, width, ~] = size(originalImage);

attackType = 5;

% ================================================
% Shift down with Crop
% ================================================
if attackType == 1
	shiftPixel = 200;
	attackedImage = uint8(zeros(size(originalImage)));
	attackedImage(shiftPixel + 1:end, :, :) = originalImage(1:end - shiftPixel, :, :);


% ================================================
% Shift down without Crop
% ================================================
elseif attackType == 2
	shiftPixel = 200;
	attackedImage = uint8(zeros(height+shiftPixel, width, 3));
	attackedImage(1+shiftPixel:end, :, :) = originalImage;

% ================================================
% Shift right without Crop
% ================================================
elseif attackType == 3
	shiftPixel = 200;
	attackedImage = uint8(zeros(height, width+shiftPixel, 3));
	attackedImage(:, 1+shiftPixel:end, :) = originalImage;

% ================================================
% Rotate with Crop
% ================================================
elseif attackType == 4
	rotatedImage = imrotate(originalImage, 30);
	[temp_height, temp_width, ~] = size(rotatedImage)
	if(temp_height > height && temp_width > width)
		% Croping
		topMargin = floor((temp_height - height)/2);
		leftMargin = floor((temp_width - width)/2);
		attackedImage = rotatedImage(topMargin+1:topMargin+height, leftMargin+1:leftMargin+width, :);
	end

% ================================================
% Rotate without Crop
% ================================================
elseif attackType == 5
	attackedImage = imrotate(originalImage, 30);

% ================================================
% Scale without Crop
% ================================================
elseif attackType == 6
	attackedImage = imresize(originalImage, 1.5);

% ================================================
% Shearing in x without Crop
% ================================================
elseif attackType == 7
	Ax = [1 1; 0 1];

	tempImage = rgb2ycbcr(originalImage);
	fTableR = constructF(tempImage(:, :, 1));
	fTableR(:, 1:2) = round(Ax * fTableR(:, 1:2)')';
	imageR = fTable2image(fTableR);

	fTableG = constructF(tempImage(:, :, 2));
	fTableG(:, 1:2) = round(Ax * fTableG(:, 1:2)')';
	imageG = fTable2image(fTableG);

	fTableB = constructF(tempImage(:, :, 3));
	fTableB(:, 1:2) = round(Ax * fTableB(:, 1:2)')';
	imageB = fTable2image(fTableB);

	squareSum = imageR.^2 + imageG.^2 + imageB.^2;
	blackEntryIdx = find(squareSum == 0);
	imageR(blackEntryIdx) = 16;
	imageG(blackEntryIdx) = 128;
	imageB(blackEntryIdx) = 128;

	[height, width] = size(imageR);
	attackedImage = uint8(zeros(height, width, 3));
	attackedImage(:, :, 1) = imageR;
	attackedImage(:, :, 2) = imageG;
	attackedImage(:, :, 3) = imageB;
	attackedImage = ycbcr2rgb(attackedImage);

% ================================================
% Shearing in y without Crop
% ================================================
elseif attackType == 8
	Ax = [1 0; 1 1];

	tempImage = rgb2ycbcr(originalImage);
	fTableR = constructF(tempImage(:, :, 1));
	fTableR(:, 1:2) = round(Ax * fTableR(:, 1:2)')';
	imageR = fTable2image(fTableR);

	fTableG = constructF(tempImage(:, :, 2));
	fTableG(:, 1:2) = round(Ax * fTableG(:, 1:2)')';
	imageG = fTable2image(fTableG);

	fTableB = constructF(tempImage(:, :, 3));
	fTableB(:, 1:2) = round(Ax * fTableB(:, 1:2)')';
	imageB = fTable2image(fTableB);

	squareSum = imageR.^2 + imageG.^2 + imageB.^2;
	blackEntryIdx = find(squareSum == 0);
	imageR(blackEntryIdx) = 16;
	imageG(blackEntryIdx) = 128;
	imageB(blackEntryIdx) = 128;

	[height, width] = size(imageR);
	attackedImage = uint8(zeros(height, width, 3));
	attackedImage(:, :, 1) = imageR;
	attackedImage(:, :, 2) = imageG;
	attackedImage(:, :, 3) = imageB;
	attackedImage = ycbcr2rgb(attackedImage);


end

imwrite(attackedImage, './airplane_rotate.bmp');

