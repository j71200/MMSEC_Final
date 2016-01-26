function [ geomoment ] = geoMomentDbl( fTableX, fTableY, fTableF, p, q )
%GEOMOMENT Summary of this function goes here
%   Detailed explanation goes here
geomoment = (fTableX.^p) .* (fTableY.^q) .* fTableF;
geomoment = sum(geomoment);

end

