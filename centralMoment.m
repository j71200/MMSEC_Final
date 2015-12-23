function [ moment ] = centralMoment( fTable, p, q )
%CENTRALMOMENT Summary of this function goes here
%   Detailed explanation goes here

m_1_0 = geoMoment(fTable, 1, 0);
m_0_0 = geoMoment(fTable, 0, 0);
m_0_1 = geoMoment(fTable, 0, 1);
x_mean = m_1_0 / m_0_0;
y_mean = m_0_1 / m_0_0;

moment = 0;
[m ~] = size(fTable);
for idx = 1:m
	moment = moment + (fTable(idx, 1) - x_mean)^p * (fTable(idx, 2) - y_mean)^q * fTable(idx, 3);
end

end

