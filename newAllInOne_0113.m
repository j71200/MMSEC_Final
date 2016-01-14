function [wmSignature, wmSignature_reg] = newAllInOne(originalImage_dbl, attackType, isShowFig)

% =================
% Initialization
% =================
normHeight = 512;
normWidth  = 512;

% =================
% KeyGen
% =================
primeP = 17;
primeQ = 19;

[n_pk, g_pk, lambda_sk, mu_sk] = paillierKeygen(primeP, primeQ);
nSquare = n_pk^2;

% ==========================
% Encrypt Image
% ==========================

encryptedImg_dbl = paillierEncrypt(originalImage_dbl + 1, n_pk, g_pk);

encryptedImg = uint8(encryptedImg_dbl);
if isShowFig
	figure('name', 'encryptedImg');
	imshow(encryptedImg);
end

% originalImage = imresize(uint8(originalImage_dbl), [normHeight, normWidth]);
% originalImage_dbl = double(originalImage);

% if isShowFig
% 	figure('name', 'originalImage');
% 	imshow(originalImage);
% end

% encryptedImg_dbl = cryptImage(originalImage_dbl, N_pk, e_pk);


% originalImage = imread('./Experiment/airplane.bmp');
% originalImage = imread('./Experiment/baboon.bmp');
% originalImage = imread('./Experiment/fruits.bmp');
% originalImage = imread('./Experiment/airplane.bmp');


% originalImage = imread('./Experiment/peppers_gray.bmp');
% figure
% imshow(originalImage)
% title('originalImage')


% ==========================
% Normalization I - Original
% ==========================
% normHeight = 128;
% normWidth  = 128;
% [normalOriginImage_dbl, normFTable, SYXMatrix, meanVector] = normalizeImage(originalImage_dbl, normHeight, normWidth, false);
% normalOriginImage = uint8(normalOriginImage_dbl);
% if isShowFig
% 	figure
% 	imshow(normalOriginImage)
% 	title('normalOriginImage')
% end

% ==========================
% Embedding Watermark
% ==========================
% [normalHeight normalWidth] = size(normalOriginImage);

% Step 2-(a)
load('data_wm256_pt256x256');
% wmSize = 256; % 8KB
% watermark = randi([0, 1], wmSize, 1);
% patternSize = normHeight * normWidth;
% patterns = sign(randn(patternSize, wmSize));

% Step 2-(b)
% s = x + (alpha*b - lambda*(x'*pattern)/(pattern'*pattern))*pattern;
wmSignature1 = patterns * (2*watermark - 1);
% s = x + (alpha*b - lambda*(x'*pattern)/(pattern'*pattern))*pattern;

% Step 2-(c)
[zigzagColMajor ~] = genaralZigzag(normHeight, normWidth);
wmSignature2 = zeros(normHeight, normWidth);
imageArea = length(zigzagColMajor);
middle_band_idx = zigzagColMajor(1+3*imageArea/8:3*imageArea/8 + patternSize);
wmSignature2(middle_band_idx) = wmSignature1;

% Step 2-(d)
wmSignature2_idct = idct2(wmSignature2);

% Step 3
% maskImage = normalOriginImage > 0;

% nnz(normalOriginImage)

% nnzOForiginalImage_dbl =  nnz(originalImage_dbl);
% nnzOForiginalImage_dbl

% nnz_normFTable = nnz(normFTable(:, 3));
% nnz_normFTable

% Step 4
% wmSignature = maskImage .* wmSignature2_idct;

% Step 5
% wmSignFTable = img2ftable(wmSignature);
% wmSignFTable(:, 1:2) = (SYXMatrix^(-1) * wmSignFTable(:, 1:2)')';
% wmSignFTable(:, 1) = wmSignFTable(:, 1) + meanVector(1);
% wmSignFTable(:, 2) = wmSignFTable(:, 2) + meanVector(2);

% wmSignature_reg = fTable2image(wmSignFTable);
% size(wmSignature_reg)
% nnz(wmSignature_reg(1,:))
% nnz(wmSignature_reg(end,:))
% nnz(wmSignature_reg(:,1))
% nnz(wmSignature_reg(:,end))

% Step 6
% wmSignature_reg = double(wmSignature_reg); %wmSignature_reg means regular wmSignature

% wmImage = originalImage_dbl + wmSignature_reg(2:end-1, 2:end-1);

% roundCauseHeight = size(wmSignature_reg, 1) - normHeight;
% roundCauseWidth = size(wmSignature_reg, 2) - normWidth;
% if roundCauseHeight == 1
% 	firstRowNNZ = nnz(wmSignature_reg(1, :));
% 	LastRowNNZ = nnz(wmSignature_reg(end, :));
% 	if firstRowNNZ <= LastRowNNZ
% 		startRow = 2;
% 	else
% 		startRow = 1;
% 	end
% elseif roundCauseHeight == 2
% 	startRow = 2;
% elseif roundCauseHeight == 0
% 	% Do nothing
% else
% 	disp('roundCauseHeight exception!');
% end

% if roundCauseWidth == 1
% 	firstColNNZ = nnz(wmSignature_reg(:, 1));
% 	LastColNNZ = nnz(wmSignature_reg(:, end));
% 	if firstColNNZ <= LastColNNZ
% 		startCol = 2;
% 	else
% 		startCol = 1;
% 	end
% elseif roundCauseWidth == 2
% 	startCol = 2;
% elseif roundCauseWidth == 0
% 	% Do nothing
% else
% 	disp('roundCauseWidth exception!');
% end

% endRow = startRow + normHeight - 1;
% endCol = startCol + normWidth - 1;

% wmImage = originalImage_dbl + wmSignature_reg(startRow:endRow, startCol:endCol);
% wmImage = originalImage_dbl + wmSignature_reg(1:512, 2:513);

% whos wmSignature2_idct
% min(min(wmSignature2_idct))
% max(max(wmSignature2_idct))
% nnz(wmSignature2_idct)




trickFactor = 1;
wmSignature2_idct_trick = round(wmSignature2_idct * trickFactor);
trickShift = min(min(wmSignature2_idct_trick));
wmSignature2_idct_trick = wmSignature2_idct_trick - trickShift + 1;
% trickShift
% min(min(wmSignature2_idct_trick))
% max(max(wmSignature2_idct_trick))

encryptedWmSignature2_idct = paillierEncrypt(wmSignature2_idct_trick, n_pk, g_pk);
% encryptedWmSignature2_idct = paillierEncrypt(wmSignature2_idct, n_pk, g_pk);


% encryptedWmSignature2_idct = cryptImage(wmSignature2_idct, N_pk, e_pk);

encryptedWmImage_dbl = mod(encryptedImg_dbl .* encryptedWmSignature2_idct, nSquare);
% encryptedWmImage_dbl = encryptedImg_dbl;

encryptedWmImage = uint8(encryptedWmImage_dbl);

if isShowFig
	figure('name','encryptedWmImage');
	imshow(encryptedWmImage)
end

% imwrite(uint8(originalImage_dbl), './Experiment/wm/XXXX_gray.png');
% mPSNR = round(psnr(wmImage, uint8(originalImage_dbl)) * 10) / 10;
% imwrite(wmImage, ['./Experiment/wm/XXXX_wm_' num2str(mPSNR) '.png']);



[encryptedNormalWmImage_dbl, normFTable, SYXMatrix, meanVector] = normalizeImage(encryptedWmImage_dbl, normHeight, normWidth, false);

encryptedNormalWmImage = uint8(encryptedNormalWmImage_dbl);
if isShowFig
	figure('name','encryptedNormalWmImage');
	imshow(encryptedNormalWmImage)
end








% wmImage_dct = dct2(wmImage_dbl);
% cw = wmImage_dct(middle_band_idx);

% extractedWM = patterns' * cw;
% extractedWM = extractedWM > 0;

% wmDiff = extractedWM - watermark;
% % [watermark extractedWM]
% bitErrorRate = 100 * nnz(wmDiff) / length(watermark)



% sfdji = sfjoiaf;



% ==========================
% Attack
% ==========================
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

encryptedAttWMImage = attackGray(encryptedWmImage, attackType, paraList(attackType));

if isShowFig
	figure('name','encryptedAttWMImage');
	imshow(encryptedAttWMImage)
end



encryptedAttWMImage_dbl = double(encryptedAttWMImage);
recImage_dbl = paillierDecrypt(encryptedAttWMImage_dbl, n_pk, lambda_sk, mu_sk);

% recImage_dbl = recImage_dbl - 1 - trickShift;
recImage_dbl = recImage_dbl - 1;

recImage = uint8(recImage_dbl);
if isShowFig
	figure('name', 'recImage');
	imshow(recImage);
end


% To be deleted
% attWMImage = wmImage;

jfsoia= jsiod;

% ==========================
% Normalization II - Attack
% ==========================
encryptedAttWMImage_dbl = double(encryptedAttWMImage);
[normEncryptedAttWMImage_dbl, normEncryptedAttFTable, attSYXMatrix, attMeanVector] = normalizeImage(encryptedAttWMImage_dbl, normHeight, normWidth, false);

normEncryptedAttWMImage = uint8(normEncryptedAttWMImage_dbl);

if isShowFig
	figure('name','normEncryptedAttWMImage');
	imshow(normEncryptedAttWMImage)
end




recEncryptedFTable = normEncryptedAttFTable;
recEncryptedFTable(:, 1:2) = (SYXMatrix^(-1) * recEncryptedFTable(:, 1:2)')';
recEncryptedFTable(:, 1) = recEncryptedFTable(:, 1) + meanVector(1);
recEncryptedFTable(:, 2) = recEncryptedFTable(:, 2) + meanVector(2);

recEncryptedImage_dbl = fTable2image(recEncryptedFTable);
recEncryptedImage = uint8(recEncryptedImage_dbl);

if isShowFig
	figure('name','recEncryptedImage');
	imshow(recEncryptedImage)
end

% ==========================
% Decryption
% ==========================

recImage_dbl = paillierDecrypt(recEncryptedImage_dbl, n_pk, lambda_sk, mu_sk);

recImage = uint8(recImage_dbl);
if isShowFig
	figure('name', 'recImage');
	imshow(recImage);
end

% tic
% recImage_dbl = cryptImage(recEncryptedImage_dbl, N_pk, d_sk);
% toc
% recImage = uint8(recImage_dbl);



% psnr(normalAttImage, normalOriginImage)
% if isShowFig
% 	dif = normalAttImage_dbl - normalOriginImage_dbl;
% 	figure
% 	spy(dif)
% end

% ==========================
% Extraction
% ==========================
% Step 2-(a)
% Regenerate the watermark patterns - DONE

% Step 2-(b)
recImage_dct = dct2(recImage);

% Step 2-(c)
% middle_band_idx = zigzagColMajor(1+3*imageArea/8:3*imageArea/8 + patternSize);
% wmSignature2(middle_band_idx) = wmSignature1;
cw = recImage_dct(middle_band_idx);

% Step 2-(d)
extractedWM = patterns' * cw;
extractedWM = extractedWM > 0;

wmDiff = extractedWM - watermark;
bitErrorRate = 100 * nnz(wmDiff) / length(watermark)


% psnr(recImage, wmImage)

end







