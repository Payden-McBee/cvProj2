function [ corners ] = nonmaxSupression( r_surface, window_size )
thresh = 400; 
nms_R_surface = r_surface;
numAboveThresh=0;
%compare to threshold
for i = 1:size(r_surface,1)
    for j = 1:size(r_surface,2)
        if r_surface(i,j) < thresh
            nms_R_surface(i,j) = 0;
        else
            numAboveThresh= numAboveThresh+1;
        end
    end
end
numAboveThresh;
row=1;
for i = 1:(size(nms_R_surface,1)-window_size+1)
    for j = 1:(size(nms_R_surface,2)-window_size+1)
        maxNotFound = 1;
        window = nms_R_surface(i:(i+window_size-1),j:(j+window_size-1));
        localMax = max(max(window));
        if localMax < thresh
            %there are no values above thresh, no need to check for local max
        else 
            for k = 1:size(window,1)
                for l = 1:size(window,2)
                    if maxNotFound
                        if window(k,l)<localMax
                            nms_R_surface(i+k-1,j+l-1)=0; %not a local max
                            maxNotFound = 1;
                        else %save coords of local max
                            maxNotFound = 0;                                             
                        end
                    else %local max is found, set rest in window to zero
                        nms_R_surface(i+k-1,j+l-1)=0;
                    end
                    
                end
            end
        end
    end
end
row = 1;
for i = 1:size(nms_R_surface,1)
    for j = 1:size(nms_R_surface,2)
        if nms_R_surface(i,j) == 0 
            %not a corner
        else
            corners(row,:) = [i j];
            row=row+1;
        end
    end
end
