function [ newImage ] = warp(img1,img2,homography)
% transform 4 corners of image with homography
H=homography; 

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

minYval = min( min( tLcTrans(1,2),bLcTrans(1,1) ) ,img2Ymin );
maxYval = max( max( tRcTrans(1,2),bRcTrans(1,2) ) ,img2Ymax );

if minXval < 1
    leftMargin = abs(minXval)
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
    topMargin = abs(minYval)
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

% map img2 onto destImg
for i = 1:img2Xmax
    for j=1:img2Ymax
        destI(i+leftMargin,j+topMargin)=img2(i)
    end
end
% map img1T onto destImg using averaging blending technique