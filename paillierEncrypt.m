function [cipherText] = paillierEncrypt(m, n, g)

if nnz(m > n) > 0
	disp('Error, message > n_pk');
	ERROR = HERE;
	
else
	nSquare = n^2;
	r = 3;
	c = powerMod(g, m, nSquare) * powerMod(r, n, nSquare);
	c = mod(c, nSquare);

	cipherText = c;
end

end