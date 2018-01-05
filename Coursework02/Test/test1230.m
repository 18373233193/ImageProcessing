close all;
clear;
clc;

TargetImg   = imread('image/pool_target.jpg');
SourceImg   = imread('image/bear.jpg');
SourceMask  = imbinarize(rgb2gray(imread('image/bear_mask.jpg')));%creates a binary image from image

SrcBoundry = bwboundaries(SourceMask); % ???????

% figure, imshow(SourceImg), axis image
% hold on
% for k = 1:length(SrcBoundry)
%     boundary = SrcBoundry{k};
%     plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
% end
% title('Source image intended area for cutting from');

position_in_target = [10, 225];%xy
[TargetRows, TargetCols] = size(TargetImg);

[row, col] = find(SourceMask);%???????

start_pos = [min(col), min(row)];
end_pos   = [max(col), max(row)];
frame_size  = end_pos - start_pos;

MaskTarget = zeros(TargetRows, TargetCols);

s = [TargetRows, TargetCols];
x = row - start_pos(2) + position_in_target(2);
y = col - start_pos(1) + position_in_target(1);

MaskTarget(sub2ind(s, x, y)) = 1;

figure;
imshow(MaskTarget);