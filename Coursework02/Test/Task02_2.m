close all;
clear;
clc;

dolphinImage   = imread('image/plane.jpg');
backImage   = imread('image/city.jpg');
%backImage   = imread('image/example02_3.jpg');

dolphinImage = rgb2gray(dolphinImage);
backImage = rgb2gray(backImage);

[backRows, backCols] = size(backImage);
[SourceRows, SourceCols] = size(dolphinImage);

% Polygon
% polygon = [109,31;111,52;87,92;80,149;
%     57,178;56,209;110,197;148,182;
%     131,153;140,114;227,112;243,107;
%     239,91;232,64;197,35;150,31;121,21;109,31];

% polygon = [42,41;45,60;18,71;19,98;114,126;200,175;271,175;233,139;271,133;290,122;269,104;282,72;260,49;227,70;193,53;173,73;104,60;59,32];

polygon = [154,161;250,186;286,151;289,97;281,49;220,48;145,53;57,16;11,54;13,98;78,142];

x = polygon(:,1);
y = polygon(:,2);
% 
% mask
mask = poly2mask(x,y,SourceRows,SourceCols);

position_in_target = [100,350];

% mask for background
[row, col] = find(mask);

start_pos = [min(col), min(row)];
end_pos   = [max(col), max(row)];

backMask = zeros(backRows, backCols);

s = [backRows, backCols];
x = row - start_pos(2) + position_in_target(2);
y = col - start_pos(1) + position_in_target(1);

backMask(sub2ind(s, x, y)) = 1; %???????????????????


% boundry array
boundry = bwboundaries(backMask); 

% compute gradient
filter = [0 -1 0; -1 4 -1; 0 -1 0];
laplacian = imfilter(double(dolphinImage), filter, 'replicate');

backlaplacian = imfilter(double(backImage), filter, 'replicate');

backImage = double(backImage);
backImage(logical(backMask(:))) = laplacian(mask(:));

tempBack = backlaplacian.*backMask;
backImage = backImage + tempBack;

% 
% for i = 1:backRows
%     for j = 1:backCols
%         if tempBack(i,j) == 0
%             continue;
%         elseif abs(backlaplacian(i,j)) > abs(backImage(i,j))
%             backImage(i,j) = backlaplacian(i,j);
%         end
%     end
% end


% adjacency matrix
AdjacencyMat = calcAdjancency(backMask);

% poisson equation
result = MyPoissonSolver(backImage, backMask, AdjacencyMat, boundry);

figure;
imshow(uint8(result));


% figure;
% imshow(dolphinImage);
% % 
% hold on
% plot(x,y,'r')
% hold off