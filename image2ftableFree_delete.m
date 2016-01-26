function [fTableX, fTableY, fTableF] = image2ftableFree(inputImage)

[height, width] = size(inputImage);

[zzOrder, ~] = genaralZigzag(height, width);

for idx = 1:height*width
	zzIdx = zzOrder(idx);
	if mod(zzIdx, height) ~= 0
		xx = mod(zzIdx, height);
	else
		xx = height;
	end
	yy = ceil(zzIdx / height) + 1;
	
	fTableX(idx) = xx;
	fTableY(idx) = yy;
	fTableF(idx) = inputImage(zzIdx);
end




end