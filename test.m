% close all
% clear
% clc


a = imread('./airplane.bmp');

b = imresize(a, 0.5);

imwrite(b, './small_airplane.bmp');


% orig_fTable = constructF(normalOriginImage);
% orig_mu_3_0 = centralMoment(orig_fTable, 3, 0)

% susp_fTable = constructF(normalSuspImage);
% susp_mu_3_0 = centralMoment(orig_fTable, 3, 0)




