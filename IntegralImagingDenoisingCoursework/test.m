close all;  
clear all;  
clc 

img = imread('images/alleyNoisy_sigma22.png');
img = rgb2gray(img);
I=double(img);  

tic
Out1 = nonLocalMeans(I,3,10,2,5);
toc

tic
Out2 = NLMnaive(I,3,10,2,5);
toc

tic
Out3 = NLMintegralimage(I,3,10,2,5);
toc

disp(Out1(1,1));
disp(Out2(1,1));
disp(Out3(1,1));

imshow([Out1,Out2,Out3],[]);


