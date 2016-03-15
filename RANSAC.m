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
    
    h = zeros(3,3);
    h(1,:)=homography(1:3);
    h(2,:)=homography(4:6);
    h(3,:)=homography(7:9);
    
    points_1_proj = ones(num_matches, 3);
    points_1_proj(:,1:2)=points_1;
    points_1_prime_proj = zeros(num_matches,3);
    
    inliers = 0;
    inliers_1_buff = zeros(num_matches,2);
    inliers_2_buff = zeros(num_matches,2);
    
    for i=1:num_matches
        points_1_prime_proj(i,:) = h*points_1_proj(i,:);
        points_1_prime = points_1_prime_proj(i,1:2);

        dist = norm(points_1_prime - points_2(i,:));
        
        if ( dist < dist_thresh )
            inliers = inliers+1;
            inliers_1_buff(inliers,:)= points_1(i,:);
            inliers_2_buff(inliers,:)= points_2(i,:);
        end
    end
    
    pct_inliers = inliers / num_matches;
    inliers_1 = inliers_1_buff(1:inliers,:);
    inliers_2 = inliers_2_buff(1:inliers,:);
    
    if ( pct_inliers > inliers_thresh )
        break;
    end

end


end