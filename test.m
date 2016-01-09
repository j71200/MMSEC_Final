close all
clear('all');
clc

addpath('./RSA')


% The value of (N) is: 72899
% The public key (e) is: 7
% The value of (Phi) is: 72360
% The private key (d)is: 62023


% M = randi([0, 255], 5)

% N = 72899;
% e = 7;

% e = dec2bin(e);
% k = 65535;
% c  = M;
% cf = zeros(size(M)) + 1;
% cf = mod(c .* cf, N);
% for i = k-1:-1:1
%     c = mod(c .* c, N);
%     j = k - i + 1;
%      if e(j)==1
%          cf = mod(c .* cf, N);
%      end
% end

% cf


% e = dec2bin(62023);
% k = 65535;
% c  = cf;
% cf = zeros(size(M)) + 1;
% cf = mod(c .* cf, N);
% for i = k-1:-1:1
%     c = mod(c .* c, N);
%     j = k - i + 1;
%      if e(j)==1
%          cf = mod(c .* cf, N);
%      end
% end

% cf




% p = 991;
% q = 997;

p = 269;
q = 271;

[N_pk, Phi, d_sk, e_pk] = intialize(p,q);

im = imread('./Experiment/lena.bmp');
im = rgb2gray(im);
im_dbl = double(im);

% im_dbl = randi([0, 255], 5);
% figure
% image(im_dbl)

startEncTime = clock;
disp(['Start encode:' num2str(startEncTime(2)) '-' num2str(startEncTime(3)) ' ' num2str(startEncTime(4)) ':' num2str(startEncTime(5)) ]);
encIm_dbl = cryptImage(im_dbl, N_pk, e_pk);
% figure
% image(encIm_dbl)
endEncTime = clock;
disp(['End encode:' num2str(endEncTime(2)) '-' num2str(endEncTime(3)) ' ' num2str(endEncTime(4)) ':' num2str(endEncTime(5)) ]);




startDecTime = clock;
disp(['Start decode:' num2str(startDecTime(2)) '-' num2str(startDecTime(3)) ' ' num2str(startDecTime(4)) ':' num2str(startDecTime(5)) ]);
decIm_dbl = cryptImage(encIm_dbl, N_pk, d_sk);
% figure
% image(decIm_dbl)
endDecTime = clock;
disp(['End decode:' num2str(endDecTime(2)) '-' num2str(endDecTime(3)) ' ' num2str(endDecTime(4)) ':' num2str(endDecTime(5)) ]);

% im = uint8(im_dbl);
% encIm = uint8(encIm_dbl)

% tic
% decIm_dbl = cryptImage(encIm_dbl, N_pk, d_sk);
% toc



