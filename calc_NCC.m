function [ NCC_matrix ] = calc_NCC( img1, corners_1, img2, corners_2, window_size )
%calc_NCC - calculates normalized cross-correlation between two images in
%regions of corners
%   Given two images, img1 and img2, calculate NCC in regions of size
%   window_size centered at corners given by corners_1 and corners_2,
%   respectively
%
%   Returns a matrix of size ( |corners_1|, |corners_2| ) where the each
%   element, (i,j) is the NCC of the regions centered at corner i in img1
%   and corner j in img2

n_corr_1 = size(corners_1,1);
n_corr_2 = size(corners_2,1);

win_idx = (window_size - 1) / 2;

NCC_matrix = zeros(n_corr_1,n_corr_2);

for i=1:n_corr_1
    for j=1:n_corr_2
        
        i_1 = corners_1(i,1);
        j_1 = corners_1(i,2);
        i_2 = corners_2(i,1);
        j_2 = corners_2(i,2);
        roi_1 = img1(i_1-win_idx:i_1+win_idx,j_1-win_idx:j_1+win_idx);
        roi_2 = img2(i_2-win_idx:i_2+win_idx,j_2-win_idx:j_2+win_idx);
        
        norm_1 = sqrt( sum(sum( roi_1.^2  )) );
        norm_2 = sqrt( sum(sum( roi_2.^2  )) );
        
        NCC_matrix(i,j)= sum(sum( (roi_1/norm_1).*(roi_2/norm_2) ));
        
    end
end

end

