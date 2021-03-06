function [ R_surface ] = harris_corners( img, window_size, k, show_R_surf )
%% harris corner detector
%   accepts a grayscale image, img, an (odd) integer window size,
%   window_size, and a weighting value k (default k=0.008)
%
%   finds corners using harris corner detection

if (nargin<3)
    k=0.05;
    show_R_surf = 0;
elseif (nargin<4)
    show_R_surf = 0;
end

I=size(img,1);
J=size(img,2);
border=(window_size-1)/2;

%compute y component of image gradient
y_filter = [-2 -1 0 1 2];
img_y = zeros(I-2,J-2);
for i=3:I-2
    for j=3:J-2
        img_y(i-2,j-2)=sum(y_filter.*squeeze(img(i-2:i+2,j)).');
    end
end

%compute x component of image gradient
x_filter = [-2 -1 0 1 2];
img_x = zeros(I-2,J-2);
for i=3:I-2
    for j=3:J-2
        img_x(i-2,j-2)=sum(x_filter.*squeeze(img(i,j-2:j+2)));
    end
end

R_surface = zeros(I-border,J-border);
M = zeros(2);

for i=border+1:I-border-2
    for j=border+1:J-border-2
        x_grads=img_x(i-border:i+border,j-border:j+border);
        y_grads=img_y(i-border:i+border,j-border:j+border);
        
        M(1,1)=sum(sum( x_grads.*x_grads ));
        M(1,2)=sum(sum( x_grads.*y_grads ));
        M(2,1)=M(1,2);
        M(2,2)=sum(sum( y_grads.*y_grads ));
        
        R_surface(i-border+1,j-border+1)=det(M)-k*(trace(M))^2;
    end
end

if ( show_R_surf ); figure;imagesc(R_surface); end;

