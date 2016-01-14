function [ image_dbl ] = fTable2image( fTable )
%FTABLE2IMAGE Summary of this function goes here
%   Detailed explanation goes here

fTable = round(fTable);

[fTableSize ~] = size(fTable);
x_min = min(fTable(:, 1));
x_max = max(fTable(:, 1));
y_min = min(fTable(:, 2));
y_max = max(fTable(:, 2));
height = x_max - x_min + 1;
width  = y_max - y_min + 1;
image_dbl = zeros(height, width);

fTable(:, 1) = fTable(:, 1) - x_min + 1;
fTable(:, 2) = fTable(:, 2) - y_min + 1;

for idx = 1:fTableSize
	image_dbl(fTable(idx, 1), fTable(idx, 2)) = fTable(idx, 3);
end

end

