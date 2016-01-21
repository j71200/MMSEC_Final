close all; clear; clc;

% originalImage = imread('./Experiment/airplane.bmp');
originalImage = imread('./Experiment/baboon.bmp');
% originalImage = imread('./Experiment/fruits.bmp');
% originalImage = imread('./Experiment/peppers.bmp');
% originalImage = imread('./Experiment/lena.bmp');

originalImage = rgb2gray(originalImage);
originalImage_uint = uint64(originalImage);

%1 - Shift down without Crop
%2 - Shift right without Crop
%3 - Rotate without Crop
%4 - Scale without Crop
%5 - Shearing in x without Crop
%6 - Shearing in y without Crop
%7 - Shearing in x&y without Crop
%8 - JPEG Compression

newAllInOne(originalImage_uint, 3, true);
% newAllInOne(originalImage_uint, 3, false);

% for attackType = 1:8
% 	newAllInOne(originalImage_uint, attackType, false);
% end



