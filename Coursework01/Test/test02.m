close all;  
clear all;  
clc  
I=double(imread('alleyNoisy_sigma23.png'));  
I=I+10*randn(size(I));  
tic  
%O1=NLmeans(I,2,5,10);  
toc  
tic  
O2=fastNLmeans(I,2,5,10);  
toc  
figure;  
imshow([O2],[]); 