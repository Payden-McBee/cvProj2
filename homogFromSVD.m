function homog = homogFromSVD(inliers1,inliers2)
numPts = size(inliers1,1);
A = zeros(2*numPts,9);
for i=1:numPts
    %number is odd
    A(2*i-1,1)=-inliers1(i,1);
    A(2*i-1,2)=-inliers1(i,2);
    A(2*i-1,3)=-1;
    A(2*i-1,4)=0;
    A(2*i-1,5)=0;
    A(2*i-1,6)=0;
    A(2*i-1,7)=inliers1(i,1)*inliers2(i,1);
    A(2*i-1,8)=inliers1(i,2)*inliers2(i,1);
    A(2*i-1,9)=inliers2(i,1);
    
    %number is even
    A(2*i,1)=0;
    A(2*i,2)=0;
    A(2*i,3)=0;
    A(2*i,4)=-inliers1(i,1);
    A(2*i,5)=-inliers1(i,2);
    A(2*i,6)=-1;
    A(2*i,7)=inliers1(i,1)*inliers2(i,2);
    A(2*i,8)=inliers1(i,2)*inliers2(i,2);
    A(2*i,9)=inliers2(i,2);
end

[U,~,V] = svd(A);
lastCol = size(V,2);
H = V(:,lastCol);
homog = [H(1) H(2) H(3);
         H(4) H(5) H(6);
         H(7) H(8) H(9)];