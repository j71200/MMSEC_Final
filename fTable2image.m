function [ image_uint ] = fTable2image( fTableX, fTableY, fTableF_uint )
%FTABLE2IMAGE Summary of this function goes here
%   Detailed explanation goes here

fTableX = round(fTableX);
fTableY = round(fTableY);

x_min = min(fTableX);
x_max = max(fTableX);
y_min = min(fTableY);
y_max = max(fTableY);
height = x_max - x_min + 1;
width  = y_max - y_min + 1;
image_uint = uint64(zeros(height, width));

fTableX = fTableX - x_min + 1;
fTableY = fTableY - y_min + 1;

for idx = 1:length(fTableF_uint)
	image_uint(fTableX(idx), fTableY(idx)) = fTableF_uint(idx);
end

end

