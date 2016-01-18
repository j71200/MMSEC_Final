function [ moment_uint ] = geoMoment( fTableX, fTableY, fTableF_uint, p, q )
%GEOMOMENT Summary of this function goes here
%   Detailed explanation goes here
moment_dbl = (fTableX.^p) .* (fTableY.^q) .* double(fTableF_uint);
moment_dbl = sum(moment_dbl);
moment_uint = uint64(moment_dbl);

% moment_uint = uint64(0);
% for idx = 1:length(fTableF_uint)
% 	moment_uint = moment_uint + fTableX(idx)^p * fTableY(idx)^q * fTableF_uint(idx);
% end

end

