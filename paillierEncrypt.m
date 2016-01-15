function [cipherText] = paillierEncrypt(m, n, g)

UINT64MAX = uint64(2^64);

if nnz(m > n) > 0
	disp('Error, message > n_pk');
	ERROR = HERE;

elseif nnz(m <= 0) > 0
	disp('Message include non-positive integer');
	
else
	% m_uint = uint64(m);
	% n_uint = uint64(n);
	% g_uint = uint64(g);

	nSquare_uint = n_uint^2;
	r_uint = uint64(3);
	c_uint = fastPowerMod(g_uint, m_uint, nSquare_uint) * fastPowerMod(r_uint, n_uint, nSquare_uint);
	if c_uint == UINT64MAX
		disp('Warning, c_uint == UINT64MAX');
	end
	c_uint = mod(c_uint, nSquare_uint);

	cipherText = c_uint;
end

end