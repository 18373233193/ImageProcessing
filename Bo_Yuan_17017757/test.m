close all;  
clear all;  
clc 

img = imread('images/alleyNoisy_sigma20.png');
%img = rgb2gray(img);

h = 1;
sigma = 15;

tic
r = NLMintegralimage(img(:,:,1),h,sigma,2,5);
g = NLMintegralimage(img(:,:,2),h,sigma,2,5);
b = NLMintegralimage(img(:,:,3),h,sigma,2,5);
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




