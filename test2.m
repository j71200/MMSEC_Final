close all
clear
clc

% N_pk = 72899;
% e_pk = 7;
% d_sk = 62023;
% M = 124; % 53280

% % mc = crypt(M,N_pk,e_pk)
% % recC = crypt(mc,N_pk,d_sk)

% % smallPlainImage_dbl = zeros(2) + M;
% smallPlainImage_dbl = 100* [21, 491; 87, 123];
% encryptedImg_dbl = cryptImage(smallPlainImage_dbl, N_pk, e_pk)

% aa = cryptImage(encryptedImg_dbl, N_pk, d_sk)

% dsfj=sfji;


plainImage = imread('./Experiment/lena.bmp');
plainImage = rgb2gray(plainImage);

plainImage_dbl = double(plainImage);


outputSize = [128, 128];
% outputSize = [32, 32];
% smallPlainImage_dbl = imresize(plainImage_dbl, outputSize);
smallPlainImage = imresize(plainImage, outputSize);

smallPlainImage_dbl = double(smallPlainImage);


N_pk = 72899;
e_pk = 7;

tic
encryptedImg_dbl = cryptImage(smallPlainImage_dbl, N_pk, e_pk);
toc

d_sk = 62023;
tic
decryptedImg_dbl = cryptImage(encryptedImg_dbl, N_pk, d_sk);
toc



smallPlainImage = uint8(smallPlainImage_dbl);
encryptedImg = uint8(encryptedImg_dbl);
decryptedImg = uint8(decryptedImg_dbl);

figure('name', 'smallPlainImage');
imshow(smallPlainImage);

figure('name', 'encryptedImg');
imshow(encryptedImg);

figure('name', 'decryptedImg');
imshow(decryptedImg);






