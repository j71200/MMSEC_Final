function [wmSignature, wmSignature_reg] = newAllInOne(originalImage_dbl, attackType, isShowFig)

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
normHeight = 512;
normWidth  = 512;
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

wmImage_dbl = originalImage_dbl + wmSignature2_idct;
wmImage = uint8(wmImage_dbl);

if isShowFig
	figure('name','wmImage');
	imshow(wmImage)
end

% imwrite(uint8(originalImage_dbl), './Experiment/wm/XXXX_gray.png');
% mPSNR = round(psnr(wmImage, uint8(originalImage_dbl)) * 10) / 10;
% imwrite(wmImage, ['./Experiment/wm/XXXX_wm_' num2str(mPSNR) '.png']);



[normalWmImage_dbl, normFTable, SYXMatrix, meanVector] = normalizeImage(wmImage_dbl, normHeight, normWidth, false);

normalWmImage = uint8(normalWmImage_dbl);
if isShowFig
	figure('name','normalWmImage');
	imshow(normalWmImage)
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

attWMImage = attackGray(wmImage, attackType, paraList(attackType));

if isShowFig
	figure('name','attWMImage');
	imshow(attWMImage)
end

% To be deleted
% attWMImage = wmImage;

% ==========================
% Normalization II - Attack
% ==========================
attWMImage_dbl = double(attWMImage);
[normalAttImage_dbl, normAttFTable, attSYXMatrix, attMeanVector] = normalizeImage(attWMImage_dbl, normHeight, normWidth, false);

normalAttImage = uint8(normalAttImage_dbl);

if isShowFig
	figure('name','normalAttImage');
	imshow(normalAttImage)
end




recFTable = normAttFTable;
recFTable(:, 1:2) = (SYXMatrix^(-1) * recFTable(:, 1:2)')';
recFTable(:, 1) = recFTable(:, 1) + meanVector(1);
recFTable(:, 2) = recFTable(:, 2) + meanVector(2);

recImage_dbl = fTable2image(recFTable);
recImage = uint8(recImage_dbl);

if isShowFig
	figure('name','recImage');
	imshow(recImage)
end





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







