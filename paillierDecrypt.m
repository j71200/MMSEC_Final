function [decryptedText] = paillierDecrypt(c, n, mLambda, mMu)

nSquare = n^2;
recU = fastPowerMod(c, mLambda, nSquare);
recL = floor((recU-1) / n);
recM = mod(recL * mMu, n);

decryptedText = recM;

end