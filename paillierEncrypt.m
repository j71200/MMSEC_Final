function [cipherText] = paillierEncrypt(m_uint, n_uint, g_uint, r_uint)

UINT64MAX = uint64(2^64);

if nnz(m_uint > n_uint) > 0
	disp('Error, message > n_pk');
	ERROR = HERE;

elseif nnz(m_uint < 0) > 0
	disp('Message include negative integer');
	ERROR = HERE;

elseif nnz(m_uint == 0) > 0
	occupiedIndex = find(m_uint);
	occupiedM_uint = m_uint(occupiedIndex);

	nSquare_uint = n_uint^2;
	% r_uint = uint64(3);
	c_uint = fastPowerMod(g_uint, occupiedM_uint, nSquare_uint) * fastPowerMod(r_uint, n_uint, nSquare_uint);
	if c_uint == UINT64MAX
		disp('Warning, c_uint == UINT64MAX');
	end
	c_uint = mod(c_uint, nSquare_uint);

	cipherText = uint64(zeros(size(m_uint)));
	cipherText(occupiedIndex) = c_uint;
	% disp('Message include zero');
	% ERROR = HERE;

else
	% m_uint = uint64(m);
	% n_uint = uint64(n);
	% g_uint = uint64(g);

	nSquare_uint = n_uint^2;
	% r_uint = uint64(3);
	c_uint = fastPowerMod(g_uint, m_uint, nSquare_uint) * fastPowerMod(r_uint, n_uint, nSquare_uint);
	if c_uint == UINT64MAX
		disp('Warning, c_uint == UINT64MAX');
	end
	c_uint = mod(c_uint, nSquare_uint);

	cipherText = c_uint;
end

end