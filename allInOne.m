function [] = allInOne(originalImage, attackType, isShowFig)

% originalImage = imread('./Experiment/airplane.bmp');
% originalImage = imread('./Experiment/baboon.bmp');
% originalImage = imread('./Experiment/fruits.bmp');
% originalImage = imread('./Experiment/airplane.bmp');

originalImage = rgb2gray(originalImage);
% originalImage = imread('./Experiment/peppers_gray.bmp');
% figure
% imshow(originalImage)
% title('originalImage')
originalImage_dbl = double(originalImage);

% ==========================
% Normalization I - Original
% ==========================
normHeight = 512;
normWidth  = 512;
[normalOriginImage_dbl, normFTable, SYXMatrix, meanVector] = normalizeImage(originalImage_dbl, normHeight, normWidth, false);
normalOriginImage = uint8(normalOriginImage_dbl);
if isShowFig
	figure
	imshow(normalOriginImage)
	title('normalOriginImage')
end

% ==========================
% Embedding Watermark
% ==========================
[normalHeight normalWidth] = size(normalOriginImage);

% Step 2-(a)
load('data_wm256_pt256x256');
% wmSize = 256; % 8KB
% watermark = randi([0, 1], wmSize, 1);
% patternSize = normHeight * normWidth;
% patterns = sign(randn(patternSize, wmSize));

% Step 2-(b)
wmSignature1 = patterns * (2*watermark - 1);

% Step 2-(c)
[zigzagColMajor ~] = genaralZigzag(normHeight, normWidth);
wmSignature2 = zeros(normHeight, normWidth);
imageArea = length(zigzagColMajor);
middle_band_idx = zigzagColMajor(1+3*imageArea/8:3*imageArea/8 + patternSize);
wmSignature2(middle_band_idx) = wmSignature1;

% Step 2-(d)
wmSignature2_idct = idct2(wmSignature2);

% Step 3
maskImage = normalOriginImage > 0;

% Step 4
wmSignature = maskImage .* wmSignature2_idct;

% Step 5
% normFTable(:, 1:2) = (SYXMatrix^(-1) * normFTable(:, 1:2)')';
% normFTable(:, 1) = normFTable(:, 1) + meanVector(1);
% normFTable(:, 2) = normFTable(:, 2) + meanVector(2);
% recoverImg = fTable2image(normFTable);
% figure
% imshow(recoverImg)


wmSignFTable = img2ftable(wmSignature);
wmSignFTable(:, 1:2) = (SYXMatrix^(-1) * wmSignFTable(:, 1:2)')';
wmSignFTable(:, 1) = wmSignFTable(:, 1) + meanVector(1);
wmSignFTable(:, 2) = wmSignFTable(:, 2) + meanVector(2);

wmSignature_reg = fTable2image(wmSignFTable);
size(wmSignature_reg)

% Step 6
% size(originalImage_dbl)
% size(wmSignature_reg)
wmSignature_reg = double(wmSignature_reg);
wmImage = originalImage_dbl + wmSignature_reg(2:end-1, 2:end-1);
wmImage = uint8(wmImage);

if isShowFig
	figure
	imshow(wmImage)
	title('wmImage')
end
% ==========================
% Attack
% ==========================
% attackType = 9;
%1 - Shift down without Crop
%2 - Shift right without Crop
%3 - Rotate without Crop
%4 - Scale without Crop
%5 - Shearing in x without Crop
%6 - Shearing in y without Crop
%7 - Shearing in x&y without Crop
%8 - Arbitrary matrix without Crop
paraList = zeros(8, 1);
paraList(1) = 200;
paraList(2) = 200;
paraList(3) = 30;
paraList(4) = 1.5;
paraList(5) = 1;
paraList(6) = 1;
paraList(7) = 1;
paraList(8) = 2;
attWMImage = attackGray(wmImage, attackType, paraList(attackType));

if isShowFig
	figure
	imshow(attWMImage)
	title('attWMImage')
end

% To be deleted
% attWMImage = wmImage;

% ==========================
% Normalization II - Attack
% ==========================
attWMImage_dbl = double(attWMImage);
[normalAttImage_dbl, normAttFTable, attSYXMatrix, attMeanVector] = normalizeImage(attWMImage_dbl, normHeight, normWidth, false);

normalAttImage = uint8(normalAttImage_dbl);

if isShowFig
	figure
	imshow(normalAttImage)
	title('normalAttImage')
end

dif = normalAttImage_dbl - normalOriginImage_dbl;
psnr(normalAttImage, normalOriginImage)
figure
spy(dif)

% ==========================
% Extraction
% ==========================
% Step 2-(a)
% Regenerate the watermark patterns - DONE

% Step 2-(b)
normalAttImage_dct = dct2(normalAttImage);

% Step 2-(c)
% middle_band_idx = zigzagColMajor(1+3*imageArea/8:3*imageArea/8 + patternSize);
% wmSignature2(middle_band_idx) = wmSignature1;
cw = normalAttImage_dct(middle_band_idx);

% Step 2-(d)
extractedWM = patterns' * cw;
extractedWM = extractedWM > 0;

wmDiff = extractedWM - watermark;
% [watermark extractedWM]
bitErrorRate = 100 * nnz(wmDiff) / length(watermark)




end






