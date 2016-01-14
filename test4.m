clear
clc

a = 19223;
e = 2550000;
n = 1667 * 1669;


base = 19923;
power = randi([0, 255], 512);
modNum = 1667 * 1669;

res = speedPowerMod(base, power, modNum);


% tic
% testPowerMod(a, e, n)
% toc

% tic
% powerMod(a, e, n)
% toc

% tic
% mod(a^e, n)
% toc

