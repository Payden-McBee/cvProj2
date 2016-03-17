function [ inliers_1, inliers_2 ] = RANSAC( matches_1, matches_2, dist_thresh, img1, img2, plot_inliers )
%% RANSAC - eliminate outliers to compute homography
%   This function eliminates outliers in matching features between two
%   images

if (nargin<6)
    plot_inliers = 0;
end

num_points = size(matches_1,1);

A = zeros(8,9);

max_inliers = 0;

for iter=1:500
    
    for i=1:4
        
        rand_pt = floor(rand*num_points)+1;
        
        points_1(i,1) = matches_1(rand_pt,1);
        points_1(i,2) = matches_1(rand_pt,2);
        points_2(i,1) = matches_2(rand_pt,1);
        points_2(i,2) = matches_2(rand_pt,2);
        
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
    points_1_proj(1,:)=matches_1(:,1);
    points_1_proj(2,:)=matches_1(:,2);
    points_1_prime_proj = zeros(3,1);
    
    inliers = 0;
    inliers_1_buff = zeros(num_points,2);
    inliers_2_buff = zeros(num_points,2);
    
    for i=1:num_points
        
        points_1_prime_proj(:) = h*points_1_proj(:,i);
        points_1_prime = points_1_prime_proj(1:2) / points_1_prime_proj(3);

        dist = norm(points_1_prime - matches_2(i,:).');
        
        if ( dist < dist_thresh )
            inliers = inliers+1;
            inliers_1_buff(inliers,:) = matches_1(i,:);
            inliers_2_buff(inliers,:) = matches_2(i,:);
        end
    end
    
    if ( inliers > max_inliers )
        inliers_1 = inliers_1_buff(1:inliers,:);
        inliers_2 = inliers_2_buff(1:inliers,:);
        max_inliers = inliers;
    end

end

if(plot_inliers);figure(9);showMatchedFeatures(img1,img2,inliers_1,inliers_2,'montage');end;

end