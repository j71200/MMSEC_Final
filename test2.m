close all
clear
clc

img = imread('./Experiment/lena.bmp');
img = rgb2gray(img);
img = imresize(img, [128, 128]);

a = uint8(zeros(size(img)));


[height, width] = size(a);
radius = height / 2;
originX = (height+1) / 2;
originY = (width+1) / 2;
for idx = 1:size(a, 1)
	for jdx = 1:size(a, 2)
		if (idx-originX)^2 + (jdx-originY)^2 <= radius^2
			a(idx, jdx) = 255;
		end
	end
end


figure
imshow(a)

