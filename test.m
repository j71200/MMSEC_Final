close all
clear('all');
clc

originalImage = imread('./Experiment/airplane.bmp');
originalImage_dbl = double(rgb2gray(originalImage));

% a = randi([0, 255], 5)
% a = originalImage_dbl(11:15, 11:15);
figure
imshow(uint8(a))
r = rand(5);

da = dct2(a);
ra = r * a;

rda = r * da
dra = dct2(ra)






% originalImage = imread('./Experiment/airplane.bmp');
% % originalImage = imread('./Experiment/baboon.bmp');
% originalImage = rgb2gray(originalImage);
% originalImage_dbl = double(originalImage);
% figure
% imshow(uint8(originalImage_dbl))
% origTable = img2ftable(originalImage_dbl);
% nnz(origTable(:,3))

% [ normalizedImg, normFTable, SYXMatrix, meanVector ] = normalizeImage( originalImage_dbl, 512, 512, false);
% figure
% imshow(uint8(normalizedImg))
% nnz(normFTable(:,3))


% normFTable(:, 3) = normFTable(:, 3) + 50;




% % newTable = img2ftable(normalizedImg);
% newTable = normFTable;
% newTable(:, 1:2) = (SYXMatrix^(-1) * newTable(:, 1:2)')';
% newTable(:, 1) = newTable(:, 1) + meanVector(1);
% newTable(:, 2) = newTable(:, 2) + meanVector(2);

% regImg_dbl = fTable2image(newTable);
% figure
% imshow(uint8(regImg_dbl))
% nnz(newTable(:,3))


% psnr(uint8(regImg_dbl), uint8(originalImage_dbl))







% dif = regImg_dbl - originalImage_dbl;
% figure
% imshow(uint8(dif))


% newTable(:, 1:2) = (SYXMatrix^(-1) * normFTable(:, 1:2)')';
% newTable(:, 1) = newTable(:, 1) + meanVector(1);
% newTable(:, 2) = newTable(:, 2) + meanVector(2);

% regImg_dbl = fTable2image(newTable);
% figure
% imshow(uint8(regImg_dbl))

% addpath('./RSA')
% p = 991;
% q = 997;

% p = 269;
% q = 271;

% [N_pk, Phi, d_sk, e_pk] = intialize(p,q);

% im = imread('./Experiment/lena.bmp');
% im = rgb2gray(im);
% im_dbl = double(im);

% % im_dbl = randi([0, 255], 5);
% % figure
% % image(im_dbl)

% startEncTime = clock;
% disp(['Start encode:' num2str(startEncTime(2)) '-' num2str(startEncTime(3)) ' ' num2str(startEncTime(4)) ':' num2str(startEncTime(5)) ]);
% encIm_dbl = cryptImage(im_dbl, N_pk, e_pk);
% % figure
% % image(encIm_dbl)
% endEncTime = clock;
% disp(['End encode:' num2str(endEncTime(2)) '-' num2str(endEncTime(3)) ' ' num2str(endEncTime(4)) ':' num2str(endEncTime(5)) ]);




% startDecTime = clock;
% disp(['Start decode:' num2str(startDecTime(2)) '-' num2str(startDecTime(3)) ' ' num2str(startDecTime(4)) ':' num2str(startDecTime(5)) ]);
% decIm_dbl = cryptImage(encIm_dbl, N_pk, d_sk);
% % figure
% % image(decIm_dbl)
% endDecTime = clock;
% disp(['End decode:' num2str(endDecTime(2)) '-' num2str(endDecTime(3)) ' ' num2str(endDecTime(4)) ':' num2str(endDecTime(5)) ]);



