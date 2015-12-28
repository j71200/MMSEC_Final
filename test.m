clear('all');
clc

normHeight = 512;
normWidth  = 512;

x_min = -74.0918;
x_max = 412.3192001;
y_min = -24.6112;
y_max = 818.918204;
height = x_max - x_min + 1
width  = y_max - y_min + 1
mAlpha = normHeight / height
mDelta = normWidth / width

x_min_scale = mAlpha * x_min
x_max_scale = mAlpha * x_max
y_min_scale = mDelta * y_min
y_max_scale = mDelta * y_max

scaleHeight = x_max_scale - x_min_scale + 1
scaleWidth  = y_max_scale - y_min_scale + 1





% y_min = min(fTable3(:, 1));
% y_max = max(fTable3(:, 1));
% x_min = min(fTable3(:, 2));
% x_max = max(fTable3(:, 2));
% temp_height = y_max - y_min + 1;
% temp_width  = x_max - x_min + 1;
% mAlpha = normHeight / temp_height;
% mDelta = normWidth / temp_width;


% heightError = max(round(fTable3(:,1)*mAlpha)) - min(round(fTable3(:,1)*mAlpha)) + 1 - normHeight;
% widthError = max(round(fTable3(:,2)*mDelta)) - min(round(fTable3(:,2)*mDelta)) + 1 - normWidth;

