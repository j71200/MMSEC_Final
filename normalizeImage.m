function [ normalizedImg, isGood ] = normalizeImage( inputImage, normHeight, normWidth, showProcessFlag)
%NORMALIZEIMAGE Summary of this function goes here
%   Detailed explanation goes here

[height width] = size(inputImage);


fTable = constructF( inputImage );
if showProcessFlag
	disp('fTable(1:10,:)')
	disp(fTable(1:10,:))
end

%% Centerlizing
m_1_0 = geoMoment(fTable, 1, 0);
m_0_0 = geoMoment(fTable, 0, 0);
m_0_1 = geoMoment(fTable, 0, 1);
x_mean = m_1_0 / m_0_0;
y_mean = m_0_1 / m_0_0;


fTable1 = fTable;
fTable1(:, 1) = fTable1(:, 1) - (x_mean);
fTable1(:, 2) = fTable1(:, 2) - (y_mean);

im1 = fTable2image(fTable1);
if showProcessFlag
	disp('fTable1(1:10,:)')
	disp(fTable1(1:10,:))
	figure;
	imshow(im1);
end

%% Shearing in x
mu_0_3 = centralMoment(fTable1, 0, 3);
mu_1_2 = centralMoment(fTable1, 1, 2);
mu_2_1 = centralMoment(fTable1, 2, 1);
mu_3_0 = centralMoment(fTable1, 3, 0);

syms x;
mBeta = double(solve(mu_0_3*x^3 + 3*mu_1_2*x^2 + 3*mu_2_1*x + mu_3_0, x, 'Real', true));
if length(mBeta) > 1
	mBeta = sort(mBeta);
	% disp('mBetas are ============');
	% mBeta
	mBeta = mBeta(2);
end
% disp('test mBeta START ==================');
% mBeta
% mu_0_3*mBeta^3 + 3*mu_1_2*mBeta^2 + 3*mu_2_1*mBeta + mu_3_0
% disp('test mBeta END ==================');
Ax = [1 mBeta; 0 1];
fTable2 = fTable1;
fTable2(:, 1:2) = (Ax * fTable2(:, 1:2)')';

% my_mu_3_0 = centralMoment(fTable2, 3, 0)

im2 = fTable2image(fTable2);
if showProcessFlag
	disp('fTable2(1:10,:)')
	disp(fTable2(1:10,:))
	figure;
	imshow(im2);
	disp('size(im2)');
	size(im2)
end


% TODO DELETE IT
% fTable2 = fTable1;

%% Shearing in y
mu_1_1 = centralMoment(fTable2, 1, 1);
mu_2_0 = centralMoment(fTable2, 2, 0);
mGamma = - mu_1_1 / mu_2_0;

Ay = [1 0; mGamma 1];

fTable3 = fTable2;
fTable3(:, 1:2) = (Ay * fTable3(:, 1:2)')';

% my_mu_1_1 = centralMoment(fTable3, 1, 1)

im3 = fTable2image(fTable3);
if showProcessFlag
	disp('fTable3(1:10,:)')
	disp(fTable3(1:10,:))
	figure;
	imshow(im3);
	disp('size(im3)');
	size(im3)
end


% TODO DELETE IT
% fTable3 = fTable2;

%% Scaling
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

x_min = min(fTable3(:, 1));
x_max = max(fTable3(:, 1));
y_min = min(fTable3(:, 2));
y_max = max(fTable3(:, 2));
height = x_max - x_min + 1;
width  = y_max - y_min + 1;

mAlphaCT = normHeight / height;
mAlphaLB = (normHeight - 0.5) / height;
mAlphaUB = (normHeight + 0.5) / height;

mDeltaCT = normWidth / width;
mDeltaLB = (normWidth - 0.5) / width;
mDeltaUB = (normWidth + 0.5) / width;

mAlpha = mAlphaCT;
mDelta = mDeltaCT;

x_min_scale = mAlpha * x_min;
x_max_scale = mAlpha * x_max;
scaleHeight = x_max_scale - x_min_scale + 1;
y_min_scale = mDelta * y_min;
y_max_scale = mDelta * y_max;
scaleWidth  = y_max_scale - y_min_scale + 1;

while (round(scaleHeight) ~= normHeight) || (round(scaleWidth) ~= normWidth)
	% disp(['scaleHeight = ' num2str(scaleHeight)]);
	% disp(['scaleWidth = ' num2str(scaleWidth)]);
	if scaleHeight > normHeight
		mAlpha = (mAlphaCT - mAlphaLB) * rand(1) + mAlphaLB;
	elseif scaleHeight < normHeight
		mAlpha = (mAlphaUB - mAlphaCT) * rand(1) + mAlphaCT;
	end
	if scaleWidth > normWidth
		mDelta = (mDeltaCT - mDeltaLB) * rand(1) + mDeltaLB;
	elseif scaleWidth < normWidth
		mDelta = (mDeltaUB - mDeltaCT) * rand(1) + mDeltaCT;
	end
	x_min_scale = mAlpha * x_min;
	x_max_scale = mAlpha * x_max;
	scaleHeight = x_max_scale - x_min_scale + 1;
	y_min_scale = mDelta * y_min;
	y_max_scale = mDelta * y_max;
	scaleWidth  = y_max_scale - y_min_scale + 1;
end

% exceedHeight = max(floor(fTable3(:,1)*mAlpha)) - min(floor(fTable3(:,1)*mAlpha)) + 1 - normHeight;
% exceedWidth = max(floor(fTable3(:,2)*mDelta)) - min(floor(fTable3(:,2)*mDelta)) + 1 - normWidth;

% while (exceedHeight > 0) || (exceedWidth > 0)
% 	if exceedHeight > 0
% 		temp_height = temp_height + 1;
% 		mAlpha = normHeight / temp_height;
% 		exceedHeight = max(floor(fTable3(:,1)*mAlpha)) - min(floor(fTable3(:,1)*mAlpha)) + 1 - normHeight;
% 	end
% 	if exceedWidth > 0
% 		temp_width = temp_width + 1;
% 		mDelta = normWidth / temp_width;
% 		exceedWidth = max(floor(fTable3(:,2)*mDelta)) - min(floor(fTable3(:,2)*mDelta)) + 1 - normWidth;
% 	end
% end

As = [mAlpha 0; 0 mDelta];

fTable4 = fTable3;
fTable4(:, 1:2) = (As * fTable4(:, 1:2)')';

mu_5_0 = centralMoment(fTable4, 5, 0);
mu_0_5 = centralMoment(fTable4, 0, 5);
% [mu_5_0, mu_0_5]

if (mu_5_0 > 0) && (mu_0_5 > 0)
	isGood = true;
else
	isGood = false;
end

im4 = fTable2image(fTable4);
if showProcessFlag
	disp('fTable4(1:10,:)')
	disp(fTable4(1:10,:))
	figure;
	imshow(im4);
end
normalizedImg = im4;

end

