% close all
% clear
% clc

x=5;
fileID = fopen(['./RotationMatrixResult/www.txt'], 'w');
fprintf(fileID,'%6s %12s\n','x','exp(x)');
% fprintf(fileID,'%6s %12s\n','x','exp(x)');
% fprintf(fileID,'%6.2f %12.8f\n',A);
fclose(fileID);


% a = imread('./airplane.bmp');

% b = imresize(a, 0.5);

% imwrite(b, './small_airplane.bmp');


% orig_fTable = constructF(normalOriginImage);
% orig_mu_3_0 = centralMoment(orig_fTable, 3, 0)

% susp_fTable = constructF(normalSuspImage);
% susp_mu_3_0 = centralMoment(orig_fTable, 3, 0)




