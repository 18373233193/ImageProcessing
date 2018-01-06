close all;
clear;
clc;

%% read image / convert the type to double
im_target = imread('image/flower.jpg');


im_source = imread('image/aaa.jpg');

% change color
im_source_r = im_source(:,:,1);
im_source_g = im_source(:,:,2)-100;
im_source_b = im_source(:,:,3)-255;

im_source = cat(3,im_source_r,im_source_g,im_source_b);



im_source = double(im_source);
im_target = double(im_target);


[rows, cols, channel] = size(im_source);


%% Polygon: define a polygon to set up a mask

polygon = [184,96;128,111;91,162;80,214;96,263;127,310;190,335;245,318;293,295;313,255;312,212;318,162;277,114;235,97];

x = polygon(:,1);
y = polygon(:,2);

% mask of source image
im_mask = poly2mask(x,y,rows,cols);

% find the number of unknown pixels based on the mask
n = size(find(im_mask==1),1);

%% create the laplacian mask for the second derivative of the source image
laplacian_mask = [0 1 0; 1 -4 1; 0 1 0];

%% output the image
im_out = im_target;

for c = 1:channel

    %create the laplacian of the source image
    lap = mixGradient(im_target(:,:,c),im_source(:,:,c));
    %lap = conv2(im_source(:,:,c),laplacian_mask, 'same');
 
    % indexArray is an array includes 1d index for points (value is 1 in the mask)
    indexMatrix = compute1DIndex(im_mask);
    
    % compute A and b
    [A, b] = constructEquation(n,im_target(:,:,c),im_mask,lap,indexMatrix);
    
    %solve the linear system of equation
    X = A \ b;
    
    for i = 1:length(X)
    
        [x,y] = find(indexMatrix == i);
    
        im_out(x,y,c) = X(i);
    
    end

end

figure;
imshow(uint8(im_out));
