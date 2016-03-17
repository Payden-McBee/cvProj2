function imgs = loadImgs(images_path)
filename1=images_path;
addpath(filename1);

allPics = strcat(filename1,'*.jpg');
srcFiles = dir(allPics);  

filenm = strcat(filename1,srcFiles(1).name);
file=imread(filenm);

imgs = uint8(zeros(size(file,1),size(file,2),size(file,3),length(srcFiles)));

for i = 1 : length(srcFiles)
    filename3 = strcat(filename1,srcFiles(i).name);
    [tempI,map] = imread(filename3);
    imgs(:,:,:,i)=tempI;
end