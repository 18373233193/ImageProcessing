close all;
clear;
clc;

TargetImg   = imread('image/city.jpg');
SourceImg   = imread('image/plane.jpg');

[SourceRows, SourceCols, ~] = size(SourceImg);
[TargetRows, TargetCols, ~] = size(TargetImg);

% Polygon
polygon = [154,161;250,186;286,151;289,97;281,49;220,48;145,53;57,16;11,54;13,98;78,142];

x = polygon(:,1);
y = polygon(:,2);
% 
% mask
SourceMask = poly2mask(x,y,SourceRows,SourceCols);

position_in_target = [100,70];

% mask for background
[row, col] = find(SourceMask);

start_pos = [min(col), min(row)];
end_pos   = [max(col), max(row)];

MaskTarget = zeros(TargetRows, TargetCols);

s = [TargetRows, TargetCols];
x = row - start_pos(2) + position_in_target(2);
y = col - start_pos(1) + position_in_target(1);

MaskTarget(sub2ind(s, x, y)) = 1; %???????????????????

% boundry array
TargBoundry = bwboundaries(MaskTarget); 

% compute gradient
filter = [0 -1 0; -1 4 -1; 0 -1 0];
laplacian = imfilter(double(SourceImg), filter, 'replicate');

VR = laplacian(:, :, 1);
VG = laplacian(:, :, 2);
VB = laplacian(:, :, 3);

TargetImgR = double(TargetImg(:, :, 1));
TargetImgG = double(TargetImg(:, :, 2));
TargetImgB = double(TargetImg(:, :, 3));

TargetImgR(logical(MaskTarget(:))) = VR(SourceMask(:)); 
TargetImgG(logical(MaskTarget(:))) = VG(SourceMask(:));
TargetImgB(logical(MaskTarget(:))) = VB(SourceMask(:));

TargetImgNew = cat(3, TargetImgR, TargetImgG, TargetImgB);

% adjacency matrix
AdjacencyMat = calcAdjancency(MaskTarget);

% poisson equation
ResultImgR = MyPoissonSolver(TargetImgR, MaskTarget, AdjacencyMat, TargBoundry);
ResultImgG = MyPoissonSolver(TargetImgG, MaskTarget, AdjacencyMat, TargBoundry);
ResultImgB = MyPoissonSolver(TargetImgB, MaskTarget, AdjacencyMat, TargBoundry);

ResultImg = cat(3, ResultImgR, ResultImgG, ResultImgB);

figure;
imshow(uint8(ResultImg));


% figure;
% imshow(dolphinImage);
% % 
% hold on
% plot(x,y,'r')
% hold off