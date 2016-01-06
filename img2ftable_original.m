function [ fTable ] = img2ftable( inputImage )
%img2ftable Summary of this function goes here
%   Detailed explanation goes here

[height width] = size(inputImage);
% imshow(inputImage)

[zzOrder, ~] = genaralZigzag(height, width);

fTableMax = zeros(height*width, 3);

for roundNum = 1:height*width
	zzIdx = zzOrder(roundNum);
	
	xx = mod(zzIdx, height);
	yy = ceil(zzIdx/height);
	
	fTableMax(roundNum, 1) = xx;
	fTableMax(roundNum, 2) = yy;
	fTableMax(roundNum, 3) = inputImage(zzIdx);
end

fTable = fTableMax();

disp(['all - nnz(fTable(:,3)) ========= ' num2str(height*width - nnz(fTable(:,3))) ]);



end

