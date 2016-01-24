close all
clear
clc

originalImage = imread('./Experiment/lena.bmp');
originalImage = rgb2gray(originalImage);
originalImage = imresize(originalImage, [64, 64]);
originalImage_uint = uint64(originalImage);

% =================
% KeyGen
% =================
p_uint = uint64(251);
q_uint = uint64(257);
p_uint = uint64(17);
q_uint = uint64(19);
r_uint = 3;

[n_uint, g_uint, lambda_uint, mu_uint] = paillierKeygen(p_uint, q_uint);
nSquare_uint = n_uint^2;

% ==========================
% Encrypt Image
% ==========================
encryptedImg_uint = paillierEncrypt(originalImage_uint + 1, n_uint, g_uint, r_uint);

[imgSum, imgMax, imgMin, imgNNZ, accVector1] = statImage(encryptedImg_uint);
figure;
plot(accVector1, 'b');





attackedImage = imrotate(originalImage, 30);
attackedImage_uint = uint64(attackedImage);

occIdx = find(attackedImage_uint);
attackedImage_uint(occIdx) = attackedImage_uint(occIdx)+1;

encryptedAttImage_uint = paillierEncrypt(attackedImage_uint, n_uint, g_uint, r_uint);

[imgSum, imgMax, imgMin, imgNNZ, accVector2] = statImage(encryptedAttImage_uint);

hold on
plot(accVector2(2:end), 'r')




