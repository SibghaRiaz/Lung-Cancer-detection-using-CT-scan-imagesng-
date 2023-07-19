I = imread('cancer2.jpg');
%I = imread('cancer1.jpg');
%t=rgb2gray(I);
%he=histeq(I);


%t=rgb2gray(I);
he=histeq(I);
imshow(he)

%gray_x =rgb2gray(x);
bw_x = ~im2bw(I,0.8);
bw = bwareadopen(bw_x,1000);
[bwLabel,num]=bwlabel(bw,8);
s = regionprops(bwLabel,'Area', 'BoundingBox', 'Centroid');
disp(size(s));
disp(strcat('Area = ',num2str(s.Area)));
cent = cat(1,s.Centroid);
bbox = cat(1,s.BoundingBox);
imshow(x); hold on
plot(cent(:,1),cent(:,1),'g*')
rectangle('Position',bbox,'EdgeColor','b',...
    'LineWidth',3)
hold off;