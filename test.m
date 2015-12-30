close all
clear('all');
clc

% wmSize = 8*1024*8; % 8KB
wmSize = 256; % 8KB
watermark = randi([0, 1], wmSize, 1);
patternSize = 256 * 256; % 必須大於大於 wmSize才行
patterns = sign(randn(patternSize, wmSize));

% wmSignature1 = patterns * (2*watermark_8KB-1);
% wmSignature2 = 



% corMatrix = patterns' * wmSignature1;
% recoveredWM = corMatrix > 0;
% n = nnz(watermark_8KB - recoveredWM)
% 100*n/wmSize


save('data_wm256_pt256x256.mat');




