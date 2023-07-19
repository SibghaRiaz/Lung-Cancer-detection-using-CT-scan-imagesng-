function varargout = cancer(varargin)
% Making GUI 
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cancer_OpeningFcn, ...
                   'gui_OutputFcn',  @cancer_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% -------- Executes just before cancer is made visible----------
function cancer_OpeningFcn(hObject, eventdata, handles, varargin)
% hObject    handle to figure
% Choose default command line output for cancer
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% --- Outputs from this function are returned to the command line.
function varargout = cancer_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1------------
function pushbutton1_Callback(hObject, eventdata, handles)

global I
clc
[filename, pathname] = uigetfile('*.jpg', 'Pick an Image');
     if isequal(filename,0) | isequal(pathname,0)
      
   warndlg('File is not selected');
           else
              I=imread(filename);
      axes(handles.axes1)
      imshow(I);
      title 'Input Image'     
    end
title 'Input Lung Image'

% ------------- Executes on button press in pushbutton2-------------------
function pushbutton2_Callback(hObject, eventdata, handles)

global I
t=rgb2gray(I);
he=histeq(t);

axes(handles.axes2);
imshow(he);
title 'Histogram Equalization'
% ------- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)

global I
%% Histogram Equalization
t=rgb2gray(I);
he=histeq(t);
%% Segmentation by watershed
I1=imtophat(I,strel('disk',50));%TBD%
I2 = imadjust(I1);
level=graythresh(I2);
BW = im2bw(I2,level);
C=~BW;
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
axes(handles.axes3);
imshow(im); 
title 'Segmentation by Watershed'

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)

global I
%% Histogram Equalization
t=rgb2gray(I);
he=histeq(t);
%% Segmentation by thresholding
I1=imtophat(I,strel('disk',50));%TBD%
I2 = imadjust(I1);
level=graythresh(I2);
BW = im2bw(I2,level);
C=~BW;
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
%% Gabor Filter
wavelength = 4;
orientation = 90;
[mag,phase] = imgaborfilt(I,wavelength,orientation);
axes(handles.axes4);
imshow(mag,[]),

title('Filtered Image')

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)

global I
%% Histogram Equalization
t=rgb2gray(I);
he=histeq(t);
%% Segmentation by thresholding
I1=imtophat(I,strel('disk',50));%TBD%
I2 = imadjust(I1);
level=graythresh(I2);
BW = im2bw(I2,level);
C=~BW;
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
%% Filter
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(bw), hy, 'replicate');
se = strel('line',11,90);
bw2 = imdilate(Iy,se);
axes(handles.axes5);
imshow(bw2), 
title('Dilated')

% --- Executes on button press in pushbutton6--------------
function pushbutton6_Callback(hObject, eventdata, handles)

global I
%% Histogram Equalization
t=rgb2gray(I);
he=histeq(t);
%% Segmentation by thresholding
I1=imtophat(I,strel('disk',50));%TBD%
I2 = imadjust(I1);
level=graythresh(I2);
BW = im2bw(I2,level);
C=~BW;
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

%% Filter
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(bw), hy, 'replicate');
se = strel('line',11,90);
bw2 = imdilate(Iy,se);

BW5 = imfill(bw2,'holes');
  axes(handles.axes6);
  imshow(BW5)
 
 title 'Image Filling'
% --- Executes on button press in pushbutton7------------
function pushbutton7_Callback(hObject, eventdata, handles)

global I
%% Histogram Equalization
t=rgb2gray(I);
he=histeq(t);
%% Segmentation by thresholding
I1=imtophat(I,strel('disk',50));%TBD%
I2 = imadjust(I1);
level=graythresh(I2);
BW = im2bw(I2,level);
C=~BW;
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
%% Filter
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(bw), hy, 'replicate');
se = strel('line',11,90);
bw2 = imdilate(Iy,se);
BW5 = imfill(bw2,'holes');
%% Features Extraction
 %% Contrast
  disp ('Contrast Value');
  cmap = contrast(BW5)

 %% Entropy
 disp ('Entropy Value');
 E = entropy(BW5)
 set(handles.edit2,'string',num2str(E));

 %% GLCM Values
 glcm = graycomatrix(BW5,'Offset',[2 0])

% --- Executes on button press in pushbutton8--------------
function pushbutton8_Callback(hObject, eventdata, handles)

global I
%% Histogram Equalization
t=rgb2gray(I);
he=histeq(t);
%% Segmentation by thresholding
I1=imtophat(I,strel('disk',50));%TBD%
I2 = imadjust(I1);
level=graythresh(I2);
BW = im2bw(I2,level);
C=~BW;
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
%% Filter
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(bw), hy, 'replicate');
se = strel('line',11,90);
bw2 = imdilate(Iy,se);
BW5 = imfill(bw2,'holes');
C=BW5;
%% mean
c1=mean(C);
%% variance
c2=var(double(C));
%% contrast
d=C;

%% energy, homogeneity, contrast
GLCM2 = graycomatrix(d,'Offset',[2 0;0 2]);
c4 = graycoprops(GLCM2,{'contrast','homogeneity','Energy'});
set(handles.edit4,'string',num2str(min(c4.Energy)));
c24= graycoprops(GLCM2,'contrast');
set(handles.edit3,'string',num2str(min(c24.Contrast)));
%% correlation
c5=corr(double(d));
c6=c5(1,:);
c7=c1;
c8=c2;
c9=[c6 c7 c8];
%% network
net = network
net.numInputs = 6
net.numLayers = 1
P = size(double(c1));  
Cidx = strcmp('Cancer',c9); 
T = size(double(c2));         
net = newff(P,T,25);   
[net,tr] = train(net,P,T);
testInputs = P(:,tr.testInd);
testTargets = T(:,tr.testInd);
out = round(sim(net,testInputs));     
diff = [testTargets - 2*out];
detections = length(find(diff==-1))
false_positives = length(find(diff==1))
true_positives = length(find(diff==0))     
false_alarms = length(find(diff==-2))      
Nt = size(testInputs,2);           
fprintf('Total testing samples: %d\n', Nt);
cm = [detections false_positives; false_alarms true_positives] 
cm_p = (cm ./ Nt) .* 100           ;
%%
sim_out = round(sim(net,testInputs)); 
if ((max(c24.Contrast))>2)
    set(handles.edit1,'string','Lung Cancer Affected Image');
else
    set(handles.edit1,'string','Normal Image');
end



function edit1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties--------
function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit6_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit7_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
