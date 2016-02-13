function imgs = loadImages();%images_path);
filename1='C:\Users\Payden McBee\Documents\NEU\NEUclasses\CompVision\Office\Office\';
%filename1='C:\Users\Payden McBee\Documents\NEU\NEUclasses\CompVision\RedChair\RedChair\';
%filename1=images_path;
%filename1='C:\Users\pqm3883\Documents\Office\Office\';
addpath(filename1);

allPics = strcat(filename1,'*.jpg');
srcFiles = dir(allPics);     %  'C:\Users\Payden McBee\Documents\NEU\NEUclasses\CompVision\Office\Office\*.jpg'); 

filenm = strcat(filename1,srcFiles(1).name);
file=imread(filenm);

imgs = uint8(zeros(length(srcFiles),size(file,1),size(file,2)));

for i = 1 : length(srcFiles)
    filename3 = strcat(filename1,srcFiles(i).name);
    [tempI,map] = imread(filename3);
    temp2=rgb2gray(tempI);
    imgs(i,:,:)=temp2;
end
