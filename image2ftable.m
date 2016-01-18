function [ fTableX, fTableY, fTableF_uint ] = image2ftable( inputImage_uint )
%img2ftable Summary of this function goes here
%   Detailed explanation goes here

[height width] = size(inputImage_uint);
% imshow(inputImage_uint)

[zzOrder, ~] = genaralZigzag(height, width);

% fTableMax = zeros(height*width, 3);
fTableXMax = zeros(height*width, 1);
fTableYMax = zeros(height*width, 1);
fTableFMax_uint = uint64(zeros(height*width, 1));

counter = 0;
for roundNum = 1:height*width
	zzIdx = zzOrder(roundNum);
	if inputImage_uint(zzIdx) > 0
		counter = counter + 1;
		if mod(zzIdx, height) ~= 0
			xx = mod(zzIdx, height);
		else
			xx = height;
		end
		yy = ceil(zzIdx / height) + 1;
		
		fTableXMax(counter) = xx;
		fTableYMax(counter) = yy;
		fTableFMax_uint(counter) = inputImage_uint(zzIdx);
	end
end
% counter
% length(fTableXMax)
fTableX = fTableXMax(1:counter);
fTableY = fTableYMax(1:counter);
fTableF_uint = fTableFMax_uint(1:counter);

% fTable = fTableMax(1:counter, :);

end

