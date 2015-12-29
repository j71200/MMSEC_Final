close all
clear('all');
clc


originalImage = imread('./Experiment/peppers.bmp');
% originalImage = rgb2ycbcr(originalImage);
% originalImageY = originalImage(:, :, 1);
originalImage = rgb2gray(originalImage);

imwrite(originalImage, './Experiment/peppers_gray.bmp')
% figure;
% imshow(originalImage);

% originalDCT = dct2(originalImage);
% x = 256;
% y = 256;
% % originalDCT(x:x+3, y:y+3)
% originalDCT(x, y) = originalDCT(x, y) + 8888;
% % originalDCT(x:x+3, y:y+3)

% modifiedImage = uint8(idct2(originalDCT));

% figure;
% imshow(modifiedImage);
