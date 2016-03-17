%% Project 2, Computer Vision
% Creators: Michael Brunetti and Payden McBee
% Created: 13 March 2016 
% 
%% Load images
filename='./images/';
imgs = loadImgs(filename); %function to store all images in the file
img1 = imgs(:,:,:,1); %choose the image in the folder 
img2 = imgs(:,:,:,2);

img1_gray = rgb2gray(img1);
img2_gray = rgb2gray(img2);


img1_double = im2double(img1_gray);
img2_double = im2double(img2_gray);

%% Apply Harris Corner Detector to images
% Defining the image region which contains the corners
disp('calculating harris corner response')
harris_win_size = 11;
harris_k = 0.06;
R_surf_1 = harris_corners ( img1_double, harris_win_size, harris_k );
R_surf_2 = harris_corners ( img2_double, harris_win_size, harris_k );
disp('done calculating harris corner response')

%% Non-Maximum Supression to find sparse set of corner features
%placeholders
disp('performing nonmaximal suprression')
nonmax_win_size = 11;
nonmax_thresh = 2000;
corners_1 = nonmaxSupression( R_surf_1, nonmax_win_size, nonmax_thresh );
corners_2 = nonmaxSupression( R_surf_2, nonmax_win_size, nonmax_thresh );
disp('done performing nonmax supression')

%TESTING - diagnostic plots
figure(3);imshow(img1);hold on;scatter(corners_1(:,2),corners_1(:,1));
figure(4);imshow(img2);hold on;scatter(corners_2(:,2),corners_2(:,1));

%% Compute NCC (normalized cross correlation), threshold
disp('computing NCC in regions of corners')
NCC_win_size = 11;
NCC_threshold = 0.5;
[matches_1, matches_2] = calc_NCC( img1_double, corners_1, img2_double, corners_2, NCC_win_size, NCC_threshold );
disp('done computing NCC')

%% Estimate the homography using chosen corners using RANSAC
dist_thresh = 10;
[inliers_1, inliers_2] = RANSAC( matches_1, matches_2, dist_thresh, img1_double, img2_double );

h = homogFromSVD( inliers_1, inliers_2 );

%% Warp one image onto the other
warpImage(rgb2gray(img1), rgb2gray(img2), h);