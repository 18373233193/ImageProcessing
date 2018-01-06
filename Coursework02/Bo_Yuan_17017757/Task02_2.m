close all;
clear;
clc;

%% read image / convert to gray scale / convert the type to double
im_source   = imread('image/plane.jpg');
im_whole_target   = imread('image/city.jpg');

im_source = rgb2gray(im_source);
im_whole_target = rgb2gray(im_whole_target);

im_source = double(im_source);
im_whole_target = double(im_whole_target);

%% position of the source image in the target image
position_in_target = [50,50];

[rows, cols] = size(im_source);

range_x = position_in_target(2):(position_in_target(2)+rows-1);
range_y = position_in_target(1):(position_in_target(1)+cols-1);

%% get a precise image of the whole target image
% Its a smaller image, the size is equal to the source image.
im_target = im_whole_target(range_x,range_y);

%% Polygon: define a polygon to set up a mask
polygon = [114,157;186,177;283,176;286,64;258,25;203,52;142,48;95,27;30,24;11,89;51,133];

x = polygon(:,1);
y = polygon(:,2);

% mask of source image
im_mask = poly2mask(x,y,rows,cols);

% find the number of unknown pixels based on the mask
n = size(find(im_mask==1),1);

%% create the laplacian mask for the second derivative of the source image
laplacian_mask = [0 1 0; 1 -4 1; 0 1 0];

%create mixing gradients
lap = mixGradient(im_target,im_source);

%% indexArray is an array includes 1d index for points (value is 1 in the mask)
indexMatrix = compute1DIndex(im_mask);

%% compute A and b, 
[A, b] = constructEquation(n,im_target,im_mask,lap,indexMatrix);
    
%solve the linear system of equation
X = A \ b;

%% output the image
im_out = im_target;

for i = 1:length(X)
    
    [x,y] = find(indexMatrix == i);
   
    im_out(x,y+1) = X(i);
    
end


im_whole_target(range_x,range_y) = im_out;

figure;
imshow(im_whole_target,[]);
