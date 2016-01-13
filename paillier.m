clear
clc
% Paillier

% function [recM] = testPaillier(m)


originalImage = imread('./Experiment/airplane.bmp');
% originalImage = imread('./Experiment/baboon.bmp');
% originalImage = imread('./Experiment/fruits.bmp');
% originalImage = imread('./Experiment/peppers.bmp');
% originalImage = imread('./Experiment/lena.bmp');

originalImage = rgb2gray(originalImage);
originalImage_dbl = double(originalImage);
isShowFig = 1;

normHeight = 128;
normWidth  = 128;

originalImage = imresize(originalImage, [normHeight, normWidth]);
originalImage_dbl = double(originalImage);

if isShowFig
	figure('name', 'originalImage');
	imshow(originalImage);
end




% =================
% key gen
% =================
p = 17;
q = 19;
phi = (p-1) * (q-1);
% gcd(p*q, phi)

n = p * q;
% mLambda = lcm(p-1, q-1);

nSquare = n^2;

% g = 1;
% while true
% 	% g = randi([0, n^2]);
% 	g = g + 1;
% 	u = powerMod(g, mLambda, nSquare);
% 	L = floor((u-1) / n);
% 	if (gcd(g, nSquare) == 1) && (gcd(L, n) == 1)
% 		break;
% 	end
% end


% u = powerMod(g, mLambda, nSquare);
% L = floor((u-1) / n);
% mMu = powerMod(L, phi-1, n);
% mod(L*mMu, n)

g = n + 1;
mLambda = phi;
mMu = powerMod(phi, phi-1, n);


% =================
% Encrypt
% =================

m = originalImage_dbl;

r = 3;
encImage_dbl = powerMod(g, m, nSquare) * powerMod(r, n, nSquare);
encImage_dbl = mod(encImage_dbl, nSquare);


encImage = uint8(encImage_dbl);
if isShowFig
	figure('name', 'encImage');
	imshow(encImage);
end


% =================
% Decrypt
% =================
recU = powerMod(encImage_dbl, mLambda, nSquare);
recL = floor((recU-1) / n);
decImage_dbl = mod(recL * mMu, n);

decImage = uint8(decImage_dbl);
if isShowFig
	figure('name', 'decImage');
	imshow(decImage);
end





