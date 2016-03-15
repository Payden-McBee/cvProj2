function [ nms_R_surface ] = nonmaxSupression( r_surface, window_size )
thresh = 1000; 
nms_R_surface = r_surface; 
%compare to threshold
for i = 1:size(r_surface,1)
    for j = 1:size(r_surface,2)
        if r_surface(i,j) < thresh
            nms_R_surface = 0;
        end
    end
end

for i = 1:(size(r_surface,1)-window_size+1)
    for j = 1:(size(r_surface,2)-window_size+1)
        window = r_surface(i:(i+window_size-1),j:(j+window_size-1));
        localMax = max(max(window));
        if localMax ==0
            localMax = 1;
        end 
        for k = 1:size(window,1)
            for l = 1:size(window,2)
                if window(k,l)<localMax
                    nms_R_surface(i+k-1,j+l-1)=0;
                end
            end
        end
    end
end
count=0;
for i = 1:(size(r_surface,1))
    for j = 1:(size(r_surface,2))
        if nms_R_surface(i,j)==0
            %do nothing
        else
            count=count+1;
        end
    end
end
count