% close all
% clear
% clc

orig_fTable = constructF(normalOriginImage);
orig_mu_3_0 = centralMoment(orig_fTable, 3, 0)

susp_fTable = constructF(normalSuspImage);
susp_mu_3_0 = centralMoment(orig_fTable, 3, 0)







% 16, 128, 128

% aa = uint8(zeros(512, 512, 3)) + 100;
% figure
% imshow(aa)


% bb = rgb2ycbcr(aa);
% bb(:, :, 1) = uint8(zeros(512, 512)) + 16;
% bb(:, :, 2) = uint8(zeros(512, 512)) + 128;
% bb(:, :, 3) = uint8(zeros(512, 512)) + 128;
% % bb(1:256, 1:256, :) = zeros(256, 256, 3);

% figure
% imshow(bb)

% cc = ycbcr2rgb(bb);
% figure
% imshow(cc)

% dd = cc;
% cc_squareSum = cc(:,:,1).^2 + cc(:,:,2).^2 + cc(:,:,3).^2;
% greenIdx = find(cc_squareSum ~= 0);
% dd(greenIdx) = 255;
% figure
% imshow(dd)


