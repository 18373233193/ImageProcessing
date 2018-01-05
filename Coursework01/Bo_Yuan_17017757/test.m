close all;  
clear all;  
clc 

img = imread('images/alleyNoisy_sigma22.png');
%img = rgb2gray(img);

h = 0.7;
sigma = 15;

tic
r = nonLocalMeans(img(:,:,1),sigma,h,2,5);
g = nonLocalMeans(img(:,:,2),sigma,h,2,5);
b = nonLocalMeans(img(:,:,3),sigma,h,2,5);
toc

colour = cat(3,r,g,b);

imshow(colour);


% tic
% Out1 = nonLocalMeans(img,h,sigma,2,5);
% toc
% 
% tic
% Out2 = NLMnaive(img,h,sigma,2,5);
% toc
% 
% tic
% Out3 = NLMintegralimage(img,h,sigma,2,5);
% toc
% 
% disp(Out1(1,1));
% disp(Out2(1,1));
% disp(Out3(1,1));
% 
% imshow([Out1,Out2,Out3],[]);




