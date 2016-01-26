function cropedImage = cropCircle(originalImage)


cropedImage = originalImage;
[height, width] = size(cropedImage);

radius = height / 2;
originX = (height+1) / 2;
originY = (width+1) / 2;

for idx = 1:height
	for jdx = 1:width
		if (idx-originX)^2 + (jdx-originY)^2 > radius^2
			cropedImage(idx, jdx) = 0;
		end
	end
end

end