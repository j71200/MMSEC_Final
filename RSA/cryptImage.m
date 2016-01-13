function encryptedImg_dbl = cryptImage(plainImage_dbl, N_pk, e_pk)
% Input:
%  - plainImage_dbl: a double gray image.

% Output:
%  - encryptedImg_dbl: a double gray image.

% addpath('./RSA');

% p = 269, q = 271;
% The value of (N) is: 72899
% The public key (e) is: 7
% The value of (Phi) is: 72360
% The private key (d)is: 62023



[height, width] = size(plainImage_dbl);
encryptedImg_dbl = plainImage_dbl;
for idx = 1:(e_pk-1)
	if rand(1) < 100/(e_pk-1)
		disp(100*idx/(e_pk-1));
	end
	encryptedImg_dbl = mod(encryptedImg_dbl .* plainImage_dbl, N_pk);
end






% M = plainImage_dbl;
% N = N_pk;
% e = e_pk;

% e = dec2bin(e);
% k = length(e);

% c  = M;
% cf = zeros(size(M)) + 1;
% cf = mod(c .* cf, N);
% for i = k-1:-1:1

% 	if rand(1) < 100/(k-1)
% 		disp(100*(k-i)/(k-1));
% 	end

%     c = mod(c .* c, N);
%     j = k - i + 1;
%      if e(j)==1
%          cf = mod(c .* cf, N);
%      end
% end

% encryptedImg_dbl = cf;






% e = dec2bin(e);
% k = 65535;
% c  = M;
% cf = 1;
% cf=mod(c*cf,N);
% for i=k-1:-1:1
%     c = mod(c*c,N);
%     j=k-i+1;
%      if e(j)==1
%          cf=mod(c*cf,N);
%      end
% end
% mc=cf;

end