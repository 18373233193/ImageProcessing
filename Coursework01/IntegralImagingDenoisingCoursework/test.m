close all;  
clear all;  
clc 

img = imread('images/alleyNoisy_sigma20.png');
img = rgb2gray(img);
I=double(img); 

h = 0.55;
sigma = 20;

tic
Out1 = nonLocalMeans(I,h,sigma,2,8);
toc

tic
%Out2 = NLMnaive(I,h,sigma,2,5);
toc

tic
%Out3 = NLMintegralimage(I,h,sigma,2,5);
toc

%disp(Out1(1,1));
%disp(Out2(1,1));
%disp(Out3(1,1));

imshow(Out1,[]);



