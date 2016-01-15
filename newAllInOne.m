function [wmSignature, wmSignature_reg] = newAllInOne(originalImage_dbl, attackType, isShowFig)

% close all
% clear('all');
% clc


% originalImage = imread('./Experiment/airplane.bmp');
% originalImage = rgb2gray(originalImage);
% originalImage_dbl = double(originalImage);
% attackType = 3;
% % isShowFig = true;
% isShowFig = false;



% =================
% Initialization
% =================
normHeight = 512;
normWidth  = 512;

% =================
% KeyGen
% =================
primeP = 251;
primeQ = 257;

% primeP = 17;
% primeQ = 19;

[n_pk, g_pk, lambda_sk, mu_sk] = paillierKeygen(primeP, primeQ);
nSquare = n_pk^2;

% ==========================
% Encrypt Image
% ==========================
% disp('Embedding watermark!!!');

trickFactor = 10^0;
a = originalImage_dbl * trickFactor + 1;
max(max(a))
min(min(a))
encryptedImg_dbl = paillierEncrypt(originalImage_dbl * trickFactor + 1, n_pk, g_pk);

if isShowFig
	encryptedImg = uint8(encryptedImg_dbl);
	figure('name', 'encryptedImg');
	imshow(encryptedImg);
end


% Step 2-(a)
load('data_wm256_pt256x256');
% Step 2-(b)
% s = x + (alpha*b - lambda*(x'*pattern)/(pattern'*pattern))*pattern;
wmSignature1 = patterns * (2*watermark - 1);

% Step 2-(c)
[zigzagColMajor ~] = genaralZigzag(normHeight, normWidth);
wmSignature2 = zeros(normHeight, normWidth);
imageArea = length(zigzagColMajor);
middle_band_idx = zigzagColMajor(1+3*imageArea/8:3*imageArea/8 + patternSize);
wmSignature2(middle_band_idx) = wmSignature1;

% Step 2-(d)
wmSignature2_idct = idct2(wmSignature2);

% Step 3
wmSignature2_idct_trick = round(wmSignature2_idct * trickFactor);
trickShift = min(min(wmSignature2_idct_trick));
wmSignature2_idct_trick = wmSignature2_idct_trick - trickShift + 1;

encryptedWmSignature2_idct = paillierEncrypt(wmSignature2_idct_trick, n_pk, g_pk);


encryptedWmImage_dbl = mod(encryptedImg_dbl .* encryptedWmSignature2_idct, nSquare);


if isShowFig
	encryptedWmImage = uint8(encryptedWmImage_dbl);
	figure('name','encryptedWmImage');
	imshow(encryptedWmImage)
end


[encryptedNormalWmImage_dbl, normFTable, SYXMatrix, meanVector] = normalizeImage(encryptedWmImage_dbl, normHeight, normWidth, false);

if isShowFig
	encryptedNormalWmImage = uint8(encryptedNormalWmImage_dbl);
	figure('name', 'encryptedNormalWmImage');
	imshow(encryptedNormalWmImage)
end



if isShowFig
	NormalWmImage_dbl = paillierDecrypt(encryptedNormalWmImage_dbl, n_pk, lambda_sk, mu_sk);
	NormalWmImage = uint8(NormalWmImage_dbl);

	figure('name', 'NormalWmImage');
	imshow(NormalWmImage);
end


% ==========================
% Attack
% ==========================
% disp('Attacking!!!');
% attackType = 9;
%1 - Shift down without Crop
%2 - Shift right without Crop
%3 - Rotate without Crop
%4 - Scale without Crop
%5 - Shearing in x without Crop
%6 - Shearing in y without Crop
%7 - Shearing in x&y without Crop
paraList = zeros(8, 1);
paraList(1) = 200;
paraList(2) = 200;
paraList(3) = 30;
paraList(4) = 1.5;
paraList(5) = 1;
paraList(6) = 1;
paraList(7) = 1;

% paraList(1) = 10;
% paraList(2) = 10;
% paraList(3) = 1;
% paraList(4) = 1.1;
% paraList(5) = 0.5;
% paraList(6) = 0.5;
% paraList(7) = 0.5;


encryptedAttWmImage_dbl = attackGrayDbl(encryptedWmImage_dbl, attackType, paraList(attackType));


% ==========================
% Normalization II - Attack
% ==========================
% disp('Decrypt!!!');
[normEncryptedAttWmImage_dbl, normEncryptedAttFTable, attSYXMatrix, attMeanVector] = normalizeImage(encryptedAttWmImage_dbl, normHeight, normWidth, false);


if isShowFig
	normEncryptedAttWmImage = uint8(normEncryptedAttWmImage_dbl);
	figure('name','normEncryptedAttWmImage');
	imshow(normEncryptedAttWmImage)
end

regEncryptedFTable = normEncryptedAttFTable;
regEncryptedFTable(:, 1:2) = (SYXMatrix^(-1) * regEncryptedFTable(:, 1:2)')';
regEncryptedFTable(:, 1) = regEncryptedFTable(:, 1) + meanVector(1);
regEncryptedFTable(:, 2) = regEncryptedFTable(:, 2) + meanVector(2);

regEncryptedImage_dbl = fTable2image(regEncryptedFTable);

if isShowFig
	regEncryptedImage = uint8(regEncryptedImage_dbl);
	figure('name','regEncryptedImage');
	imshow(regEncryptedImage)
end


% ==========================
% Decryption
% ==========================

decTrickImage_dbl = paillierDecrypt(regEncryptedImage_dbl, n_pk, lambda_sk, mu_sk);


decImage_dbl = (decTrickImage_dbl + trickShift - 2) / trickFactor;


recImage = uint8(decImage_dbl);
if isShowFig
	figure('name', 'recImage');
	imshow(recImage);
end

% ==========================
% Extraction
% ==========================
% disp('Extracting!!!');
% Step 2-(a)
% Regenerate the watermark patterns - DONE

% Step 2-(b)
recImage_dct = dct2(recImage);
cw = recImage_dct(middle_band_idx);

% Step 2-(d)
extractedWM = patterns' * cw;
extractedWM = extractedWM > 0;

wmDiff = extractedWM - watermark;
bitErrorRate = 100 * nnz(wmDiff) / length(watermark)


% psnr(recImage, wmImage)


end
