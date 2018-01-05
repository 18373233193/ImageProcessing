close all;  
clear all;  
clc 

img = imread('alleyNoisy_sigma22.png');
img = rgb2gray(img);
I=double(img);  

tic
Out1=Today(I,3,2,5,10);
toc

tic
Out2=FinalTest(I,3,2,5,10);
toc

%{
tic
Out=fastNLmeans(I,2,5,10);
toc
%}


imshow([Out1,Out2],[]);


