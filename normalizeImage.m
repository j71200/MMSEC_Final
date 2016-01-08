function [ normalizedImg, normFTable, SYXMatrix, meanVector ] = normalizeImage( inputImage, normHeight, normWidth, showProcessFlag)
%NORMALIZEIMAGE Summary of this function goes here
%   Detailed explanation goes here


fTable = img2ftable( inputImage );
if showProcessFlag
	disp('fTable(1:10,:)')
	disp(fTable(1:10,:))
end

% =====================
% Centerlizing
% =====================
m_1_0 = geoMoment(fTable, 1, 0);
m_0_0 = geoMoment(fTable, 0, 0);
m_0_1 = geoMoment(fTable, 0, 1);
x_mean = m_1_0 / m_0_0;
y_mean = m_0_1 / m_0_0;
meanVector = [x_mean; y_mean];

fTable1 = fTable;
fTable1(:, 1) = fTable1(:, 1) - x_mean;
fTable1(:, 2) = fTable1(:, 2) - y_mean;

im1 = fTable2image(fTable1);
if showProcessFlag
	disp('fTable1(1:10,:)')
	disp(fTable1(1:10,:))
	figure;
	imshow(im1);
end


% =====================
% Shearing in x
% =====================
mu_0_3 = centralMoment(fTable1, 0, 3);
mu_1_2 = centralMoment(fTable1, 1, 2);
mu_2_1 = centralMoment(fTable1, 2, 1);
mu_3_0 = centralMoment(fTable1, 3, 0);

syms x;
mBeta = double(solve(mu_0_3*x^3 + 3*mu_1_2*x^2 + 3*mu_2_1*x + mu_3_0, x, 'Real', true));
if length(mBeta) > 1
	mBeta = sort(mBeta);
	mBeta = mBeta(2);
end

Ax = [1 mBeta; 0 1];
fTable2 = fTable1;
fTable2(:, 1:2) = (Ax * fTable2(:, 1:2)')';

im2 = fTable2image(fTable2);
if showProcessFlag
	disp('fTable2(1:10,:)')
	disp(fTable2(1:10,:))
	figure;
	imshow(im2);
	disp('size(im2)');
	size(im2)
end


% =====================
% Shearing in y
% =====================
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


% =====================
% Scaling
% =====================
x_min = min(fTable3(:, 1));
x_max = max(fTable3(:, 1));
y_min = min(fTable3(:, 2));
y_max = max(fTable3(:, 2));
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

% disp(['scaleHeight = ' num2str(scaleHeight)]);
% disp(['scaleWidth = ' num2str(scaleWidth)]);
% disp(['mAlpha = ' num2str(mAlpha)]);
% disp(['mDelta = ' num2str(mDelta)]);

% counter = 0;
while (scaleHeight ~= normHeight) || (scaleWidth ~= normWidth)
	% counter = counter + 1;
	% if counter > 10
	% 	break;
	% end

	% disp(['scaleHeight = ' num2str(scaleHeight)]);
	% disp(['scaleWidth = ' num2str(scaleWidth)]);
	% disp(['mAlpha = ' num2str(mAlpha)]);
	% disp(['mDelta = ' num2str(mDelta)]);
	if scaleHeight > normHeight
		extendAlphaUB = mAlpha;
		mAlpha = (extendAlphaLB + extendAlphaUB) / 2;
		% idealAlphaUB = mAlpha;
		% mAlpha = (mAlpha - idealAlphaLB) * rand(1) + idealAlphaLB;
		% mAlpha = (mAlphaCT - idealAlphaLB) * rand(1) + idealAlphaLB;
	elseif scaleHeight < normHeight
		extendAlphaLB = mAlpha;
		mAlpha = (extendAlphaLB + extendAlphaUB) / 2;
		% idealAlphaLB = mAlpha;
		% mAlpha = (idealAlphaUB - mAlpha) * rand(1) + mAlpha;
		% mAlpha = (idealAlphaUB - mAlphaCT) * rand(1) + mAlphaCT;
	end
	if scaleWidth > normWidth
		extendDeltaUB = mDelta;
		mDelta = (extendDeltaLB + extendDeltaUB) / 2;
		% idealDeltaUB = mDelta;
		% mDelta = (mDelta - idealDeltaLB) * rand(1) + idealDeltaLB;
		% mDelta = (mDeltaCT - idealDeltaLB) * rand(1) + idealDeltaLB;
	elseif scaleWidth < normWidth
		extendDeltaLB = mDelta;
		mDelta = (extendDeltaLB + extendDeltaUB) / 2;
		% idealDeltaLB = mDelta;
		% mDelta = (idealDeltaUB - mDelta) * rand(1) + mDelta;
		% mDelta = (idealDeltaUB - mDeltaCT) * rand(1) + mDeltaCT;
	end
	x_min_scale = round(mAlpha * x_min);
	x_max_scale = round(mAlpha * x_max);
	scaleHeight = x_max_scale - x_min_scale + 1;
	y_min_scale = round(mDelta * y_min);
	y_max_scale = round(mDelta * y_max);
	scaleWidth  = y_max_scale - y_min_scale + 1;
end

% disp(['scaleHeight = ' num2str(scaleHeight)]);
% disp(['scaleWidth = ' num2str(scaleWidth)]);
% disp(['mAlpha = ' num2str(mAlpha)]);
% disp(['mDelta = ' num2str(mDelta)]);

As = [mAlpha 0; 0 mDelta];

fTable4 = fTable3;
fTable4(:, 1:2) = (As * fTable4(:, 1:2)')';

mu_5_0 = centralMoment(fTable4, 5, 0);
mu_0_5 = centralMoment(fTable4, 0, 5);
% [mu_5_0, mu_0_5]

% if (mu_5_0 > 0) && (mu_0_5 > 0)
% 	isGood = true;
% else
% 	isGood = false;
% end

im4 = fTable2image(fTable4);
if showProcessFlag
	disp('fTable4(1:10,:)')
	disp(fTable4(1:10,:))
	figure;
	imshow(im4);
end

normalizedImg = im4;
normFTable = fTable4;
SYXMatrix = As * Ay * Ax;

end

