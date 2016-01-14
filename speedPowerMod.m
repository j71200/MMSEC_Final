function res = speedPowerMod(base, power, modNum)

[baseHeight, baseWidth] = size(base);
baseArea = baseHeight * baseWidth;
[powHeight, powWidth] = size(power);
powArea = powHeight * powWidth;

% if (baseArea == 1) && (powArea == 1)
% 	res = base;
% 	for idx = 1:(power-1)
% 		res = mod(res * base, modNum);
% 	end
% elseif (baseArea == 1) && (powArea ~= 1)
% 	res = zeros(powHeight, powWidth);
% 	for idx = 1:powHeight*powWidth
% 		res(idx) = base;
% 		for jdx = 1:(power(idx)-1)
% 			res(idx) = mod(res(idx) .* base, modNum);
% 		end
% 	end
% elseif (baseArea ~= 1) && (powArea == 1)
% 	res = base;
% 	for idx = 1:(power-1)
% 		res = mod(res .* base, modNum);
% 	end
% else
% 	disp('Wrong!!!');
% end


if powArea == 1
	if power == 0
		res = zeros(size(base)) + 1;
	elseif power == 1
		res = mod(base, modNum);
	elseif mod(power, 2) == 0
		res = mod(speedPowerMod(base, power/2, modNum).^2, modNum);
	elseif mod(power, 2) == 1
		res = mod(speedPowerMod(base, (power-1)/2, modNum).^2, modNum);
		res = mod(res .* base, modNum);
	else
		disp('Wrong');
		power
	end
elseif (powArea ~= 1) && (baseArea == 1)
	powMax = max(max(power));
	powMin = min(min(power));
	
	powPlusOneTable = zeros(powMax + 1, 1);
	powPlusOneTable(powMin+1) = speedPowerMod(base, powMin, modNum);
	for idx = (powMin+2):(powMax+1)
		powPlusOneTable(idx) = mod(powPlusOneTable(idx-1) * base, modNum);
	end

	res = zeros(powHeight, powWidth);
	for idx = 1:powHeight
		for jdx = 1:powWidth
			res(idx, jdx) = powPlusOneTable(power(idx, jdx) + 1);
		end
	end
else
	disp('Wrong!!!!');
end


% if power == 0
% 	res = 1;
% elseif power == 1
% 	res = mod(base, modNum);
% elseif mod(power, 2) == 0
% 	res = mod(speedPowerMod(base, power/2, modNum)^2, modNum);
% elseif mod(power, 2) == 1
% 	res = mod(speedPowerMod(base, (power-1)/2, modNum)^2, modNum);
% 	res = mod(res * base, modNum);
% else
% 	disp('Wrong');
% 	power
% end

end
