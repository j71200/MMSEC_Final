function [ normalizedImg_uint, normFTableX, normFTableY, normFTableF_uint, SYXMatrix, meanVector ] = normalizeImage( inputImage_uint, normHeight, normWidth, showProcessFlag)
%NORMALIZEIMAGE Summary of this function goes here
%   Detailed explanation goes here

[fTableX, fTableY, fTableF_uint] = image2ftable( inputImage_uint );

% =====================
% Centerlizing
% =====================
disp('In normalizeImage: Centerlizing');
currentTime = clock;
disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);
m_1_0_uint = geoMoment(fTableX, fTableY, fTableF_uint, 1, 0);
m_0_0_uint = geoMoment(fTableX, fTableY, fTableF_uint, 0, 0);
m_0_1_uint = geoMoment(fTableX, fTableY, fTableF_uint, 0, 1);
x_mean = double(m_1_0_uint) / double(m_0_0_uint);
y_mean = double(m_0_1_uint) / double(m_0_0_uint);
meanVector = [x_mean; y_mean];

fTableX1 = fTableX - x_mean;
fTableY1 = fTableY - y_mean;
fTableF1_uint = fTableF_uint;


% if showProcessFlag
% 	im1_uint = fTable2image(fTableX, fTableY, fTableF_uint);
% 	figure;
% 	imshow(uint8(im1_uint));
% end


% =====================
% Shearing in x
% =====================
disp('In normalizeImage: Shearing in x');
currentTime = clock;
disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);
mu_0_3_dbl = centralMoment(fTableX1, fTableY1, fTableF1_uint, 0, 3);
mu_1_2_dbl = centralMoment(fTableX1, fTableY1, fTableF1_uint, 1, 2);
mu_2_1_dbl = centralMoment(fTableX1, fTableY1, fTableF1_uint, 2, 1);
mu_3_0_dbl = centralMoment(fTableX1, fTableY1, fTableF1_uint, 3, 0);

syms x;
mBeta = double(solve(mu_0_3_dbl*x^3 + 3*mu_1_2_dbl*x^2 + 3*mu_2_1_dbl*x + mu_3_0_dbl, x, 'Real', true));
if length(mBeta) > 1
	mBeta = sort(mBeta);
	mBeta = mBeta(2);
end

Ax = [1 mBeta; 0 1];

fTableX2 = fTableX1 + mBeta * fTableY1;
fTableY2 = fTableY1;
fTableF2_uint = fTableF1_uint;

% if showProcessFlag
% 	im2_dbl = fTable2image(fTable2);
% 	disp('fTable2(1:10,:)')
% 	disp(fTable2(1:10,:))
% 	figure;
% 	imshow(uint8(im2_dbl));
% 	disp('size(im2_dbl)');
% 	size(im2_dbl)
% end


% =====================
% Shearing in y
% =====================
disp('In normalizeImage: Shearing in y');
currentTime = clock;
disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);
mu_1_1_dbl = centralMoment(fTableX2, fTableY2, fTableF2_uint, 1, 1);
mu_2_0_dbl = centralMoment(fTableX2, fTableY2, fTableF2_uint, 2, 0);
mGamma = - mu_1_1_dbl / mu_2_0_dbl;

Ay = [1 0; mGamma 1];

fTableX3 = fTableX2;
fTableY3 = fTableY2 + mGamma * fTableX2;
fTableF3_uint = fTableF2_uint;

% fTable3 = fTable2;
% fTable3(:, 1:2) = (Ay * fTable3(:, 1:2)')';

% im3_dbl = fTable2image(fTable3);
% if showProcessFlag
% 	disp('fTable3(1:10,:)')
% 	disp(fTable3(1:10,:))
% 	figure;
% 	imshow(uint8(im3_dbl));
% 	disp('size(im3_dbl)');
% 	size(im3_dbl)
% end


% =====================
% Scaling
% =====================
disp('In normalizeImage: Scaling');
currentTime = clock;
disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);
x_min = min(fTableX3);
x_max = max(fTableX3);
y_min = min(fTableY3);
y_max = max(fTableY3);
height = x_max - x_min + 1;
width  = y_max - y_min + 1;

mAlpha = normHeight / height;
idealAlphaLB = (normHeight - 1) / height;
idealAlphaUB = (normHeight + 1) / height;
extendAlphaLB = idealAlphaLB / 2;
extendAlphaUB = idealAlphaUB * 2;

mDelta = normWidth / width;
idealDeltaLB = (normWidth - 1) / width;
idealDeltaUB = (normWidth + 1) / width;
extendDeltaLB = idealDeltaLB / 2;
extendDeltaUB = idealDeltaUB * 2;

x_min_scale = round(mAlpha * x_min);
x_max_scale = round(mAlpha * x_max);
scaleHeight = x_max_scale - x_min_scale + 1;
y_min_scale = round(mDelta * y_min);
y_max_scale = round(mDelta * y_max);
scaleWidth  = y_max_scale - y_min_scale + 1;

while (scaleHeight ~= normHeight) || (scaleWidth ~= normWidth)
	% [mAlpha scaleHeight scaleWidth]
	if scaleHeight > normHeight
		extendAlphaUB = mAlpha;
		mAlpha = (extendAlphaLB + extendAlphaUB) / 2;
		
	elseif scaleHeight < normHeight
		extendAlphaLB = mAlpha;
		mAlpha = (extendAlphaLB + extendAlphaUB) / 2;
		
	end
	if scaleWidth > normWidth
		extendDeltaUB = mDelta;
		mDelta = (extendDeltaLB + extendDeltaUB) / 2;
		
	elseif scaleWidth < normWidth
		extendDeltaLB = mDelta;
		mDelta = (extendDeltaLB + extendDeltaUB) / 2;
		
	end
	x_min_scale = round(mAlpha * x_min);
	x_max_scale = round(mAlpha * x_max);
	scaleHeight = x_max_scale - x_min_scale + 1;
	y_min_scale = round(mDelta * y_min);
	y_max_scale = round(mDelta * y_max);
	scaleWidth  = y_max_scale - y_min_scale + 1;
end

As = [mAlpha 0; 0 mDelta];

fTableX4 = fTableX3 * mAlpha;
fTableY4 = fTableY3 * mDelta;
fTableF4_uint = fTableF3_uint;

% fTable4 = fTable3;
% fTable4(:, 1:2) = (As * fTable4(:, 1:2)')';

% mu_5_0 = centralMoment(fTable4, 5, 0);
% mu_0_5 = centralMoment(fTable4, 0, 5);
% [mu_5_0, mu_0_5]

% if (mu_5_0 > 0) && (mu_0_5 > 0)
% 	isGood = true;
% else
% 	isGood = false;
% end

% im4_dbl = fTable2image(fTable4);
% if showProcessFlag
% 	disp('fTable4(1:10,:)')
% 	disp(fTable4(1:10,:))
% 	figure;
% 	imshow(im4_dbl);
% end

disp('In normalizeImage: Outputing');
currentTime = clock;
disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);

normalizedImg_uint = fTable2image( fTableX4, fTableY4, fTableF4_uint );
normFTableX = fTableX3 * mAlpha;
normFTableY = fTableY3 * mDelta;
normFTableF_uint = fTableF3_uint;
SYXMatrix = As * Ay * Ax;

end

