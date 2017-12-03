close all;  
clear all;  
clc 

img = imread('images/alleyNoisy_sigma22.png');
%img = rgb2gray(img);
%I=double(img);  

tic
Out1=nonLocalMeans(img,3,10,2,5);
toc

tic
%Out2=Dawn(I,3,10,2,5);
toc

tic
%Out3=Morning(I,3,10,2,5);
toc


imshow([Out1],[]);


