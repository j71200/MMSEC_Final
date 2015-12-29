clear
clc

originalImage = imread('./Experiment/peppers_gray.bmp');
originalImage_dbl = double(originalImage);

% ==========================
% Normalization
% ==========================
normHeight = 512;
normWidth  = 512;
normalOriginImage_dbl = normalizeImage(originalImage_dbl, normHeight, normWidth, false);
normalOriginImage = uint8(normalOriginImage_dbl);

% imshow(normalOriginImage);

% ==========================
% Embedding Watermark
% ==========================
[normalHeight normalWidth] = size(normalOriginImage);















