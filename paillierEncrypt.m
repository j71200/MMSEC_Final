function [cipherText] = paillierEncrypt(m, n, g)

if nnz(m > n) > 0
	disp('Error, message > n_pk');
	ERROR = HERE;

elseif nnz(m <= 0) > 0
	disp('Message include non-positive integer');
	
else
	nSquare = n^2;
	r = 3;
	c = speedPowerMod(g, m, nSquare) * speedPowerMod(r, n, nSquare);
	c = mod(c, nSquare);

	cipherText = c;
end

end