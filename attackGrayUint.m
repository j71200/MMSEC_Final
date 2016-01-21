function attackedImage_uint = attackGrayUint(originalImage_uint, attackType, para)

% originalImage_uint = imread('./airplane.bmp');
[height, width] = size(originalImage_uint);

%1 - Shift down without Crop
%2 - Shift right without Crop
%3 - Rotate without Crop
%4 - Scale without Crop
%5 - Shearing in x without Crop
%6 - Shearing in y without Crop
%7 - Shearing in x&y without Crop
%8 - JPEG Compression
%9 - Arbitrary matrix without Crop

% ================================================
% Shift down with Crop
% ================================================
% if attackType == 1
% 	shiftPixel = para;
% 	attackedImage_dbl = zeros(size(originalImage_uint));
% 	attackedImage_dbl(shiftPixel + 1:end, :) = originalImage_uint(1:end - shiftPixel, :);
% 	disp(['Shift down ' num2str(shiftPixel) ' pixel with Crop']);


% ================================================
% Shift down without Crop
% ================================================
if attackType == 1
	shiftPixel = para;
	attackedImage_uint = uint64(zeros(height+shiftPixel, width));
	attackedImage_uint(1+shiftPixel:end, :) = originalImage_uint;
	disp(['Shift down ' num2str(shiftPixel) ' pixel without Crop']);

% ================================================
% Shift right without Crop
% ================================================
elseif attackType == 2
	shiftPixel = para;
	attackedImage_uint = uint64(zeros(height, width+shiftPixel));
	attackedImage_uint(:, 1+shiftPixel:end) = originalImage_uint;
	disp(['Shift right ' num2str(shiftPixel) ' pixel without Crop']);

% ================================================
% Rotate with Crop
% ================================================
% elseif attackType == 4
% 	rotateDegree = para;
% 	rotatedImage = imrotate(originalImage_uint, rotateDegree);
% 	[temp_height, temp_width] = size(rotatedImage)
% 	if(temp_height > height && temp_width > width)
% 		% Croping
% 		topMargin = floor((temp_height - height)/2);
% 		leftMargin = floor((temp_width - width)/2);
% 		attackedImage_dbl = rotatedImage(topMargin+1:topMargin+height, leftMargin+1:leftMargin+width);
% 	end
% 	disp(['Rotate ' num2str(rotateDegree) ' degree with Crop']);

% ================================================
% Rotate without Crop
% ================================================
elseif attackType == 3
	% theta = deg2rad(para);
	% rotateMatrix = [cos(theta) sin(theta); -sin(theta) cos(theta)];
	% [fTableX, fTableY, fTableF_uint] = image2ftable(originalImage_uint);
	% fTableXY = [fTableX fTableY];
	% fTableXY = (rotateMatrix * fTableXY')';
	% fTableX = fTableXY(:, 1);
	% fTableY = fTableXY(:, 2);
	% attackedImage_uint = fTable2image(fTableX, fTableY, fTableF_uint);

	rotateDegree = para;
	attackedImage_uint = imrotate(uint8(originalImage_uint), rotateDegree, 'nearest');
	attackedImage_uint = uint64(attackedImage_uint);

	disp(['Rotate ' num2str(rotateDegree) ' degree without Crop']);

% ================================================
% Scale without Crop
% ================================================
elseif attackType == 4
	scaleSize = para;

	% [fTableX, fTableY, fTableF_uint] = image2ftable(originalImage_uint);
	% fTableX = fTableX * scaleSize;
	% fTableY = fTableY * scaleSize;
	% attackedImage_uint = fTable2image(fTableX, fTableY, fTableF_uint);

	attackedImage_uint = imresize(uint8(originalImage_uint), scaleSize);
	attackedImage_uint = uint64(attackedImage_uint);

	disp(['Scale ' num2str(scaleSize) ' without Crop']);

% ================================================
% Shearing in x without Crop
% ================================================
elseif attackType == 5
	[fTableX, fTableY, fTableF_uint] = image2ftable(originalImage_uint);
	fTableX = fTableX + fTableY * para;
	attackedImage_uint = fTable2image(fTableX, fTableY, fTableF_uint);

	disp(['Shearing in x without Crop']);

% ================================================
% Shearing in y without Crop
% ================================================
elseif attackType == 6
	[fTableX, fTableY, fTableF_uint] = image2ftable(originalImage_uint);
	fTableY = fTableX * para + fTableY;
	attackedImage_uint = fTable2image(fTableX, fTableY, fTableF_uint);

	% Ay = [1 0; para 1];
	% fTable = image2ftable(originalImage_uint);
	% fTable(:, 1:2) = round(Ay * fTable(:, 1:2)')';
	% attackedImage_dbl = fTable2image(fTable);

	disp(['Shearing in y without Crop']);

% ================================================
% Shearing in x&y without Crop
% ================================================
elseif attackType == 7
	[fTableX, fTableY, fTableF_uint] = image2ftable(originalImage_uint);
	fTableY = fTableX * para + fTableY;
	fTableX = fTableX + fTableY * para;
	attackedImage_uint = fTable2image(fTableX, fTableY, fTableF_uint);

	% Ax = [1 para; 0 1];
	% Ay = [1 0; para 1];
	% Axy = Ax * Ay;
	% fTable = image2ftable(originalImage_uint);
	% fTable(:, 1:2) = round(Axy * fTable(:, 1:2)')';
	% attackedImage_dbl = fTable2image(fTable);

	disp(['Shearing in x&y without Crop']);

% ================================================
% Abritrary matrix without Crop
% ================================================
elseif attackType == 8
	imwrite(uint8(originalImage_uint), './Experiment/compressed_temp.jpg', 'Quality', para);
	attackedImage_uint = uint64(imread('./Experiment/compressed_temp.jpg'));
	[fTableX, fTableY, fTableF_uint] = image2ftable(attackedImage_uint);
	disp(['JPEG Compression']);

% ================================================
% Abritrary matrix without Crop
% ================================================
elseif attackType == 9
	AbrMatrix = para * rand(2);
	disp('AbrMatrix==============start');
	AbrMatrix(1,1)
	det(AbrMatrix)
	disp('AbrMatrix==============end');

	tempImage = rgb2ycbcr(originalImage_uint);
	fTableY = image2ftable(tempImage(:, :, 1));
	fTableY(:, 1:2) = round(AbrMatrix * fTableY(:, 1:2)')';
	imageY = fTable2image(fTableY);

	fTableCb = image2ftable(tempImage(:, :, 2));
	fTableCb(:, 1:2) = round(AbrMatrix * fTableCb(:, 1:2)')';
	imageCb = fTable2image(fTableCb);

	fTableCr = image2ftable(tempImage(:, :, 3));
	fTableCr(:, 1:2) = round(AbrMatrix * fTableCr(:, 1:2)')';
	imageCr = fTable2image(fTableCr);

	squareSum = imageY.^2 + imageCb.^2 + imageCr.^2;
	blackEntryIdx = find(squareSum == 0);
	imageY(blackEntryIdx) = 16;
	imageCb(blackEntryIdx) = 128;
	imageCr(blackEntryIdx) = 128;

	[height, width] = size(imageY);
	attackedImage_dbl = zeros(height, width, 3);
	attackedImage_dbl(:, :, 1) = imageY;
	attackedImage_dbl(:, :, 2) = imageCb;
	attackedImage_dbl(:, :, 3) = imageCr;
	attackedImage_dbl = ycbcr2rgb(attackedImage_dbl);
	disp(['Arbitrary matrix without Crop']);

end

end
