%% Project 2, Computer Vision
% Creators: Michael Brunetti and Payden McBee
% Created: 13 March 2016 
% 
%% Load images
filename='.\images\';
imgs = loadImgs(filename); %function to store all images in the file
img1 = imgs(:,:,1); %choose the image in the folder 
img2 = imgs(:,:,2);

img1_double = im2double(img1);
img2_double = im2double(img2);

%% Apply Harris Corner Detector to images
% Defining the image region which contains the corners
disp('calculating harris corner response')
harris_win_size = 5;
R_surf_1 = harris_corners ( img1_double, harris_win_size );
R_surf_2 = harris_corners ( img2_double, harris_win_size );
disp('done calculating harris corner response')

%% Non-Maximum Supression to find sparse set of corner features
%placeholders
disp('performing nonmaximal suprression')
nonmax_win_size = 5;
corners_1 = nonmaxSupression( R_surf_1, nonmax_win_size );
corners_2 = nonmaxSupression( R_surf_2, nonmax_win_size );
disp('done performing nonmax supression')

%% Compute NCC (normalized cross correlation), threshold
disp('computing NCC in regions of corners')
NCC_win_size = 5;
matches = calc_NCC( img1, corners_1, img2, corners_2, NCC_win_size );
disp('done computing NCC')

%% Estimate the homography using chosen corners using RANSAC
dist_thresh = 10;
inliers_thresh = 0.9;
[inliers_1, inliers_2] = RANSAC( corners_1, corners_2, matches, dist_thresh, inliers_thresh);

h = homogFromSVD( inliers_1, inliers_2 );

%% Warp one image onto the other 