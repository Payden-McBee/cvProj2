function homog = homogFromSVD(inliers1,inliers2)
numPts = size(inliers,1);
A = zeros(2*numPts,9);
for i=1:2*numPts
    if mod(i,2) == 0
        %number is even
        A(i,1)=0;
        A(i,2)=0;
        A(i,3)=0;
        A(i,4)=inliers1(i,1);
        A(i,5)=inliers1(i,2);
        A(i,6)=1;
        A(i,7)=(-1)*inliers1(i,1)*inliers2(i,2);
        A(i,8)=(-1)*inliers1(i,2)*inliers2(i,2);
        A(i,9)=(-1)*inliers2(i,2);
    else
        %number is odd
        A(i,1)=inliers1(i,1);
        A(i,2)=inliers1(i,2);
        A(i,3)=1;
        A(i,4)=0;
        A(i,5)=0;
        A(i,6)=0;
        A(i,7)=(-1)*inliers1(i,1)*inliers2(i,1);
        A(i,8)=(-1)*inliers1(i,2)*inliers2(i,1);
        A(i,9)=(-1)*inliers2(i,1);
    end
end

[U,S,V] = svd(A);
lastCol = size(V,2);
H = V(:,lastCol);
homog = [H(1) H(2) H(3);
         H(4) H(5) H(6);
         H(7) H(8) H(9)];
    
    
    