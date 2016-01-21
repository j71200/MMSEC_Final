function [wmSignature, wmSignature_reg] = newAllInOne(originalImage_uint, attackType, isShowProcess)

% With JPEG Compression attack


% close all
% clear('all');
% clc

if isShowProcess
	tic
	disp('Start execuse');
	currentTime = clock;
	disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);
end

% originalImage = imread('./Experiment/airplane.bmp');
% originalImage = rgb2gray(originalImage);
% originalImage_uint = uint64(originalImage);
% attackType = 6;
% isShowProcess = true;


% =================
% Initialization
% =================
normHeight = 512;
normWidth  = 512;

% =================
% KeyGen
% =================
p_uint = uint64(251);
q_uint = uint64(257);
r_uint = 3;

if isShowProcess
	disp('Encrypting Original Image!!!');
	currentTime = clock;
	disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);
end
[n_uint, g_uint, lambda_uint, mu_uint] = paillierKeygen(p_uint, q_uint);
nSquare_uint = n_uint^2;

% ==========================
% Encrypt Image
% ==========================
if isShowProcess
	disp('Embedding watermark!!!');
	currentTime = clock;
	disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);
end

trickFactor_uint = uint64(10^0);
encryptedImg_uint = paillierEncrypt(originalImage_uint * trickFactor_uint + 1, n_uint, g_uint, r_uint);

% if isShowProcess
% 	encryptedImg = uint8(encryptedImg_uint);
% 	figure('name', 'encryptedImg');
% 	imshow(encryptedImg);
% end

% ==========================
% Generate Watermark
% ==========================
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


% ==========================
% Embedding Watermark
% ==========================
% Step 3
wmSignature2_idct_trick_uint = uint64(round(wmSignature2_idct * double(trickFactor_uint)));
trickShift_uint = min(min(wmSignature2_idct_trick_uint));
wmSignature2_idct_trick_uint = wmSignature2_idct_trick_uint - trickShift_uint + 1;

encryptedWmSignature2_idct_uint = paillierEncrypt(wmSignature2_idct_trick_uint, n_uint, g_uint, r_uint);

encryptedWmImage_uint = mod(encryptedImg_uint .* encryptedWmSignature2_idct_uint, nSquare_uint);

% if isShowProcess
% 	encryptedWmImage = uint8(encryptedWmImage_uint);
% 	figure('name','encryptedWmImage');
% 	imshow(encryptedWmImage)
% end


% ==========================
% Test decrypt
% ==========================
if isShowProcess
	trickedWmImage_uint = paillierDecrypt(encryptedWmImage_uint, n_uint, lambda_uint, mu_uint);
	trickedWmImage = uint8(trickedWmImage_uint);

	figure('name', 'trickedWmImage');
	imshow(trickedWmImage);
	disp('nnz(trickedWmImage): ');
	nnz(trickedWmImage)
end

% ==========================
% Pre-normalization
% ==========================
if isShowProcess
	disp('Pre-normalization!!!');
	currentTime = clock;
	disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);
end

[encryptedNormalWmImage_uint, normEncryptedWmFTableX, normEncryptedWmFTableY, normEncryptedWmFTableF_uint, SYXMatrix, meanVector] = normalizeImage(encryptedWmImage_uint, normHeight, normWidth, false);

if isShowProcess
	encryptedNormalWmImage = uint8(encryptedNormalWmImage_uint);
	figure('name', 'encryptedNormalWmImage');
	imshow(encryptedNormalWmImage)
end

if isShowProcess
	prenormalWmImage_uint = paillierDecrypt(encryptedNormalWmImage_uint, n_uint, lambda_uint, mu_uint);
	prenormalWmImage = uint8(prenormalWmImage_uint);

	figure('name', 'prenormalWmImage');
	imshow(prenormalWmImage);
end


% ==========================
% Attack
% ==========================
% disp('Attacking!!!');
%1 - Shift down without Crop
%2 - Shift right without Crop
%3 - Rotate without Crop
%4 - Scale without Crop
%5 - Shearing in x without Crop
%6 - Shearing in y without Crop
%7 - Shearing in x&y without Crop
%8 - JPEG Compression
paraList = zeros(8, 1);
paraList(1) = 200;
paraList(2) = 200;
paraList(3) = 30;
paraList(4) = 1.5;
paraList(5) = 1;
paraList(6) = 1;
paraList(7) = 1;
paraList(8) = 100;

% paraList(1) = 10;
% paraList(2) = 10;
% paraList(3) = 1;
% paraList(4) = 1.1;
% paraList(5) = 0.5;
% paraList(6) = 0.5;
% paraList(7) = 0.5;

% 恐怕不能attack在encrypted上，因為imrotate和imresize都只能用在uint8上面

if isShowProcess
	disp('In Attacking: decrypting!!!');
	currentTime = clock;
	disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);
end
wmImage_uint = paillierDecrypt(encryptedWmImage_uint, n_uint, lambda_uint, mu_uint);
wmImage_uint = (wmImage_uint - 2 + trickShift_uint) / trickFactor_uint;

wmImage = uint8(wmImage_uint);
if isShowProcess
	figure('name','wmImage');
	imshow(wmImage);
end

% if isShowProcess
% 	trickedWmImage_uint = paillierDecrypt(encryptedWmImage_uint, n_uint, lambda_uint, mu_uint);
% 	trickedWmImage = uint8(trickedWmImage_uint);

% 	figure('name', 'trickedWmImage');
% 	imshow(trickedWmImage);
% end

if isShowProcess
	disp('In Attacking: attacking!!!');
	currentTime = clock;
	disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);
end

[attackedWmImageFTableX, attackedWmImageFTableY, attackedWmImageFTableF_uint, attackedWmImage_uint] = attackGrayUintLossyless(wmImage_uint, attackType, paraList(attackType));

if isShowProcess
	attackedWmImage = uint8(attackedWmImage_uint);
	figure('name','attackedWmImage');
	imshow(attackedWmImage);
	disp('nnz(attackedWmImage): ');
	nnz(attackedWmImage)
end


% ==========================
% Normalization
% ==========================
if isShowProcess
	disp('In Extracting - Encrypting!!!');
	currentTime = clock;
	disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);
end

occupiedIndex = find(attackedWmImageFTableF_uint);
attackedWmImageFTableF_uint(occupiedIndex) = attackedWmImageFTableF_uint(occupiedIndex) * trickFactor_uint - trickShift_uint + 2;

encryptedAttWmImageFTableF_uint = paillierEncrypt(attackedWmImageFTableF_uint, n_uint, g_uint, r_uint^2);

if isShowProcess
	disp('In Extracting - Normalization!!!');
	currentTime = clock;
	disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);
end

[normEncryptedAttWmImage_uint, normEncryptedAttFTableX, normEncryptedAttFTableY, normEncryptedAttFTableF_uint, attSYXMatrix, attMeanVector] = normalizeImageLossyless(attackedWmImageFTableX, attackedWmImageFTableY, encryptedAttWmImageFTableF_uint, normHeight, normWidth, false);

if isShowProcess
	normEncryptedAttWmImage = uint8(normEncryptedAttWmImage_uint);
	figure('name','normEncryptedAttWmImage');
	imshow(normEncryptedAttWmImage)
end

% ==========================
% De-normalization
% ==========================
if isShowProcess
	disp('In Extracting - De-normalization!!!');
	currentTime = clock;
	disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);
end

regEncryptedFTableXY = [normEncryptedAttFTableX normEncryptedAttFTableY];
regEncryptedFTableXY = (SYXMatrix^(-1) * regEncryptedFTableXY')';
regEncryptedFTableX = regEncryptedFTableXY(:, 1);
regEncryptedFTableY = regEncryptedFTableXY(:, 2);
regEncryptedFTableX = regEncryptedFTableX + meanVector(1);
regEncryptedFTableY = regEncryptedFTableY + meanVector(2);
regEncryptedFTableF_uint = normEncryptedAttFTableF_uint;

regEncryptedImage_uint = fTable2image(regEncryptedFTableX, regEncryptedFTableY, regEncryptedFTableF_uint);

if isShowProcess
	regEncryptedImage = uint8(regEncryptedImage_uint);
	figure('name','regEncryptedImage');
	imshow(regEncryptedImage)
end


% ==========================
% Decryption
% ==========================
if isShowProcess
	disp('In Extracting - Decrypting!!!');
	currentTime = clock;
	disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);
end

decTrickImage_uint = paillierDecrypt(regEncryptedImage_uint, n_uint, lambda_uint, mu_uint);

decImage_uint = (decTrickImage_uint + trickShift_uint - 2) / trickFactor_uint;

recImage = uint8(decImage_uint);
if isShowProcess
	figure('name', 'recImage');
	imshow(recImage);
end

% ==========================
% Extraction
% ==========================
if isShowProcess
	disp('Extracting!!!');
	currentTime = clock;
	disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);
end
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

disp(['psnr = ' num2str(psnr(wmImage, recImage))]);




% SOME TEST
% someDiff = double(normEncryptedAttWmImage_uint) - double(encryptedNormalWmImage_uint);
% someDiff = abs(someDiff);
% max(max(someDiff))
% figure('name', 'someDiff');
% image(someDiff);


if isShowProcess
	toc
	disp('Finished!!!');
	currentTime = clock;
	disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);
end



end
