clear all
close all
clc

MeanFilter = (1/9).*ones(3);
GaussianFilter05 = gaussian(7,0.5);
GaussianFilter1 = gaussian(7,1);

I = rgb2gray(imread('einstein.png'));
I = double(I);

image1 = conv2(I,MeanFilter);
%image1 = image1(2:end-1,2:end-1);
image2 = convolve(I,MeanFilter);
image3 = convolve(I,GaussianFilter05);
image4 = convolve(I,GaussianFilter1);


subplot(2,2,1), imshow(I,[]);
title('initial image');
subplot(2,2,2), imshow(image2,[]);
title('3*3 Mean filter result');
subplot(2,2,3), imshow(image3,[]);
title('7*7 Gaussian filter (sigma=0.5) result');
subplot(2,2,4), imshow(image4,[]);
title('7*7 Gaussian filter (sigma=1) result');
