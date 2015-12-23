function [ fTable ] = constructF( inputImage )
%CONSTRUCTF Summary of this function goes here
%   Detailed explanation goes here

[height width] = size(inputImage);
% imshow(inputImage)

[zzOrder, ~] = genaralZigzag(height, width);

fTableMax = zeros(height*width, 3);

counter = 0;
for roundNum = 1:height*width
	zzIdx = zzOrder(roundNum);
	if inputImage(zzIdx) > 0
		counter = counter + 1;
		if mod(zzIdx, height) ~= 0
			xx = mod(zzIdx, height);
		else
			xx = height;
		end
		yy = ceil(zzIdx / height) + 1;
		
		fTableMax(counter, 1) = xx;
		fTableMax(counter, 2) = yy;
		fTableMax(counter, 3) = inputImage(zzIdx);
	end
end

fTable = fTableMax(1:counter, :);

end

