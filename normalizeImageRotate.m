function [ normalizedImg ] = normalizeImageRotate( inputImage, normHeight, normWidth, showProcessFlag)
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
mu_1_1 = centralMoment(fTable1, 1, 1);
mu_0_2 = centralMoment(fTable1, 0, 2);

mBeta = - mu_1_1 / mu_0_2;
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


%% Scaling
mu_0_2 = centralMoment(fTable2, 0, 2);
mu_2_0 = centralMoment(fTable2, 2, 0);
% disp(['mu_0_2=' num2str(mu_0_2) ]);
% disp(['mu_2_0=' num2str(mu_2_0) ]);

mAlpha = nthroot( mu_0_2 / mu_2_0^3 , 8 );
mDelta = nthroot( mu_2_0 / mu_0_2^3 , 8 );

mAlpha = mAlpha * 1000;
mDelta = mDelta * 1000;

disp(['mAlpha ' num2str(mAlpha) ', mDelta ' num2str(mDelta)]);

As = [mAlpha 0; 0 mDelta];

fTable3 = fTable2;
fTable3(:, 1:2) = (As * fTable3(:, 1:2)')';

im3 = fTable2image(fTable3);
size(im3)
if showProcessFlag
	disp('fTable3(1:10,:)')
	disp(fTable3(1:10,:))
	figure;
	imshow(im3);
end


%% Rotate
mu_3_0 = centralMoment(fTable3, 3, 0);
mu_0_3 = centralMoment(fTable3, 0, 3);
mu_1_2 = centralMoment(fTable3, 1, 2);
mu_2_1 = centralMoment(fTable3, 2, 1);

mPhi = atan( -(mu_3_0+mu_1_2) / (mu_0_3+mu_2_1) );

Ar = [cos(mPhi) sin(mPhi); -sin(mPhi) cos(mPhi)];

fTable4 = fTable3;
fTable4(:, 1:2) = (Ar * fTable4(:, 1:2)')';

im4 = fTable2image(fTable4);
if showProcessFlag
	disp('fTable4(1:10,:)')
	disp(fTable4(1:10,:))
	figure;
	imshow(im4);
end

normalizedImg = im4;


end

