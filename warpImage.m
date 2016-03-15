function nImg = warpImage(img1,H)
figure;
imshow(img1)
title('Office')
img1=double(img1);
%{
im = imread('cameraman.tif');
figure;
imshow(im);
title('camerman')
img1=double(im);
%}

hom=H;
hom = [1 0 128; 0 1 128; 0 0 1] * [1/2 0 0; 0 1/2 0; 0 0 1] * [1 0 -128; 0 1 -128; 0 0 1];
h = inv(hom);

[xi, yi] = meshgrid(1:size(img1,2),1:size(img1,1)); %not sure if this works
xx = (h(1,1)*xi+h(1,2)*yi+h(1,3))./(h(3,1)*xi+h(3,2)*yi+h(3,3));
yy = (h(2,1)*xi+h(2,2)*yi+h(2,3))./(h(3,1)*xi+h(3,2)*yi+h(3,3));

img1Trans = uint8(interp2(img1,xx,yy));
figure;
imshow(img1Trans)
title('Trans Image')

nImg = img1Trans;
