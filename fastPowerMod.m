function res_uint = fastPowerMod(base_uint, power_uint, modNum_uint)

[baseHeight, baseWidth] = size(base_uint);
baseArea = baseHeight * baseWidth;
[powHeight, powWidth] = size(power_uint);
powArea = powHeight * powWidth;

if powArea == 1
	if power_uint == 0
		res_uint = uint64(zeros(size(base_uint))) + 1;
	elseif power_uint == 1
		res_uint = mod(base_uint, modNum_uint);
	elseif mod(power_uint, 2) == 0
		res_uint = mod(fastPowerMod(base_uint, power_uint/2, modNum_uint).^2, modNum_uint);
	elseif mod(power_uint, 2) == 1
		res_uint = mod(fastPowerMod(base_uint, (power_uint-1)/2, modNum_uint).^2, modNum_uint);
		res_uint = mod(res_uint .* base_uint, modNum_uint);
	else
		disp('Wrong');
		power_uint
	end
elseif (powArea ~= 1) && (baseArea == 1)
	powMax = max(max(power_uint));
	powMin = min(min(power_uint));
	
	powPlusOneTable_uint = uint64(zeros(powMax + 1, 1));
	powPlusOneTable_uint(powMin+1) = fastPowerMod(base_uint, powMin, modNum_uint);
	for idx = (powMin+2):(powMax+1)
		powPlusOneTable_uint(idx) = mod(powPlusOneTable_uint(idx-1) * base_uint, modNum_uint);
	end

	res_uint = uint64(zeros(powHeight, powWidth));
	for idx = 1:powHeight
		for jdx = 1:powWidth
			res_uint(idx, jdx) = powPlusOneTable_uint(power_uint(idx, jdx) + 1);
		end
	end
else
	disp('Wrong!!!!');
end

end
