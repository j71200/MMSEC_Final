function [imgSum, imgMax, imgMin, imgNNZ, accVector] = statImage(inputImage_uint)

imgSum = sum(sum(inputImage_uint));
imgMax = max(max(inputImage_uint));
imgMin = min(min(inputImage_uint));
imgNNZ = nnz(inputImage_uint);

[height width] = size(inputImage_uint);

range = imgMax + 1;
accVector = zeros(range, 1);
% for idx = 1:range+1
% 	accVector(idx) = nnz(inputImage_uint == idx-1);
% end

for idx = 1:height*width
	accVector(inputImage_uint(idx)+1) = accVector(inputImage_uint(idx)+1) + 1;
	% idx
end


end