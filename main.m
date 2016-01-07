close all
clear
clc

% originalImage = imread('./Experiment/airplane.bmp');
% originalImage = imread('./Experiment/baboon.bmp');
% originalImage = imread('./Experiment/fruits.bmp');
% originalImage = imread('./Experiment/peppers.bmp');
originalImage = imread('./Experiment/lena.bmp');


%1 - Shift down without Crop
%2 - Shift right without Crop
%3 - Rotate without Crop
%4 - Scale without Crop
%5 - Shearing in x without Crop
%6 - Shearing in y without Crop
%7 - Shearing in x&y without Crop

allInOne(originalImage, 1, true);

% for attackType = 1:7
% 	allInOne(originalImage, attackType, true);
% end








