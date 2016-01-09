close all
clear('all');
clc

originalImage = imread('./Experiment/airplane.bmp');
% originalImage = imread('./Experiment/baboon.bmp');
originalImage = rgb2gray(originalImage);
originalImage_dbl = double(originalImage);
figure
imshow(uint8(originalImage_dbl))
origTable = img2ftable(originalImage_dbl);
nnz(origTable(:,3))

[ normalizedImg, normFTable, SYXMatrix, meanVector ] = normalizeImage( originalImage_dbl, 512, 512, false);
figure
imshow(uint8(normalizedImg))
nnz(normFTable(:,3))

% newTable = img2ftable(normalizedImg);
newTable = normFTable;
newTable(:, 1:2) = (SYXMatrix^(-1) * newTable(:, 1:2)')';
newTable(:, 1) = newTable(:, 1) + meanVector(1);
newTable(:, 2) = newTable(:, 2) + meanVector(2);

regImg_dbl = fTable2image(newTable);
figure
imshow(uint8(regImg_dbl))
nnz(newTable(:,3))


psnr(uint8(regImg_dbl), uint8(originalImage_dbl))


