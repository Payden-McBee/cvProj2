function [ ] = motion_detect_main(images_path, thresh, motion_filter_name, tsigma, spatial_filter)
%% Main function for running motion detection
%
%
%%

if (nargin<4)%make sure if DOG filter is used there is a value for tsigma
    if (strcmp(motion_filter_name,'1D_DOG'))
        disp('value for tsigma required for 1D deriviative of gaussian');
        return
    end
end %PM, wasn't sure why elseif was below, never set spatial_filter to 0 for simple case
if (nargin<5)%no spatial smoothing if <5 args are passed
    spatial_filter=0;
end


switch motion_filter_name
    case 'simple'                       %simple 1D motion filter
        motion_filter=0.5.*[-1 0 1];
    case '1D_DOG'                       %1D Derivative of Gaussian
        
        %set filter size based on tsigma, round to nearest odd integer
        filter_size=tsigma*2*pi;
        filter_size=2*round(filter_size/2+1)-1;
        
        %create Gaussian kernel
        filt=-(filter_size-1)/2:(filter_size-1)/2;
        gaussian_kernel=sqrt(1/(2*pi*tsigma)).*exp(-filt.^2 ./ (2*tsigma));
        
        %calcualte Derivative of Gaussian and set as motion_filter
        deriv_of_gauss=zeros(1,filter_size-2);
        for i=2:(size(gaussian_kernel,2)-1)
            deriv_of_gauss(i-1)=(0.5.*[-1 0 1]).*gaussian_kernel(i-1:i+1);
        end
        
        %normalize DOG filter?
        
        motion_filter=deriv_of_gauss;
    otherwise                           %if filter name not recognized
        disp('Unrecognized motion filter name. The choices are:')
        fprintf('\tsimple - a 3x1 simple 1D filter\n')
        fprintf('\t1D_DOG - a 1D derivative of gaussian filter with user-defined tsigma\n')
        return
end

images=loadImages(images_path);%PM insert param
motion_detect(images, motion_filter, thresh, spatial_filter);
