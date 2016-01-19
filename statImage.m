function [imgSum, imgMax, imgMin, imgNNZ] = statImage(inputImage_uint)

imgSum = sum(sum(inputImage_uint));
imgMax = max(max(inputImage_uint));
imgMin = min(min(inputImage_uint));
imgNNZ = nnz(inputImage_uint);

end