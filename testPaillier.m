% Paillier
function [c, recM] = testPaillier(m)

% =================
% key gen
% =================
% p = 17;
% q = 19;


% p = uint64(277);
% q = uint64(281);

% p = uint64(181);
% q = uint64(191);

% p = uint64(373);
% q = uint64(379);

% p = uint64(1667);
% q = uint64(1669);


p = uint64(251);
q = uint64(257);

phi = (p-1) * (q-1);
n = p * q;
nSquare = n^2;

g = n + 1;
mLambda = phi;
mMu = fastPowerMod(phi, phi-1, n);


% =================
% Encrypt
% =================
% m = 1;
r = uint64(3);
c = fastPowerMod(g, m, nSquare) * fastPowerMod(r, n, nSquare);
c = mod(c, nSquare);


% =================
% Decrypt
% =================
recU = fastPowerMod(c, mLambda, nSquare);
recL = floor((recU-1) / n);
recM = mod(recL * mMu, n);



end





