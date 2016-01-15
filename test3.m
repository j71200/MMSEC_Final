close all
clear
clc

% p = 373;
% q = 379;

% p = 17;
% q = 19;

% p = 1667;
% q = 1669;

% n = p * q;
% g = n + 1;
% lambda = (p-1)*(q-1);

p = uint64(251);
q = uint64(257);


for idx = 1:1000
	[c, recM] = testPaillier(uint64(idx));
	disp(recM);
end


