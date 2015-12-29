function attackedImage = attack(attackType, para)

originalImage = imread('./airplane.bmp');
[height, width, ~] = size(originalImage);

% 1 - Shift down with Crop
%#2 - Shift down without Crop
%#3 - Shift right without Crop
% 4 - Rotate with Crop
%#5 - Rotate without Crop
%#6 - Scale without Crop
%#7 - Shearing in x without Crop
%#8 - Shearing in y without Crop
%#9 - Shearing in x&y without Crop
%10 - Arbitrary matrix without Crop

% ================================================
% Shift down with Crop
% ================================================
if attackType == 1
	shiftPixel = para;
	attackedImage = uint8(zeros(size(originalImage)));
	attackedImage(shiftPixel + 1:end, :, :) = originalImage(1:end - shiftPixel, :, :);
	disp(['Shift down ' num2str(shiftPixel) ' pixel with Crop']);


% ================================================
% Shift down without Crop
% ================================================
elseif attackType == 2
	shiftPixel = para;
	attackedImage = uint8(zeros(height+shiftPixel, width, 3));
	attackedImage(1+shiftPixel:end, :, :) = originalImage;
	disp(['Shift down ' num2str(shiftPixel) ' pixel without Crop']);

% ================================================
% Shift right without Crop
% ================================================
elseif attackType == 3
	shiftPixel = para;
	attackedImage = uint8(zeros(height, width+shiftPixel, 3));
	attackedImage(:, 1+shiftPixel:end, :) = originalImage;
	disp(['Shift right ' num2str(shiftPixel) ' pixel without Crop']);

% ================================================
% Rotate with Crop
% ================================================
elseif attackType == 4
	rotateDegree = para;
	rotatedImage = imrotate(originalImage, rotateDegree);
	[temp_height, temp_width, ~] = size(rotatedImage)
	if(temp_height > height && temp_width > width)
		% Croping
		topMargin = floor((temp_height - height)/2);
		leftMargin = floor((temp_width - width)/2);
		attackedImage = rotatedImage(topMargin+1:topMargin+height, leftMargin+1:leftMargin+width, :);
	end
	disp(['Rotate ' num2str(rotateDegree) ' degree with Crop']);

% ================================================
% Rotate without Crop
% ================================================
elseif attackType == 5
	rotateDegree = para;
	attackedImage = imrotate(originalImage, rotateDegree, 'nearest');
	% attackedImage = imrotate(originalImage, rotateDegree, 'bilinear');
	% attackedImage = imrotate(originalImage, rotateDegree, 'bicubic');
	disp(['Rotate ' num2str(rotateDegree) ' degree without Crop']);

% ================================================
% Scale without Crop
% ================================================
elseif attackType == 6
	scaleSize = para;
	attackedImage = imresize(originalImage, scaleSize);
	disp(['Scale ' num2str(scaleSize) ' without Crop']);

% ================================================
% Shearing in x without Crop
% ================================================
elseif attackType == 7
	Ax = [1 para; 0 1];

	tempImage = rgb2ycbcr(originalImage);
	fTableY = constructF(tempImage(:, :, 1));
	fTableY(:, 1:2) = round(Ax * fTableY(:, 1:2)')';
	imageY = fTable2image(fTableY);

	fTableCb = constructF(tempImage(:, :, 2));
	fTableCb(:, 1:2) = round(Ax * fTableCb(:, 1:2)')';
	imageCb = fTable2image(fTableCb);

	fTableCr = constructF(tempImage(:, :, 3));
	fTableCr(:, 1:2) = round(Ax * fTableCr(:, 1:2)')';
	imageCr = fTable2image(fTableCr);

	squareSum = imageY.^2 + imageCb.^2 + imageCr.^2;
	blackEntryIdx = find(squareSum == 0);
	imageY(blackEntryIdx) = 16;
	imageCb(blackEntryIdx) = 128;
	imageCr(blackEntryIdx) = 128;

	[height, width] = size(imageY);
	attackedImage = uint8(zeros(height, width, 3));
	attackedImage(:, :, 1) = imageY;
	attackedImage(:, :, 2) = imageCb;
	attackedImage(:, :, 3) = imageCr;
	attackedImage = ycbcr2rgb(attackedImage);
	disp(['Shearing in x without Crop']);

% ================================================
% Shearing in y without Crop
% ================================================
elseif attackType == 8
	Ay = [1 0; para 1];

	tempImage = rgb2ycbcr(originalImage);
	fTableY = constructF(tempImage(:, :, 1));
	fTableY(:, 1:2) = round(Ay * fTableY(:, 1:2)')';
	imageY = fTable2image(fTableY);

	fTableCb = constructF(tempImage(:, :, 2));
	fTableCb(:, 1:2) = round(Ay * fTableCb(:, 1:2)')';
	imageCb = fTable2image(fTableCb);

	fTableCr = constructF(tempImage(:, :, 3));
	fTableCr(:, 1:2) = round(Ay * fTableCr(:, 1:2)')';
	imageCr = fTable2image(fTableCr);

	squareSum = imageY.^2 + imageCb.^2 + imageCr.^2;
	blackEntryIdx = find(squareSum == 0);
	imageY(blackEntryIdx) = 16;
	imageCb(blackEntryIdx) = 128;
	imageCr(blackEntryIdx) = 128;

	[height, width] = size(imageY);
	attackedImage = uint8(zeros(height, width, 3));
	attackedImage(:, :, 1) = imageY;
	attackedImage(:, :, 2) = imageCb;
	attackedImage(:, :, 3) = imageCr;
	attackedImage = ycbcr2rgb(attackedImage);
	disp(['Shearing in y without Crop']);

% ================================================
% Shearing in x&y without Crop
% ================================================
elseif attackType == 9
	Ax = [1 para; 0 1];
	Ay = [1 0; para 1];
	Axy = Ax * Ay;

	tempImage = rgb2ycbcr(originalImage);
	fTableY = constructF(tempImage(:, :, 1));
	fTableY(:, 1:2) = round(Axy * fTableY(:, 1:2)')';
	imageY = fTable2image(fTableY);

	fTableCb = constructF(tempImage(:, :, 2));
	fTableCb(:, 1:2) = round(Axy * fTableCb(:, 1:2)')';
	imageCb = fTable2image(fTableCb);

	fTableCr = constructF(tempImage(:, :, 3));
	fTableCr(:, 1:2) = round(Axy * fTableCr(:, 1:2)')';
	imageCr = fTable2image(fTableCr);

	squareSum = imageY.^2 + imageCb.^2 + imageCr.^2;
	blackEntryIdx = find(squareSum == 0);
	imageY(blackEntryIdx) = 16;
	imageCb(blackEntryIdx) = 128;
	imageCr(blackEntryIdx) = 128;

	[height, width] = size(imageY);
	attackedImage = uint8(zeros(height, width, 3));
	attackedImage(:, :, 1) = imageY;
	attackedImage(:, :, 2) = imageCb;
	attackedImage(:, :, 3) = imageCr;
	attackedImage = ycbcr2rgb(attackedImage);
	disp(['Shearing in x&y without Crop']);

% ================================================
% Abritrary matrix without Crop
% ================================================
elseif attackType == 10
	AbrMatrix = para * rand(2);
	disp('AbrMatrix==============start');
	AbrMatrix(1,1)
	det(AbrMatrix)
	disp('AbrMatrix==============end');

	tempImage = rgb2ycbcr(originalImage);
	fTableY = constructF(tempImage(:, :, 1));
	fTableY(:, 1:2) = round(AbrMatrix * fTableY(:, 1:2)')';
	imageY = fTable2image(fTableY);

	fTableCb = constructF(tempImage(:, :, 2));
	fTableCb(:, 1:2) = round(AbrMatrix * fTableCb(:, 1:2)')';
	imageCb = fTable2image(fTableCb);

	fTableCr = constructF(tempImage(:, :, 3));
	fTableCr(:, 1:2) = round(AbrMatrix * fTableCr(:, 1:2)')';
	imageCr = fTable2image(fTableCr);

	squareSum = imageY.^2 + imageCb.^2 + imageCr.^2;
	blackEntryIdx = find(squareSum == 0);
	imageY(blackEntryIdx) = 16;
	imageCb(blackEntryIdx) = 128;
	imageCr(blackEntryIdx) = 128;

	[height, width] = size(imageY);
	attackedImage = uint8(zeros(height, width, 3));
	attackedImage(:, :, 1) = imageY;
	attackedImage(:, :, 2) = imageCb;
	attackedImage(:, :, 3) = imageCr;
	attackedImage = ycbcr2rgb(attackedImage);
	disp(['Arbitrary matrix without Crop']);

end

imwrite(attackedImage, './airplane_attacked.bmp');


end
