close all;
clear;
clc;

dolphinImage   = imread('image/example02_2.jpg');
backImage   = imread('image/example02_1.jpg');
%backImage   = imread('image/example02_3.jpg');

dolphinImage = rgb2gray(dolphinImage);
backImage = rgb2gray(backImage);

[TargetRows, TargetCols, ~] = size(backImage);
[SourceRows, SourceCols, ~] = size(dolphinImage);

% Polygon
polygon = [109,31;111,52;87,92;80,149;
    57,178;56,209;110,197;148,182;
    131,153;140,114;227,112;243,107;
    239,91;232,64;197,35;150,31;121,21;109,31];

x = polygon(:,1);
y = polygon(:,2);
% 
% mask
mask = poly2mask(x,y,SourceRows,SourceCols);

position_in_target = [300, 280];%xy


[row, col] = find(mask);

% get a smaller mask, precise mask
start_pos = [min(col), min(row)]; 
end_pos   = [max(col), max(row)];

backMask = zeros(TargetRows, TargetCols);

% ????????????
s = [TargetRows, TargetCols];
x = row - start_pos(2) + position_in_target(2);
y = col - start_pos(1) + position_in_target(1);

backMask(sub2ind(s, x, y)) = 1;

boundry = bwboundaries(backMask);

templt = [0 -1 0; -1 4 -1; 0 -1 0];
LaplacianSource = imfilter(double(dolphinImage), templt, 'replicate');

backImage = double(backImage);
backImage(logical(backMask(:))) = LaplacianSource(mask(:));

AdjacencyMat = calcAdjancency(backMask);

Result = MyPoissonSolver(backImage, backMask, AdjacencyMat, boundry);

figure;
imshow(uint8(Result));

