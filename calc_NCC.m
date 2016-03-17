function [ matches_1, matches_2 ] = calc_NCC( img1, corners_1, img2, corners_2, window_size, NCC_thresh, plot_matches )
%% calc_NCC - calculates normalized cross-correlation between two regions
%   Given two images, img1 and img2, calculate NCC in regions of size
%   window_size centered at corners given by corners_1 and corners_2,
%   respectively
%
%   Returns two arrays that contain matching corners

if (nargin<7)
    plot_matches=0;
end

n_corr_1 = size(corners_1,1);
n_corr_2 = size(corners_2,1);
win_idx = (window_size - 1) / 2;
NCC_match = zeros(n_corr_1, 1);

for i=1:n_corr_1
    
    max_NCC = -1;
    max_idx = -1;
    
    i_1 = corners_1(i,1);
    j_1 = corners_1(i,2);
    
    if ( i_1-win_idx>0 && i_1+win_idx<size(img1,1) && ...
                j_1-win_idx>0 && j_1+win_idx<size(img1,2) )

        for j=1:n_corr_2

            i_2 = corners_2(j,1);
            j_2 = corners_2(j,2);

            if ( i_2-win_idx>0 && i_2+win_idx<size(img2,1) && ...
                    j_2-win_idx>0 && j_2+win_idx<size(img2,2) )

                roi_1 = img1(i_1-win_idx:i_1+win_idx,j_1-win_idx:j_1+win_idx,:);
                roi_2 = img2(i_2-win_idx:i_2+win_idx,j_2-win_idx:j_2+win_idx,:);
                

                if ( mode(roi_2) == size(roi_2,1)*size(roi_2,2) )
                    continue;
                end
                
                corCoeff = normxcorr2(roi_2,roi_1);
                NCC=corCoeff(5,5);

                if ( NCC > max_NCC && NCC > NCC_thresh )
                    max_NCC = NCC;
                    max_idx = j;
                end
            
            end
        end
    end
    NCC_match(i)=max_idx;
end

j=1;

for i=1:size(NCC_match,1)
   
    if ( NCC_match(i)>0 )
        matches_1(j,1) = corners_1(i,2);
        matches_1(j,2) = corners_1(i,1);
        matches_2(j,1) = corners_2(NCC_match(i),2);
        matches_2(j,2) = corners_2(NCC_match(i),1);
        j=j+1;
    end
    
end

if (plot_matches);figure;showMatchedFeatures(img1,img2,matches_1,matches_2,'montage');end;

end

