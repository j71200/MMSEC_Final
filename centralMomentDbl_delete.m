function [ centmoment ] = centralMomentDbl( fTableX, fTableY, fTableF, p, q )
%CENTRALMOMENT Summary of this function goes here
%   Detailed explanation goes here

m_1_0 = geoMomentDbl(fTableX, fTableY, fTableF, 1, 0);
m_0_0 = geoMomentDbl(fTableX, fTableY, fTableF, 0, 0);
m_0_1 = geoMomentDbl(fTableX, fTableY, fTableF, 0, 1);
x_mean = m_1_0 / m_0_0;
y_mean = m_0_1 / m_0_0;

centFTableX = fTableX - x_mean;
centFTableY = fTableY - y_mean;

centmoment = (centFTableX.^p) .* (centFTableY.^q) .* fTableF;
centmoment = sum(centmoment);

end

