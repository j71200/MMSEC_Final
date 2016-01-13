% Paillier

function [recM] = testPaillier(m)

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

% g = 2;


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
% m = 1;
r = 3;
c = powerMod(g, m, nSquare) * powerMod(r, n, nSquare);
c = mod(c, nSquare);


% =================
% Decrypt
% =================
recU = powerMod(c, mLambda, nSquare);
recL = floor((recU-1) / n);
recM = mod(recL * mMu, n);


end





