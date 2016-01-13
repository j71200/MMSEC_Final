function [cipherText] = paillierEncrypt(m, n, g)

nSquare = n^2;
r = 3;
c = powerMod(g, m, nSquare) * powerMod(r, n, nSquare);
c = mod(c, nSquare);

cipherText = c;

end