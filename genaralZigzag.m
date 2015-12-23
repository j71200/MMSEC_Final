function [ zigzagColMajor, zigzagMatrix ] = genaralZigzag( height, width )
% ===========================
%        genaralZigzag
% ===========================
% parameters
%   height: number of rows
%   width : number of columns
% output
%   zigzagColMajor: a column-major index for zigzag scanning on a matrix
%   zigzagMatrix  : a matrix with each entry record its zigzag order
% ===========================

zigzagColMajor = zeros(height*width, 1);
zigzagColMajor(1) = 1;
zigzagMatrix = zeros(height, width);
zigzagMatrix(1, 1) = 1;

currentStep = 1;
% currentStep contains {right(down), left_down, down(right), right_up}

x=1; % width
y=1; % height
zzOrder = 1;
while zzOrder < height*width

	if currentStep == 1
		if (x + 1) <= width
			x = x + 1;
			zzOrder = zzOrder + 1;
			zigzagColMajor(zzOrder) = (x-1)*height + y;
			zigzagMatrix(y, x) = zzOrder;
			currentStep = 2;
		elseif (y + 1) <= height
			y = y + 1;
			zzOrder = zzOrder + 1;
			zigzagColMajor(zzOrder) = (x-1)*height + y;
			zigzagMatrix(y, x) = zzOrder;
			currentStep = 2;
		else
			disp(['End at step 1']);
		end

	elseif currentStep == 2
		if ((x - 1) >= 1) && ((y + 1) <= height)
			x = x - 1;
			y = y + 1;
			zzOrder = zzOrder + 1;
			zigzagColMajor(zzOrder) = (x-1)*height + y;
			zigzagMatrix(y, x) = zzOrder;
			currentStep = 2;
		else
			currentStep = 3;
		end

	elseif currentStep == 3
		if ((y + 1) <= height)
			y = y + 1;
			zzOrder = zzOrder + 1;
			zigzagColMajor(zzOrder) = (x-1)*height + y;
			zigzagMatrix(y, x) = zzOrder;
			currentStep = 4;
		elseif ((x + 1) <= width)
			x = x + 1;
			zzOrder = zzOrder + 1;
			zigzagColMajor(zzOrder) = (x-1)*height + y;
			zigzagMatrix(y, x) = zzOrder;
			currentStep = 4;
		end

	elseif currentStep == 4
		if ((x + 1) <= width) && ((y - 1) >= 1)
			x = x + 1;
			y = y - 1;
			zzOrder = zzOrder + 1;
			zigzagColMajor(zzOrder) = (x-1)*height + y;
			zigzagMatrix(y, x) = zzOrder;
			currentStep = 4;
		else
			currentStep = 1;
		end
	end

end

