close all
clear
clc


isShowProcess = false;
selectBeta = 2;

normHeight = 512;
normWidth = 512;

% ==========================
% Generate Image
% ==========================
originalImage = imread('./Experiment/airplane.bmp');
originalImage = rgb2gray(originalImage);
originalImage_dbl = double(originalImage);
originalImage_uint = uint64(originalImage);


% ==========================
% Generate Watermark
% ==========================
load('data_wm256_pt256x256');
wmSignature1 = patterns * (2*watermark - 1);

[zigzagColMajor ~] = genaralZigzag(normHeight, normWidth);
wmSignature2 = zeros(normHeight, normWidth);
imageArea = length(zigzagColMajor);
middle_band_idx = zigzagColMajor(1+3*imageArea/8:3*imageArea/8 + patternSize);
wmSignature2(middle_band_idx) = wmSignature1;

wmSignature2_idct = idct2(wmSignature2);

wmSignature2_idct_trick_uint = uint64(round(wmSignature2_idct) - min(min(round(wmSignature2_idct))));

% ==========================
% Phase 1: Centroid
% ==========================
% Image
[fTableX, fTableY, pfTableF_dbl] = image2ftableFree(originalImage_dbl);
p_m_0_0 = geoMomentDbl(fTableX, fTableY, pfTableF_dbl, 0, 0);
p_m_1_0 = geoMomentDbl(fTableX, fTableY, pfTableF_dbl, 1, 0);
p_m_0_1 = geoMomentDbl(fTableX, fTableY, pfTableF_dbl, 0, 1);

% Watermark
[fTableX, fTableY, wfTableF_dbl] = image2ftableFree(double(wmSignature2_idct_trick_uint));
w_m_0_0 = geoMomentDbl(fTableX, fTableY, wfTableF_dbl, 0, 0);
w_m_1_0 = geoMomentDbl(fTableX, fTableY, wfTableF_dbl, 1, 0);
w_m_0_1 = geoMomentDbl(fTableX, fTableY, wfTableF_dbl, 0, 1);

% Compose
m_1_0 = p_m_1_0 + w_m_1_0;
m_0_1 = p_m_0_1 + w_m_0_1;
m_0_0 = p_m_0_0 + w_m_0_0;

% Centroid Shift
x_mean = m_1_0 / m_0_0;
y_mean = m_0_1 / m_0_0;

fTableX1 = fTableX - x_mean;
fTableY1 = fTableY - y_mean;

meanVector = [x_mean y_mean]';

% ==========================
% Phase 2: Shearing in x
% ==========================
% Image
p_mu_3_0 = centralMomentDbl(fTableX1, fTableY1, pfTableF_dbl, 3, 0);
p_mu_2_1 = centralMomentDbl(fTableX1, fTableY1, pfTableF_dbl, 2, 1);
p_mu_1_2 = centralMomentDbl(fTableX1, fTableY1, pfTableF_dbl, 1, 2);
p_mu_0_3 = centralMomentDbl(fTableX1, fTableY1, pfTableF_dbl, 0, 3);

% Watermark
w_mu_3_0 = centralMomentDbl(fTableX1, fTableY1, wfTableF_dbl, 3, 0);
w_mu_2_1 = centralMomentDbl(fTableX1, fTableY1, wfTableF_dbl, 2, 1);
w_mu_1_2 = centralMomentDbl(fTableX1, fTableY1, wfTableF_dbl, 1, 2);
w_mu_0_3 = centralMomentDbl(fTableX1, fTableY1, wfTableF_dbl, 0, 3);

% Compose
mu_3_0 = p_mu_3_0 + w_mu_3_0
mu_2_1 = p_mu_2_1 + w_mu_2_1
mu_1_2 = p_mu_1_2 + w_mu_1_2
mu_0_3 = p_mu_0_3 + w_mu_0_3

% Shearing
syms x;
mBeta = double(solve(mu_0_3*x^3 + 3*mu_1_2*x^2 + 3*mu_2_1*x + mu_3_0, x, 'Real', true));

% disp('mBeta!!!');
% sort(mBeta)

if length(mBeta) > 1
	mBeta = sort(mBeta);
	mBeta = mBeta(selectBeta);
end

fTableX2 = fTableX1 + mBeta * fTableY1;
fTableY2 = fTableY1;

Ax = [1 mBeta; 0 1];

% ==========================
% Phase 3: Shearing in y
% ==========================
% Image
p_mu_1_1 = centralMomentDbl(fTableX2, fTableY2, pfTableF_dbl, 1, 1);
p_mu_2_0 = centralMomentDbl(fTableX2, fTableY2, pfTableF_dbl, 2, 0);

% Watermark
w_mu_1_1 = centralMomentDbl(fTableX2, fTableY2, wfTableF_dbl, 1, 1);
w_mu_2_0 = centralMomentDbl(fTableX2, fTableY2, wfTableF_dbl, 2, 0);

% Compose
mu_1_1 = p_mu_1_1 + w_mu_1_1;
mu_2_0 = p_mu_2_0 + w_mu_2_0;

% Shearing
mGamma = - mu_1_1 / mu_2_0;

fTableX3 = fTableX2;
fTableY3 = fTableY2 + mGamma * fTableX2;

Ay = [1 0; 0 mGamma];

% ==========================
% Phase 4: Scaling
% ==========================

% ==========================
% Result
% ==========================
AA = Ay * Ax


[ normalizedImg_uint, normFTableX, normFTableY, normFTableF_uint, SYXMatrix, meanVector2 ] = normalizeImage( originalImage_uint + wmSignature2_idct_trick_uint, normHeight, normWidth, isShowProcess, selectBeta);

SYXMatrix







% [ pNormalizedImg_uint, pNormFTableX, pNormFTableY, pNormFTableF_uint, pSYXMatrix, pMeanVector, pMuPhase0, pMuPhase1, pMuPhase2 ] = normalizeImageMoment( originalImage_uint, normHeight, normWidth, isShowProcess, 2);





% [ wNormalizedImg_uint, wNormFTableX, wNormFTableY, wNormFTableF_uint, wSYXMatrix, wMeanVector, wMuPhase0, wMuPhase1, wMuPhase2 ] = normalizeImageMoment( wmSignature2_idct_trick_uint, normHeight, normWidth, isShowProcess, 2);



% % ==========================
% % Embedding Watermark
% % ==========================
% wmImage_trick_uint = (originalImage_uint + wmSignature2_idct_trick_uint);

% [ wpNormalizedImg_trick_uint, wpNormFTableX, wpNormFTableY, wpNormFTableF_uint, wpSYXMatrix, wpMeanVector, wpMuPhase0, wpMuPhase1, wpMuPhase2 ] = normalizeImageMoment(wmImage_trick_uint , normHeight, normWidth, isShowProcess, 2);

% % wpNormalizedImg_uint = wpNormalizedImg_trick_uint + min(min(round(wmSignature2_idct)));



% % ==========================
% % General Norm.
% % ==========================
% wmImage_uint = wmImage_trick_uint + min(min(round(wmSignature2_idct)));

% [ wpNormalizedImg_uint, wpNormFTableX, wpNormFTableY, wpNormFTableF_uint, wpSYXMatrix, wpMeanVector, wpMuPhase0, wpMuPhase1, wpMuPhase2 ] = normalizeImageMoment(wmImage_uint , normHeight, normWidth, isShowProcess, 2);

% figure;
% imshow(uint8(wpNormalizedImg_uint));



% % ==========================
% % MY NORM.
% % ==========================

% x_mean = double(m_1_0_uint) / double(m_0_0_uint);
% y_mean = double(m_0_1_uint) / double(m_0_0_uint);
% meanVector = [x_mean; y_mean];









