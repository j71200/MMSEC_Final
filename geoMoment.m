function [ moment ] = geoMoment( fTable, p, q )
%GEOMOMENT Summary of this function goes here
%   Detailed explanation goes here

moment = 0;
[m ~] = size(fTable);
for idx = 1:m
	moment = moment + fTable(idx, 1)^p * fTable(idx, 2)^q * fTable(idx, 3);
end

end

