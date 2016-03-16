function nImg = warpImage(img1, img2,H)

%%%%%%%%%%%%%%%%%%%%%%
% transform 4 corners of image with homography

img2Xmin = 1;
img2Ymin = 1;
img2Xmax = size(img2,1);
img2Ymax = size(img2,2);

topLcorner1 = [1 1 1]';
topRcorner1 = [1 size(img1,1) 1]';
botLcorner1 = [size(img1,2) 1 1]';
botRcorner1 = [size(img1,2) size(img1,1) 1]';

tLcTrans = (H*topLcorner1);
tRcTrans = (H*topRcorner1);
bLcTrans = (H*botLcorner1);
bRcTrans = (H*botRcorner1);

tLC_x = tLcTrans(1)/tLcTrans(3);
tLC_y = tLcTrans(2)/tLcTrans(3);
tRC_x = tRcTrans(1)/tRcTrans(3);
tRC_y = tRcTrans(2)/tRcTrans(3);
bLC_x = bLcTrans(1)/bLcTrans(3);
bLC_y = bLcTrans(2)/bLcTrans(3);
bRC_x = bRcTrans(1)/bRcTrans(3);
bRC_y = bRcTrans(2)/bRcTrans(3);

% determine destination image size from bounds of transformed img1 and img2
minXval = round(min( [tLC_x, tRC_x, bLC_x, bRC_x, img2Xmin] ));
maxXval = round(max( [tLC_x, tRC_x, bLC_x, bRC_x, img2Xmin] ));

minYval = round(min( [tLC_y, tRC_y, bLC_y, bRC_y, img2Ymin] ));
maxYval = round(max( [tLC_y, tRC_y, bLC_y, bRC_y, img2Ymin] ));

final_x_size = maxXval - minXval;
final_y_size = maxYval - minYval;

% if minXval < 1
%     leftMargin = abs(minXval);
%     rightMargin =0; %only 1 side can be out of bounds bc same size image
% else
%     leftMargin = 0; 
%     if maxXval > img2Xmax
%         rightMargin = maxXval - img2Xmax;
%     else
%         rightMargin = 0;
%     end
% end
% 
% if minYval < 1
%     topMargin = abs(minYval);
%     botMargin =0; %only 1 side can be out of bounds bc same size image
% else
%     topMargin = 0; 
%     if maxYval > img2Ymax
%         botMargin = maxYval - img2Ymax;
%     else
%         botMargin = 0;
%     end
% end
% 
% numRows = size(img2,1) + leftMargin + rightMargin;
% numCols = size(img2,2) + topMargin + botMargin;

destI = zeros(final_x_size, final_y_size);
%%%%%%%%%%%%%%%%%%%%%%

figure;
imshow(img1)
title('Office')
img1=double(img1);

hom=H;
h = inv(hom);

[xi, yi] = meshgrid(1:size(destI,2),1:size(destI,1)); %not sure if this works
xx = (h(1,1)*xi+h(1,2)*yi+h(1,3))./(h(3,1)*xi+h(3,2)*yi+h(3,3));
yy = (h(2,1)*xi+h(2,2)*yi+h(2,3))./(h(3,1)*xi+h(3,2)*yi+h(3,3));

img1Trans = uint8(interp2(img1,xx,yy));
figure;
imshow(img1Trans)
title('Trans Image')

nImg = img1Trans;
