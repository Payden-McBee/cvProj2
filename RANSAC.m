function [ inliers_1, inliers_2 ] = RANSAC( corners_1, corners_2, matches )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

num_points = size(corners_1,1);
num_matches = max(size(matches));

A = zeros(8,9);

while (1==1)
    
    points_1 = zeros(4,2);
    points_2 = zeros(4,2);
    
    for i=1:4
        point_idx = floor(rand*num_points) + 1;
        points_1(i,:) = corners_1(point_idx,:);
        points_2(i,:) = corners_2(matches(point_idx),:);
        
        A(2*(i-1) + 1,:) = [points_1(i,1), points_2(i,2) 1 0 0 0 ...
            -points_1(i,1)*points_2(i,1) -points_1(i,2)*points_2(i,1) ...
            -points_2(i,1)];
        A(2*(i-1) + 2,:) = [0 0 0 points_1(i,1) points_1(i,2) 1 ...
            -points_1(i,1)*points_2(i,2) -points_1(i,2)*points_2(i,2) ...
            -points_2(i,2)];
    end
   
    [U, ~, ~] = svd(A.'*A);
    homography = U(:,size(U,2));
    
    h(1,:)=homography(1:3);
    h(2,:)=homography(4:6);
    h(3,:)=homography(7:9);
    
    for i=1:num_matches
    


end


end

