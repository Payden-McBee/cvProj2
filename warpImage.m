function nImg = warpImage(img1,H)

%%%%%%%%%%%%%%%%%%%%%%
% transform 4 corners of image with homography

img2Xmin = 1;
img2Ymin = 1;
img2Xmax = size(img2,1);
img2Ymax = size(img2,2);

topLcorner1 = [1 1 1]';
topRcorner1 = [1 size(img1,2) 1]';
botLcorner1 = [size(img1,1) 1 1]';
botRcorner1 = [size(img1,1) size(img1,2) 1]';

tLcTrans = round(H*topLcorner1);
tRcTrans = round(H*topRcorner1);
bLcTrans = round(H*botLcorner1);
bRcTrans = round(H*botRcorner1);

% determine destination image size from bounds of transformed img1 and img2
minXval = min( min( tLcTrans(1,1),bLcTrans(1,1) ) ,img2Xmin );
maxXval = max( max( tRcTrans(1,1),bRcTrans(1,1) ) ,img2Xmax );

minYval = min( min( tLcTrans(2,1),bLcTrans(2,1) ) ,img2Ymin );
maxYval = max( max( tRcTrans(2,1),bRcTrans(2,1) ) ,img2Ymax );

if minXval < 1
    leftMargin = abs(minXval);
    rightMargin =0; %only 1 side can be out of bounds bc same size image
else
    leftMargin = 0; 
    if maxXval > img2Xmax
        rightMargin = maxXval - img2Xmax;
    else
        rightMargin = 0;
    end
end

if minYval < 1
    topMargin = abs(minYval);
    botMargin =0; %only 1 side can be out of bounds bc same size image
else
    topMargin = 0; 
    if maxYval > img2Ymax
        botMargin = maxYval - img2Ymax;
    else
        botMargin = 0;
    end
end

numRows = size(img2,1) + leftMargin + rightMargin;
numCols = size(img2,2) + topMargin + botMargin;

destI = zeros(numRows,numCols);
%%%%%%%%%%%%%%%%%%%%%%




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
%hom = [1 0 128; 0 1 128; 0 0 1] * [1/2 0 0; 0 1/2 0; 0 0 1] * [1 0 -128; 0 1 -128; 0 0 1];
h = inv(hom);

[xi, yi] = meshgrid(1:size(destI,2),1:size(destI,1)); %not sure if this works
xx = (h(1,1)*xi+h(1,2)*yi+h(1,3))./(h(3,1)*xi+h(3,2)*yi+h(3,3));
yy = (h(2,1)*xi+h(2,2)*yi+h(2,3))./(h(3,1)*xi+h(3,2)*yi+h(3,3));

img1Trans = uint8(interp2(img1,xx,yy));
figure;
imshow(img1Trans)
title('Trans Image')

nImg = img1Trans;
