function [wmSignature, wmSignature_reg] = newAllInOne(originalImage_uint, attackType, isShowFig)

% close all
% clear('all');
% clc

tic
disp('Start execuse');
currentTime = clock;
disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);

% originalImage = imread('./Experiment/airplane.bmp');
% originalImage = rgb2gray(originalImage);
% originalImage_uint = uint64(originalImage);
% attackType = 6;
% isShowFig = true;


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

% p_uint = 151;
% q_uint = 157;

% p_uint = uint64(17);
% q_uint = uint64(19);

disp('Encrypting Original Image!!!');
currentTime = clock;
disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);
[n_uint, g_uint, lambda_uint, mu_uint] = paillierKeygen(p_uint, q_uint);
nSquare_uint = n_uint^2;

% ==========================
% Encrypt Image
% ==========================
disp('Embedding watermark!!!');
currentTime = clock;
disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);

trickFactor_uint = uint64(10^0);
encryptedImg_uint = paillierEncrypt(originalImage_uint * trickFactor_uint + 1, n_uint, g_uint, r_uint);

% if isShowFig
% 	encryptedImg = uint8(encryptedImg_uint);
% 	figure('name', 'encryptedImg');
% 	imshow(encryptedImg);
% end

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
wmSignature2_idct_trick_uint = uint64(round(wmSignature2_idct * double(trickFactor_uint)));
trickShift_uint = min(min(wmSignature2_idct_trick_uint));
wmSignature2_idct_trick_uint = wmSignature2_idct_trick_uint - trickShift_uint + 1;

encryptedWmSignature2_idct_uint = paillierEncrypt(wmSignature2_idct_trick_uint, n_uint, g_uint, r_uint);


encryptedWmImage_uint = mod(encryptedImg_uint .* encryptedWmSignature2_idct_uint, nSquare_uint);

% if isShowFig
% 	encryptedWmImage = uint8(encryptedWmImage_uint);
% 	figure('name','encryptedWmImage');
% 	imshow(encryptedWmImage)
% end


% ==========================
% Test decrypt
% ==========================
% if isShowFig
% 	trickedWmImage_uint = paillierDecrypt(encryptedWmImage_uint, n_uint, lambda_uint, mu_uint);
% 	trickedWmImage = uint8(trickedWmImage_uint);

% 	figure('name', 'trickedWmImage');
% 	imshow(trickedWmImage);
% end




disp('Pre-normalization!!!');
currentTime = clock;
disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);

[encryptedNormalWmImage_uint, normEncryptedWmFTableX, normEncryptedWmFTableY, normEncryptedWmFTableF_uint, SYXMatrix, meanVector] = normalizeImage(encryptedWmImage_uint, normHeight, normWidth, false);

if isShowFig
	encryptedNormalWmImage = uint8(encryptedNormalWmImage_uint);
	figure('name', 'encryptedNormalWmImage');
	imshow(encryptedNormalWmImage)
end

if isShowFig
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


% 恐怕不能attack在encrypted上，因為imrotate和imresize都只能用在uint8上面

disp('In Attacking: decrypting!!!');
currentTime = clock;
disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);
wmImage_uint = paillierDecrypt(encryptedWmImage_uint, n_uint, lambda_uint, mu_uint);
wmImage_uint = (wmImage_uint - 2 + trickShift_uint) / trickFactor_uint;

% disp('###################');
% aaa_uint = originalImage_uint + wmSignature2_idct_trick_uint + trickShift_uint - 1;
% aaa = uint8(aaa_uint);
% psnr(uint8(wmImage_uint), aaa)
% disp('###################');

% if isShowFig
% 	trickedWmImage_uint = paillierDecrypt(encryptedWmImage_uint, n_uint, lambda_uint, mu_uint);
% 	trickedWmImage = uint8(trickedWmImage_uint);

% 	figure('name', 'trickedWmImage');
% 	imshow(trickedWmImage);
% end

disp('In Attacking: attacking!!!');
currentTime = clock;
disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);
attackedWmImage_uint = attackGrayUint(wmImage_uint, attackType, paraList(attackType));

% nnz(attackedWmImage_uint == 0)
% fsdjio = sfiej;

disp('In Attacking: encrypting!!!');
currentTime = clock;
disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);
% MODIFY here
% attackedWmImage_uint = attackedWmImage_uint*trickFactor_uint - trickShift_uint + 2;
occupiedIndex = find(attackedWmImage_uint);
attackedWmImage_uint(occupiedIndex) = attackedWmImage_uint(occupiedIndex) * trickFactor_uint - trickShift_uint + 2;

encryptedAttWmImage_uint = paillierEncrypt(attackedWmImage_uint, n_uint, g_uint, r_uint^2);


% encryptedAttWmImage_uint = attackGrayUint(encryptedWmImage_uint, attackType, paraList(attackType));


% ==========================
% Normalization II - Attack
% ==========================
disp('Normalization!!!');
currentTime = clock;
disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);

[normEncryptedAttWmImage_uint, normEncryptedAttFTableX, normEncryptedAttFTableY, normEncryptedAttFTableF_uint, attSYXMatrix, attMeanVector] = normalizeImage(encryptedAttWmImage_uint, normHeight, normWidth, false);

if isShowFig
	normEncryptedAttWmImage = uint8(normEncryptedAttWmImage_uint);
	figure('name','normEncryptedAttWmImage');
	imshow(normEncryptedAttWmImage)
end

disp('Denormalization!!!');
currentTime = clock;
disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);

regEncryptedFTableXY = [normEncryptedAttFTableX normEncryptedAttFTableY];
regEncryptedFTableXY = (SYXMatrix^(-1) * regEncryptedFTableXY')';
regEncryptedFTableX = regEncryptedFTableXY(:, 1);
regEncryptedFTableY = regEncryptedFTableXY(:, 2);
regEncryptedFTableX = regEncryptedFTableX + meanVector(1);
regEncryptedFTableY = regEncryptedFTableY + meanVector(2);
regEncryptedFTableF_uint = normEncryptedAttFTableF_uint;

regEncryptedImage_uint = fTable2image(regEncryptedFTableX, regEncryptedFTableY, regEncryptedFTableF_uint);

if isShowFig
	regEncryptedImage = uint8(regEncryptedImage_uint);
	figure('name','regEncryptedImage');
	imshow(regEncryptedImage)
end


% ==========================
% Decryption
% ==========================
disp('Decrypting!!!');
currentTime = clock;
disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);

decTrickImage_uint = paillierDecrypt(regEncryptedImage_uint, n_uint, lambda_uint, mu_uint);


decImage_uint = (decTrickImage_uint + trickShift_uint - 2) / trickFactor_uint;


recImage = uint8(decImage_uint);
if isShowFig
	figure('name', 'recImage');
	imshow(recImage);
end

% ==========================
% Extraction
% ==========================
disp('Extracting!!!');
currentTime = clock;
disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);
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


toc
disp('Finished!!!');
currentTime = clock;
disp([num2str(currentTime(4)) ':' num2str(currentTime(5))]);


end
