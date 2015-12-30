close all
clear
clc

originalImage = imread('./Experiment/peppers_gray.bmp');
figure
imshow(originalImage)
originalImage_dbl = double(originalImage);

% ==========================
% Normalization
% ==========================
normHeight = 512;
normWidth  = 512;
[normalOriginImage_dbl, normFTable, SYXMatrix, meanVector] = normalizeImage(originalImage_dbl, normHeight, normWidth, false);
normalOriginImage = uint8(normalOriginImage_dbl);

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
wmSignFTable = constructF(wmSignature);
wmSignFTable(:, 1:2) = (SYXMatrix^(-1) * wmSignFTable(:, 1:2)')';
wmSignFTable(:, 1) = wmSignFTable(:, 1) + meanVector(1);
wmSignFTable(:, 2) = wmSignFTable(:, 2) + meanVector(2);

wmSignature_reg = fTable2image(wmSignFTable);

% % Step 6
size(originalImage_dbl)
size(wmSignature_reg)

wmSignature_reg = double(wmSignature_reg);
wmImage = originalImage_dbl + wmSignature_reg(2:end-1, 2:end-1);
wmImage = uint8(wmImage);

figure
imshow(wmImage)

% ==========================
% Attack
% ==========================
attWMImage = attack2(wmImage, 2, 200);
figure
imshow(attWMImage)






