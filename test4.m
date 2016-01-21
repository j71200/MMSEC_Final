clear
clc

originalImage = imread('./Experiment/lena.bmp');

originalImage = rgb2gray(originalImage);

imwrite(originalImage, './Experiment/compressed_lena.jpg', 'Quality', 10);
attack = imread('./Experiment/compressed_lena.jpg');

