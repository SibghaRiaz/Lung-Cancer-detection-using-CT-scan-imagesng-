clc
clear
im = dicomread('G:\dataset\LIDC-IDRI\LIDC-IDRI-0025\01-01-2000-94910\3000524.000000-53557\1-010.dcm');  %im will usually be of type uint16, already in grayscale
 % imshow(im, []);
 im2 = im2double(im);
 % im3 elements will be between 0 and 255 (uint8) or 0 and 1 (double)
 im3 = imadjust(im2, stretchlim(im2, 0), []);
 imwrite(im3, 'G:\1-010.jpg');