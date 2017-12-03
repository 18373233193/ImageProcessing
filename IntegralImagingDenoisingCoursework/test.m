close all;  
clear all;  
clc 

img = imread('images/alleyNoisy_sigma22.png');
img = rgb2gray(img);
I=double(img);  

tic
%Out1=Today(I,3,2,5,10);
toc

tic
Out2=Night(I,3,2,5,10);
toc

tic
Out3=Morning(I,3,2,5,10);
toc

%{
tic
Out=fastNLmeans(I,2,5,10);
toc
%}


imshow([Out2,Out3],[]);


