close all
clear
clc

originalImage = imread('./Experiment/airplane.bmp');
originalImage = rgb2gray(originalImage);
originalImage_dbl = double(originalImage);
isShowFig = true;

% % normHeight = 128;
% % normWidth  = 128;

% originalImage = imresize(originalImage, [normHeight, normWidth]);
% originalImage_dbl = double(originalImage);

if isShowFig
	figure('name', 'originalImage');
	imshow(originalImage);
end

% =================
% key gen
% =================
primeP = 17;
primeQ = 19;

% primeP = 991;
% primeQ = 997;

[n_pk, g_pk, lambda_sk, mu_sk] = paillierKeygen(primeP, primeQ);

% =================
% Encrypt
% =================
encImage_dbl = paillierEncrypt(originalImage_dbl, n_pk, g_pk);

encImage = uint8(encImage_dbl);
if isShowFig
	figure('name', 'encImage');
	imshow(encImage);
end

% fac = paillierEncrypt(10, n_pk, g_pk);
% encImage_dbl = mod(encImage_dbl * fac, n_pk^2);

% =================
% Decrypt
% =================
decImage_dbl = paillierDecrypt(encImage_dbl, n_pk, lambda_sk, mu_sk);

decImage = uint8(decImage_dbl);
if isShowFig
	figure('name', 'decImage');
	imshow(decImage);
end

