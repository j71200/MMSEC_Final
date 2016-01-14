close all
clear
clc

img = imread('./Experiment/lena.bmp');
img = rgb2gray(img);

% img_dbl = double(img);

img_dct = dct2(img);

figure;
image(img_dct);


img_dct_round = round(img_dct);

diff_dct = img_dct_round - img_dct;
sum(sum(diff_dct^2))


img_dct_idct = idct2(img_dct);
img_dct_round_idct = idct2(img_dct_round);

diff_dct_idct = img_dct_round_idct - img_dct_idct;
sum(sum(diff_dct_idct^2))




