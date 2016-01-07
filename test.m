close all
clear('all');
clc

originalImage = imread('./Experiment/airplane.bmp');
originalImage = rgb2gray(originalImage);
aa = dct2(originalImage);
aa(1,1)

originalImage = imread('./Experiment/baboon.bmp');
originalImage = rgb2gray(originalImage);
aa = dct2(originalImage);
aa(1,1)

originalImage = imread('./Experiment/fruits.bmp');
originalImage = rgb2gray(originalImage);
aa = dct2(originalImage);
aa(1,1)

originalImage = imread('./Experiment/peppers.bmp');
originalImage = rgb2gray(originalImage);
aa = dct2(originalImage);
aa(1,1)

originalImage = imread('./Experiment/lena.bmp');
originalImage = rgb2gray(originalImage);
aa = dct2(originalImage);
aa(1,1)


% H = 57.2109513313366;
% L = -61.6712173299277;
% x = linspace(4.2, 4.4, 1000);
% y = round(x*H) - round(x*L);
% plot(x,y)



% originalImage = imread('./Experiment/lena.png');
% imwrite(originalImage, './Experiment/lena.bmp')

% figure
% title('My title')


