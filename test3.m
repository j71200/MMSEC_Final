close all
clear
clc

p = uint64(251);
q = uint64(257);

[c, recM] = testPaillier(uint64(idx));


% for idx = 1:1000
% 	[c, recM] = testPaillier(uint64(idx));
% 	disp(recM);
% end


