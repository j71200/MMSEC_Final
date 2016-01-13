close all
clear
clc


originalImage = imread('./Experiment/lena.bmp');
originalImage = rgb2gray(originalImage);

% originalImage = imresize(originalImage, [128, 128]);

originalImage_dbl = double(originalImage);


figure
% image(originalImage_dbl)
imshow(uint8(originalImage_dbl))

[height, width] = size(originalImage_dbl);

randA = rand(height, width);

rand_originalImage_dbl = randA * originalImage_dbl;

figure
% image(rand_originalImage_dbl)
imshow(uint8(rand_originalImage_dbl))

zz = randA^(-1) * rand_originalImage_dbl;
z = uint8(zz);
figure
imshow(z)


