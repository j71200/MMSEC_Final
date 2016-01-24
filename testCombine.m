close all
clear
clc

originalImage = imread('./Experiment/airplane.bmp');
originalImage = rgb2gray(originalImage);
originalImage_uint = uint64(originalImage);

isShowProcess = false;
normHeight = 512;
normWidth = 512;

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
% Phase 0: Center
% ==========================





[ pNormalizedImg_uint, pNormFTableX, pNormFTableY, pNormFTableF_uint, pSYXMatrix, pMeanVector, pMuPhase0, pMuPhase1, pMuPhase2 ] = normalizeImageMoment( originalImage_uint, normHeight, normWidth, isShowProcess, 2);





[ wNormalizedImg_uint, wNormFTableX, wNormFTableY, wNormFTableF_uint, wSYXMatrix, wMeanVector, wMuPhase0, wMuPhase1, wMuPhase2 ] = normalizeImageMoment( wmSignature2_idct_trick_uint, normHeight, normWidth, isShowProcess, 2);



% ==========================
% Embedding Watermark
% ==========================
wmImage_trick_uint = (originalImage_uint + wmSignature2_idct_trick_uint);

[ wpNormalizedImg_trick_uint, wpNormFTableX, wpNormFTableY, wpNormFTableF_uint, wpSYXMatrix, wpMeanVector, wpMuPhase0, wpMuPhase1, wpMuPhase2 ] = normalizeImageMoment(wmImage_trick_uint , normHeight, normWidth, isShowProcess, 2);

% wpNormalizedImg_uint = wpNormalizedImg_trick_uint + min(min(round(wmSignature2_idct)));



% ==========================
% General Norm.
% ==========================
wmImage_uint = wmImage_trick_uint + min(min(round(wmSignature2_idct)));

[ wpNormalizedImg_uint, wpNormFTableX, wpNormFTableY, wpNormFTableF_uint, wpSYXMatrix, wpMeanVector, wpMuPhase0, wpMuPhase1, wpMuPhase2 ] = normalizeImageMoment(wmImage_uint , normHeight, normWidth, isShowProcess, 2);

figure;
imshow(uint8(wpNormalizedImg_uint));



% ==========================
% MY NORM.
% ==========================

x_mean = double(m_1_0_uint) / double(m_0_0_uint);
y_mean = double(m_0_1_uint) / double(m_0_0_uint);
meanVector = [x_mean; y_mean];









