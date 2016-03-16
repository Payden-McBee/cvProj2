function [ inliers_1, inliers_2 ] = RANSAC( corners_1, corners_2, matches, dist_thresh, inliers_thresh )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

num_points = size(corners_1,1);
num_matches = sum ( matches>0 );

A = zeros(8,9);

while (1==1)
    
    points_1 = zeros(4,2);
    points_2 = zeros(4,2);
    
    for i=1:4
        point_idx = floor(rand*num_points) + 1;
        while (matches(point_idx)<0)
            point_idx = floor(rand*num_points) + 1;
        end
        
        points_1(i,1) = corners_1(point_idx,2);
        points_1(i,2) = corners_1(point_idx,1);
        points_2(i,1) = corners_2(matches(point_idx),2);
        points_2(i,2) = corners_2(matches(point_idx),1);
        
        A(2*i - 1,:) = [points_1(i,1), points_1(i,2) 1 0 0 0 ...
            -points_1(i,1)*points_2(i,1) -points_1(i,2)*points_2(i,1) ...
            -points_2(i,1)];
        A(2*i,:) = [0 0 0 points_1(i,1) points_1(i,2) 1 ...
            -points_1(i,1)*points_2(i,2) -points_1(i,2)*points_2(i,2) ...
            -points_2(i,2)];
    end
   
    [~, ~, V] = svd(A);
%     V = V_trans';
    homography = V(:,size(V,2));
    
    h = zeros(3,3);
    h(1,:)=homography(1:3);
    h(2,:)=homography(4:6);
    h(3,:)=homography(7:9);
    
    points_1_proj = ones(num_points, 3);
    points_1_proj(:,1:2)=corners_1(:,:);
    points_1_prime_proj = zeros(3,num_points);
    
    inliers = 0;
    inliers_1_buff = zeros(num_matches,2);
    inliers_2_buff = zeros(num_matches,2);
    
    for i=1:num_points
        
        if ( matches(i)<0 )
            continue
        end
        
        points_1_prime_proj(:,i) = h*points_1_proj(i,:).';
        points_1_prime = points_1_prime_proj(1:2,i) / points_1_prime_proj(3,i);
        
        matched_point(1) = corners_2(matches(i),2);
        matched_point(2) = corners_2(matches(i),1);

        dist = norm(points_1_prime.' - matched_point);
        
        if ( dist < dist_thresh )
            inliers = inliers+1;
            inliers_1_buff(inliers,:)= corners_1(i,:);
            inliers_2_buff(inliers,:)= corners_2(matches(i),:);
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