close all
clear('all');
clc

% originalImage = imread('./Experiment/lena.bmp');
% originalImage = rgb2gray(originalImage);
% originalImage_uint = uint64(originalImage);



emptyImage = imread('./Experiment/img1.bmp');
colorImage = imread('./Experiment/img2.bmp');

emptyImage = rgb2gray(emptyImage);
colorImage = rgb2gray(colorImage);

emptyImage_uint = uint64(emptyImage);
colorImage_uint = uint64(colorImage);



normHeight = 512;
normWidth  = 512;

isShowProcess = false;
selectBeta = 2;

% ======================================
[normEmptyImage_uint, normFTableX, normFTableY, normFTableF_uint, SYXMatrix, meanVector] = normalizeImage( emptyImage_uint, normHeight, normWidth, isShowProcess, selectBeta);

figure('name','normEmptyImage_uint');
imshow(uint8(normEmptyImage_uint));


[normColorImage_uint, normFTableX, normFTableY, normFTableF_uint, SYXMatrix, meanVector] = normalizeImage( colorImage_uint, normHeight, normWidth, isShowProcess, selectBeta);

figure('name','normColorImage_uint');
imshow(uint8(normColorImage_uint));



% [fTableX, fTableY, fTableF_uint] = image2ftable(originalImage_uint);
% fTableX = fTableX + fTableY * para;
% attackedImage_uint = fTable2image(fTableX, fTableY, fTableF_uint);

% figure('name','attackedImage_uint');
% imshow(uint8(attackedImage_uint));

% ======================================






% attackedImage = imsharpen(originalImage);
% attackedImage_uint = uint64(attackedImage);










