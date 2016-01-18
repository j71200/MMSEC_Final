function [ centMoment_dbl ] = centralMoment( fTableX, fTableY, fTableF_uint, p, q )
%CENTRALMOMENT Summary of this function goes here
%   Detailed explanation goes here

m_1_0_uint = geoMoment(fTableX, fTableY, fTableF_uint, 1, 0);
m_0_0_uint = geoMoment(fTableX, fTableY, fTableF_uint, 0, 0);
m_0_1_uint = geoMoment(fTableX, fTableY, fTableF_uint, 0, 1);
x_mean = double(m_1_0_uint) / double(m_0_0_uint);
y_mean = double(m_0_1_uint) / double(m_0_0_uint);

% centMoment_dbl = uint64(0);
centFTableX = fTableX - x_mean;
centFTableY = fTableY - y_mean;

centMoment_dbl = (centFTableX.^p) .* (centFTableY.^q) .* double(fTableF_uint);
centMoment_dbl = sum(centMoment_dbl);



% for idx = 1:length(fTableF_uint)
% 	centMoment_dbl = centMoment_dbl + (fTableX(idx) - x_mean)^p * (fTableY(idx) - y_mean)^q * fTableF_uint(idx);
% end

end

