Img = im2double(imread('Cancerous246.jpg'));
%--------------------------------------median filter----------------------
medf=@(x)median(x(:));
med_Im=nlfilter(Img,[3,3],medf); %TBD%
%imshow(med_Im)
%---------------------------------------Gaussian filter------------------------------------------------------%
GF= imnoise(med_Im,'Gaussian',0.01,0.01); %TBD%
%figure,imshow(GF);
I = double(GF);
sigma= 0.3; %standard deviation%
sz=3; %box size%
[x,y]=meshgrid(-sz:sz,-sz:sz);
M= size(x,1)-1;
N= size(y,1)-1;
Exp_comp= -(x.^2+y.^2)/(2*sigma*sigma);
Kernel=exp(Exp_comp)/(2*pi*sigma*sigma);

Output=zeros(size(I));
I=padarray(I,[sz sz]);

%convolution%
for i=1:size(I,1)-M
    for j=1:size(I,2)-N
        Temp= I(i:i+M,j:j+M).*Kernel;
        Output(i,j)=sum(Temp(:));
    end
end
Output= uint8(Output);
% figure,imshow(Output);

%---------------------------------------BINARIZED Image------------------------------------------------------%
binary=im2bw(Output,0.8);
figure,imshow(binary);

%---------------------------------------Watershed segmentation------------------------------------------------------%

% I= rgb2gray(Img);
I1=imtophat(Img,strel('disk',50));%TBD%
%morphological transformation to subtract background from an image is
%called top hat.top hat is subtraction of an opened image from the orignal
%image.one can do opening images in gray images remove all features smaller
%than structuing element.
figure,imshow(I1);
I2 = imadjust(I1);
level=graythresh(I2);
BW = im2bw(I2,level);
%figure,imshow(BW);
C=~BW;
%figure,imshow(C);
D= -bwdist(C);
%bwdist computes distance transform.distance transform of a binary image is
%the distance from every pixel to nearest non-zero pixel
D(C)= -Inf;
%modify image so that the background image and the extended maxima pixels
%are forced to be the only local minima in the image.
L= watershed(D);
Wi=label2rgb(L,'hot','w');
% figure,imshow(Wi);
im=binary;
im(L==0)=0; 
figure,imshow(im); 
%----------------------------------Tumor detection-------------------------%
%bw=im2bw(binary,0.5);
binary=im;
label=bwlabel(binary);
stats=regionprops(label,'Solidity','Area');
density=[stats.Solidity];
area=[stats.Area];
high_dense_area=density>0.90;
max_area=max(area(high_dense_area));
tumor_label=find(area==max_area);
tumor=ismember(label,tumor_label);
se=strel('square',5);
tumor=imdilate(tumor,se);
figure(2);
subplot(1,3,1);
imshow(Output,[]);
title('Lung');

subplot(1,3,2);
% imshow(tumor,[]);
title('Tumor Alone');
[B,L]=bwboundaries(tumor,'noholes');
subplot(1,3,3);
% imshow(Img,[]);
hold on
for i=1:length(B)
    plot(B{i}(:,2),B{i}(:,1), 'y' ,'linewidth',1.30);
    
        
end

title('Detected Tumor');
hold off;

