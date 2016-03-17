function [ NCC_match ] = calc_NCC( img1, corners_1, img2, corners_2, window_size )
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

NCC = zeros(n_corr_2,1);
NCC_match = zeros(n_corr_1, 1);

for i=1:n_corr_1
    
    max_NCC = -1;
    max_idx = -1;
    
    i_1 = corners_1(i,1);
    j_1 = corners_1(i,2);
    
%     figure(3);hold on;imshow(img1);scatter(j_1,i_1,'r','LineWidth',3);
%     figure(4);hold on;imshow(img2);
    
    if ( i_1-win_idx>0 && i_1+win_idx<size(img1,1) && ...
                j_1-win_idx>0 && j_1+win_idx<size(img1,2) )

        for j=1:n_corr_2

            i_2 = corners_2(j,1);
            j_2 = corners_2(j,2);

%             figure(4);scatter(j_2,i_2,'r','LineWidth',3);

            if ( i_2-win_idx>0 && i_2+win_idx<size(img2,1) && ...
                    j_2-win_idx>0 && j_2+win_idx<size(img2,2) )

                roi_1 = img1(i_1-win_idx:i_1+win_idx,j_1-win_idx:j_1+win_idx);
                roi_2 = img2(i_2-win_idx:i_2+win_idx,j_2-win_idx:j_2+win_idx);
                

                corCoeff = normxcorr2(roi_1,roi_2);

                NCC(j)=corCoeff(5,5);

%                 norm_1 = sqrt( sum(sum( roi_1.^2  )) );
%                 norm_2 = sqrt( sum(sum( roi_2.^2  )) );
%     
%                 NCC(j)= sum(sum( (roi_1/norm_1).*(roi_2/norm_2) ));

                if ( NCC(j) > max_NCC && NCC(j) > 0.85 )
                    max_NCC = NCC(j);
                    max_idx = j;
                    
%                     figure(5);imagesc(roi_1);
%                     figure(6);imagesc(roi_2);
                end
            
            end
        
        end
        
    end
    
    NCC_match(i)=max_idx;
    
    %TESTING - diagnostic plots
%     if(max_idx>0)
% %         figure(3);hold off;imshow(img1);
% %         figure(4);hold off;imshow(img2);
%         figure(3);hold on;scatter(j_1,i_1,'b','LineWidth',3);
%         figure(4);hold on;scatter(corners_2(max_idx,2),corners_2(max_idx,1),'b','LineWidth',3);
%     end

end

end

