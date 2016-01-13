function res = powerMod(base, power, modNum)

[baseHeight, baseWidth] = size(base);
baseArea = baseHeight * baseWidth;
[powHeight, powWidth] = size(power);
powArea = powHeight * powWidth;
if (baseArea == 1) && (powArea == 1)
	res = base;
	for idx = 1:(power-1)
		res = mod(res * base, modNum);
	end
elseif (baseArea == 1) && (powArea ~= 1)
	res = zeros(powHeight, powWidth);
	for idx = 1:powHeight*powWidth
		res(idx) = base;
		for jdx = 1:(power(idx)-1)
			res(idx) = mod(res(idx) .* base, modNum);
		end
	end
elseif (baseArea ~= 1) && (powArea == 1)
	res = base;
	for idx = 1:(power-1)
		res = mod(res .* base, modNum);
	end
else
	disp('Wrong!!!');
end

end

