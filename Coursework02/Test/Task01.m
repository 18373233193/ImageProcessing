close all;
clear;
clc;

image   = imread('image/example.jpg');

%Polygon
% low frequency (small)
x = [731 752 718 696 731];
y = [134 152 166 153 134];

% low frequency (big)
% x = [629 694 732 704 615 584 629];
% y = [46 48 90 132 132 73 46];

% high frequency (small)
% x = [72 109 104 64 72];
% y = [394 392 467 468 394];

% high frequency (big)
% x = [279 390 390 279 279];
% y = [94 121 268 258 94];

mask = poly2mask(x,y,600,800);

% boundry array
boundry = bwboundaries(mask); 

imageR = double(image(:, :, 1));
imageG = double(image(:, :, 2));
imageB = double(image(:, :, 3));

% delete pixels in the mask 
imageR(logical(mask(:))) = 0; 
imageG(logical(mask(:))) = 0;
imageB(logical(mask(:))) = 0;

% ********************* 
tic;
AdjacencyMat = calcAdjancency(mask);
toc;
% **********************

resultR = MyPoissonSolver(imageR, mask, AdjacencyMat, boundry);
resultG = MyPoissonSolver(imageG, mask, AdjacencyMat, boundry);
resultB = MyPoissonSolver(imageB, mask, AdjacencyMat, boundry);

result = cat(3, resultR, resultG, resultB);

figure;
imshow(uint8(result));

% hold on
% plot(x,y,'y')
% hold off
