% Paillier
function [c, recM] = testPaillier(m)

% =================
% key gen
% =================
% p = 17;
% q = 19;

p = uint64(251);
q = uint64(257);

% p = uint64(277);
% q = uint64(281);

% p = uint64(181);
% q = uint64(191);

% p = uint64(373);
% q = uint64(379);

% p = 1667;
% q = 1669;

phi = (p-1) * (q-1);
% if gcd(p*q, phi)==1
% 	disp('TEST1 OK');
% end

n = p * q;
% mLambda = lcm(p-1, q-1);

nSquare = n^2;

% g = 1;
% while true
% 	% g = randi([0, n^2]);
% 	g = g + 1;
% 	u = fastPowerMod(g, mLambda, nSquare);
% 	L = floor((u-1) / n);
% 	if (gcd(g, nSquare) == 1) && (gcd(L, n) == 1)
% 		break;
% 	end
% end

% g = 2;

% u = fastPowerMod(g, mLambda, nSquare);
% L = floor((u-1) / n);
% mMu = fastPowerMod(L, phi-1, n);
% mod(L*mMu, n)

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





