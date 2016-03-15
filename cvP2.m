%% Project 2, Computer Vision
% Creators: Michael Brunetti and Payden McBee
% Created: 13 March 2016 
% 
%% Load images
filename='C:\Users\Payden McBee\Documents\NEU\NEUclasses\CompVision\proj2\DanaOffice\';
imgs = loadImgs(filename); %function to store all images in the file
img1 = imgs(:,:,1); %choose the image in the folder 
img2 = imgs(:,:,2);

%% Apply Harris Corner Detector to images
% Defining the image region which contains the corners
harris_win_size = 5;
R_surf_1 = harris_corners ( img1, harris_win_size );
R_surf_2 = harris_corners ( img2, harris_win_size );

%% Non-Maximum Supression to find sparse set of corner features
%placeholders
corners_1 = non_max( R_surf_1 );
corners_2 = non_max( R_surf_2 );


%% Compute NCC (normalized cross correlation), threshold
NCC_win_size = 5;
NCC_mat = calc_NCC( img1, corners_1, img2, corners_2, NCC_win_size );

%% Estimate the homography using chosen corners using RANSAC




%% Warp one image onto the other 