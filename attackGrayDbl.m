function attackedImage_dbl = attackGrayDbl(originalImage_dbl, attackType, para)

% originalImage_dbl = imread('./airplane.bmp');
[height, width] = size(originalImage_dbl);

%1 - Shift down without Crop
%2 - Shift right without Crop
%3 - Rotate without Crop
%4 - Scale without Crop
%5 - Shearing in x without Crop
%6 - Shearing in y without Crop
%7 - Shearing in x&y without Crop
%8 - Arbitrary matrix without Crop

% ================================================
% Shift down with Crop
% ================================================
% if attackType == 1
% 	shiftPixel = para;
% 	attackedImage_dbl = zeros(size(originalImage_dbl));
% 	attackedImage_dbl(shiftPixel + 1:end, :) = originalImage_dbl(1:end - shiftPixel, :);
% 	disp(['Shift down ' num2str(shiftPixel) ' pixel with Crop']);


% ================================================
% Shift down without Crop
% ================================================
if attackType == 1
	shiftPixel = para;
	attackedImage_dbl = zeros(height+shiftPixel, width);
	attackedImage_dbl(1+shiftPixel:end, :) = originalImage_dbl;
	disp(['Shift down ' num2str(shiftPixel) ' pixel without Crop']);

% ================================================
% Shift right without Crop
% ================================================
elseif attackType == 2
	shiftPixel = para;
	attackedImage_dbl = zeros(height, width+shiftPixel);
	attackedImage_dbl(:, 1+shiftPixel:end) = originalImage_dbl;
	disp(['Shift right ' num2str(shiftPixel) ' pixel without Crop']);

% ================================================
% Rotate with Crop
% ================================================
% elseif attackType == 4
% 	rotateDegree = para;
% 	rotatedImage = imrotate(originalImage_dbl, rotateDegree);
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
	rotateDegree = para;
	attackedImage_dbl = imrotate(originalImage_dbl, rotateDegree, 'nearest');
	% attackedImage_dbl = imrotate(originalImage_dbl, rotateDegree, 'bilinear');
	% attackedImage_dbl = imrotate(originalImage_dbl, rotateDegree, 'bicubic');
	disp(['Rotate ' num2str(rotateDegree) ' degree without Crop']);

% ================================================
% Scale without Crop
% ================================================
elseif attackType == 4
	scaleSize = para;
	attackedImage_dbl = imresize(originalImage_dbl, scaleSize);
	disp(['Scale ' num2str(scaleSize) ' without Crop']);

% ================================================
% Shearing in x without Crop
% ================================================
elseif attackType == 5
	Ax = [1 para; 0 1];

	fTable = img2ftable(originalImage_dbl);
	fTable(:, 1:2) = round(Ax * fTable(:, 1:2)')';
	attackedImage_dbl = fTable2image(fTable);

	disp(['Shearing in x without Crop']);

% ================================================
% Shearing in y without Crop
% ================================================
elseif attackType == 6
	Ay = [1 0; para 1];

	fTable = img2ftable(originalImage_dbl);
	fTable(:, 1:2) = round(Ay * fTable(:, 1:2)')';
	attackedImage_dbl = fTable2image(fTable);

	disp(['Shearing in y without Crop']);

% ================================================
% Shearing in x&y without Crop
% ================================================
elseif attackType == 7
	Ax = [1 para; 0 1];
	Ay = [1 0; para 1];
	Axy = Ax * Ay;

	fTable = img2ftable(originalImage_dbl);
	fTable(:, 1:2) = round(Axy * fTable(:, 1:2)')';
	attackedImage_dbl = fTable2image(fTable);

	disp(['Shearing in x&y without Crop']);

% ================================================
% Abritrary matrix without Crop
% ================================================
elseif attackType == 8
	AbrMatrix = para * rand(2);
	disp('AbrMatrix==============start');
	AbrMatrix(1,1)
	det(AbrMatrix)
	disp('AbrMatrix==============end');

	tempImage = rgb2ycbcr(originalImage_dbl);
	fTableY = img2ftable(tempImage(:, :, 1));
	fTableY(:, 1:2) = round(AbrMatrix * fTableY(:, 1:2)')';
	imageY = fTable2image(fTableY);

	fTableCb = img2ftable(tempImage(:, :, 2));
	fTableCb(:, 1:2) = round(AbrMatrix * fTableCb(:, 1:2)')';
	imageCb = fTable2image(fTableCb);

	fTableCr = img2ftable(tempImage(:, :, 3));
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
