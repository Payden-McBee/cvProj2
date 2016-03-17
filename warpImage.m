function nImg = warpImage(img1, img2,H)

%%%%%%%%%%%%%%%%%%%%%%
% transform 4 corners of image with homography

img2Xmin = 1;
img2Ymin = 1;
img2Xmax = size(img2,2);
img2Ymax = size(img2,1);

topLcorner1 = [1 1 1]';
topRcorner1 = [size(img1,2) 1 1]';
botLcorner1 = [1 size(img1,1) 1]';
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
maxXval = round(max( [tLC_x, tRC_x, bLC_x, bRC_x, img2Xmax] ));

minYval = round(min( [tLC_y, tRC_y, bLC_y, bRC_y, img2Ymin] ));
maxYval = round(max( [tLC_y, tRC_y, bLC_y, bRC_y, img2Ymax] ));

final_x_size = maxXval - minXval + 1;
final_y_size = maxYval - minYval + 1;

trans = [1 0 -minXval+1;
         0 1 -minYval+1;
         0 0  1 ];
invTrans = inv(trans);

img1=double(img1);

h = inv(trans*H);

[xi, yi] = meshgrid(1:final_x_size,1:final_y_size);
xx = (h(1,1)*xi+h(1,2)*yi+h(1,3))./(h(3,1)*xi+h(3,2)*yi+h(3,3));
yy = (h(2,1)*xi+h(2,2)*yi+h(2,3))./(h(3,1)*xi+h(3,2)*yi+h(3,3));

img1Trans = uint8(interp2(img1,xx,yy));
figure;imshow(img1Trans);

[xii, yii] = meshgrid(1:final_x_size,1:final_y_size);
xx = (invTrans(1,1)*xii+invTrans(1,2)*yii+invTrans(1,3))./(invTrans(3,1)*xii+invTrans(3,2)*yii+invTrans(3,3));
yy = (invTrans(2,1)*xii+invTrans(2,2)*yii+invTrans(2,3))./(invTrans(3,1)*xii+invTrans(3,2)*yii+invTrans(3,3));

img2 = double(img2);
img2Trans = uint8(interp2(img2,xx,yy));
figure;imshow(img2Trans);

blended_img = double(img1Trans) + double(img2Trans);
overlap = img1Trans & img2Trans;

blended_img(overlap) = double(blended_img(overlap))/2;

blended_img = uint8(blended_img);

figure;imshow(blended_img);

nImg = blended_img;
