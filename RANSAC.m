function [ inliers_1, inliers_2 ] = RANSAC( corners_1, corners_2, matches, dist_thresh )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

num_points = size(corners_1,1);
unique_matches = unique(matches);
num_matches = max(size(unique_matches)) - 1;

A = zeros(8,9);

prev_inliers = 0;

for iter=1:50
    
    points_1 = zeros(4,2);
    points_2 = zeros(4,2);
    
    rand_pts_idx = zeros(4,1);
    homog_matches = zeros(4,1);
    
    for i=1:4
        rand_pts_idx(i) = floor(rand*num_points) + 1;
        homog_matches(i) = matches(rand_pts_idx(i));
        while ( homog_matches(i) < 0 ) 
%             || ...
%             (max(size(unique(homog_matches)))<=i && i<4) || ...
%         	(max(size(unique(homog_matches)))<=i && i==4) )
            rand_pts_idx(i) = floor(rand*num_points) + 1;
            homog_matches(i) = matches(rand_pts_idx(i));
        end
        
        points_1(i,1) = corners_1(rand_pts_idx(i),2);
        points_1(i,2) = corners_1(rand_pts_idx(i),1);
        points_2(i,1) = corners_2(homog_matches(i),2);
        points_2(i,2) = corners_2(homog_matches(i),1);
        
        A(2*i - 1,:) = [-points_1(i,1), -points_1(i,2), -1, 0, 0, 0, ...
            points_1(i,1)*points_2(i,1), points_1(i,2)*points_2(i,1), ...
            points_2(i,1)];
        A(2*i,:) = [0, 0, 0, -points_1(i,1), -points_1(i,2), -1, ...
            points_1(i,1)*points_2(i,2), points_1(i,2)*points_2(i,2), ...
            points_2(i,2)];
    end
   
    [~, ~, V] = svd(A);
    homography = V(:,size(V,2));
    
    h = zeros(3,3);
    h(1,:)=homography(1:3);
    h(2,:)=homography(4:6);
    h(3,:)=homography(7:9);
    
    points_1_proj = ones(3, num_points);
    points_1_proj(1,:)=corners_1(:,2);%x,y,1
    points_1_proj(2,:)=corners_1(:,1);%...
    points_1_prime_proj = zeros(3,num_points);
    
    inliers = 0;
    inliers_1_buff = zeros(num_matches,2);
    inliers_2_buff = zeros(num_matches,2);
    
    for i=1:num_points
        
        if ( matches(i)<0 )
            continue
        end
        
        points_1_prime_proj(:,i) = h*points_1_proj(:,i);
        points_1_prime = points_1_prime_proj(1:2,i) / points_1_prime_proj(3,i);
        
        matched_point(1) = corners_2(matches(i),2);
        matched_point(2) = corners_2(matches(i),1);

        dist = norm(points_1_prime.' - matched_point);
        
        %figure(4);hold on;scatter(matched_point(1),matched_point(2),'r');
        %figure(4);hold on;scatter(points_1_prime(1),points_1_prime(2),'k');
        
        if ( dist < dist_thresh )
            inliers = inliers+1;
            inliers_1_buff(inliers,1)= corners_1(i,2);
            inliers_1_buff(inliers,2) = corners_1(i,1);
            inliers_2_buff(inliers,1)= corners_2(matches(i),2);
            inliers_2_buff(inliers,2)= corners_2(matches(i),1);
        end
    end
    
    if ( inliers > prev_inliers )
        inliers_1 = inliers_1_buff(1:inliers,:);
        inliers_2 = inliers_2_buff(1:inliers,:);
    end
    
    prev_inliers = inliers;

end

end