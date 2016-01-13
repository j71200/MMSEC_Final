function [wmSignature, wmSignature_reg] = encAllInOne(originalImage_dbl, attackType, isShowFig)


% ==========================
% Encryption
% ==========================
randMatrixMult = 1 * rand(size(originalImage_dbl));
randMatrixAdd = 1000 * rand(size(originalImage_dbl));
originalImage_enc = randMatrixMult .* originalImage_dbl + randMatrixAdd;

% figure
% image(originalImage_enc)
% figure
% imshow(uint8((originalImage_enc - randMatrixAdd) ./ randMatrixMult))


% ====================================================
%                  Embedding Watermark
% ====================================================

% ==========================
% Normalization I - Original
% ==========================
normHeight = 512;
normWidth  = 512;
[normalOriginImage_enc, normFTable, SYXMatrix, meanVector] = normalizeImage(originalImage_enc, normHeight, normWidth, false);
% normalOriginImage = uint8(normalOriginImage_enc);
% if isShowFig
% 	figure
% 	imshow(normalOriginImage)
% 	title('normalOriginImage')
% end

% ==========================
% Embedding Watermark
% ==========================

% Step 2-(a)
load('data_wm256_pt256x256');

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
maskImage = normalOriginImage_enc > 0;

% nnz(normalOriginImage)

% nnzOForiginalImage_dbl =  nnz(originalImage_dbl);
% nnzOForiginalImage_dbl

% nnz_normFTable = nnz(normFTable(:, 3));
% nnz_normFTable

% Step 4
wmSignature = maskImage .* wmSignature2_idct;

% Step 5
wmSignFTable = img2ftable(wmSignature);
wmSignFTable(:, 1:2) = (SYXMatrix^(-1) * wmSignFTable(:, 1:2)')';
wmSignFTable(:, 1) = wmSignFTable(:, 1) + meanVector(1);
wmSignFTable(:, 2) = wmSignFTable(:, 2) + meanVector(2);

wmSignature_reg = fTable2image(wmSignFTable);
% size(wmSignature_reg)
% nnz(wmSignature_reg(1,:))
% nnz(wmSignature_reg(end,:))
% nnz(wmSignature_reg(:,1))
% nnz(wmSignature_reg(:,end))

% Step 6
wmSignature_reg = double(wmSignature_reg); %wmSignature_reg means regular wmSignature

% wmImage = originalImage_dbl + wmSignature_reg(2:end-1, 2:end-1);

roundCauseHeight = size(wmSignature_reg, 1) - normHeight;
roundCauseWidth = size(wmSignature_reg, 2) - normWidth;
if roundCauseHeight == 1
	firstRowNNZ = nnz(wmSignature_reg(1, :));
	LastRowNNZ = nnz(wmSignature_reg(end, :));
	if firstRowNNZ <= LastRowNNZ
		startRow = 2;
	else
		startRow = 1;
	end
elseif roundCauseHeight == 2
	startRow = 2;
elseif roundCauseHeight == 0
	% Do nothing
else
	disp('roundCauseHeight exception!');
end

if roundCauseWidth == 1
	firstColNNZ = nnz(wmSignature_reg(:, 1));
	LastColNNZ = nnz(wmSignature_reg(:, end));
	if firstColNNZ <= LastColNNZ
		startCol = 2;
	else
		startCol = 1;
	end
elseif roundCauseWidth == 2
	startCol = 2;
elseif roundCauseWidth == 0
	% Do nothing
else
	disp('roundCauseWidth exception!');
end

endRow = startRow + normHeight - 1;
endCol = startCol + normWidth - 1;


wmSignature_enc = randMatrix * wmSignature_reg(startRow:endRow, startCol:endCol);
wmImage_enc = originalImage_enc + wmSignature_enc;
% wmImage = originalImage_dbl + wmSignature_reg(1:512, 2:513);

% wmImage = uint8(wmImage);

% imwrite(uint8(originalImage_dbl), './Experiment/wm/XXXX_gray.png');
% mPSNR = round(psnr(wmImage, uint8(originalImage_dbl)) * 10) / 10;
% imwrite(wmImage, ['./Experiment/wm/XXXX_wm_' num2str(mPSNR) '.png']);

% if isShowFig
% 	figure
% 	imshow(wmImage)
% 	title('wmImage')
% end


% ====================================================
%                  Attacking Watermark
% ====================================================

% ==========================
% Decryption
% ==========================
wmImage_dbl = inv(randMatrix) * wmImage_enc;
% figure
% imshow(uint8(wmImage_dec))

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

% attWMImage = attackGray(wmImage, attackType, paraList(attackType));

if isShowFig
	figure
	imshow(attWMImage)
	title('attWMImage')
end

% To be deleted
attWMImage_dbl = wmImage_dbl;


% ====================================================
%                  Extraction Watermark
% ====================================================

% ==========================
% Encryption
% ==========================
% figure
% imshow(uint8(attWMImage_dbl))
attWMImage_enc = randMatrix * attWMImage_dbl;


% ==========================
% Normalization II - Attack
% ==========================
% attWMImage_dbl = double(attWMImage);
[normalAttImage_enc, normAttFTable, attSYXMatrix, attMeanVector] = normalizeImage(attWMImage_enc, normHeight, normWidth, false);

% normalAttImage = uint8(normalAttImage_dbl);

if isShowFig
	figure
	imshow(normalAttImage)
	title('normalAttImage')
end


% psnr(normalAttImage, normalOriginImage)
if isShowFig
	dif = normalAttImage_dbl - normalOriginImage_enc;
	figure
	spy(dif)
end

% ==========================
% Decryption
% ==========================
% normalAttImage_dbl = inv(randMatrix) * double(normalAttImage_enc);

normAttImage_enc_ftable = img2ftable(normalAttImage_enc);
normAttImage_enc_ftable(:, 1:2) = (SYXMatrix^(-1) * normAttImage_enc_ftable(:, 1:2)')';
normAttImage_enc_ftable(:, 1) = normAttImage_enc_ftable(:, 1) + meanVector(1);
normAttImage_enc_ftable(:, 2) = normAttImage_enc_ftable(:, 2) + meanVector(2);

regularAttImage_enc = fTable2image(normAttImage_enc_ftable);




% recoveredAttImage_enc = inv(SYXMatrix) * double(normalAttImage_enc);

whos regularAttImage_enc
nnz(regularAttImage_enc(1,:))
nnz(regularAttImage_enc(end,:))
nnz(regularAttImage_enc(:,1))
nnz(regularAttImage_enc(:,end))

regularAttImage_dbl = inv(randMatrix) * double(regularAttImage_enc(1:normHeight, 2:normWidth+1));

figure
imshow(uint8(regularAttImage_dbl))



% % ==========================
% % Extraction
% % ==========================
% % Step 2-(a)
% % Regenerate the watermark patterns - DONE

% % Step 2-(b)
% normalAttImage_dct = dct2(normalAttImage);

% % Step 2-(c)
% % middle_band_idx = zigzagColMajor(1+3*imageArea/8:3*imageArea/8 + patternSize);
% % wmSignature2(middle_band_idx) = wmSignature1;
% cw = normalAttImage_dct(middle_band_idx);

% % Step 2-(d)
% extractedWM = patterns' * cw;
% extractedWM = extractedWM > 0;

% wmDiff = extractedWM - watermark;
% % [watermark extractedWM]
% bitErrorRate = 100 * nnz(wmDiff) / length(watermark)




end







