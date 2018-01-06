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


polygon = [29,56;16,94;93,126;151,147;252,177;288,143;281,102;292,69;253,40;215,64;164,64;109,53;63,31];

x = polygon(:,1);
y = polygon(:,2);
% 
% mask
mask = poly2mask(x,y,SourceRows,SourceCols);

position_in_target = [100,150];

% mask for background
[row, col] = find(mask);

start_pos = [min(col), min(row)];
end_pos   = [max(col), max(row)];

backMask = zeros(backRows, backCols);

xx = position_in_target(2):(position_in_target(2)+SourceRows-1);
yy = position_in_target(1):(position_in_target(1)+SourceCols-1);

backMask(xx,yy) = mask;

% s = [backRows, backCols];
% x = row - start_pos(2) + position_in_target(2);
% y = col - start_pos(1) + position_in_target(1);
% 
% backMask(sub2ind(s, x, y)) = 1; %???????????????????


% boundry array
boundry = bwboundaries(backMask); 

% compute gradient
% filter = [0 -1 0; -1 4 -1; 0 -1 0];
% laplacian = conv2(double(dolphinImage), filter, 'same');
% 
% backlaplacian = conv2(double(backImage), filter, 'same');
% 
target_area = backImage(position_in_target(2):(position_in_target(2)+SourceRows-1),position_in_target(1):(position_in_target(1)+SourceCols-1));


% 
% backImage = double(backImage);
% backImage(logical(backMask(:))) = laplacian(mask(:));

% ********




%create the gradient mask for the first derivative
grad_mask_x=[-1 1];
grad_mask_y=[-1;1]; 
        
%get the first derivative of the target image
g_x_target=conv2(target_area(:,:), grad_mask_x, 'same');
g_y_target=conv2(target_area(:,:), grad_mask_y, 'same');
g_mag_target=sqrt(g_x_target.^2+g_y_target.^2);
        
%get the first derivative of the source image
g_x_source=conv2(dolphinImage(:,:),grad_mask_x, 'same');
g_y_source=conv2(dolphinImage(:,:),grad_mask_y, 'same');
g_mag_source=sqrt(g_x_source.^2+g_y_source.^2);

% %work with 1-D
g_mag_target=g_mag_target(:);
g_mag_source=g_mag_source(:);
%         
%initialize the final gradient with the source gradient
g_x_final=g_x_source(:);
g_y_final=g_y_source(:);
         
%if the gradient of the target image is larger than the gradient of
%the source image, use the target's gradient instead
g_x_final(abs(g_mag_target)>abs(g_mag_source))=...
            g_x_target(g_mag_target>g_mag_source);
        
g_y_final(abs(g_mag_target)>abs(g_mag_source))=...
            g_y_target(g_mag_target>g_mag_source);
        
%map to 2-D
g_x_final=reshape(g_x_final,size(dolphinImage,1),size(dolphinImage,2));
g_y_final=reshape(g_y_final,size(dolphinImage,1),size(dolphinImage,2));
        
%get the final laplacian of the combination between the source and
%target images lap=second deriv of x + second deriv of y
lap=conv2(g_x_final,grad_mask_x, 'same');
lap=lap+conv2(g_y_final,grad_mask_y, 'same');

backImage = double(backImage);

tempBack = lap.*mask;



backImage = backImage .* (~backMask);



blank = zeros(backRows,backCols);
blank(xx,yy) = tempBack;

backImage(xx,yy) = backImage(xx,yy) + tempBack;

figure;
imshow(uint8(blank));

figure;
imshow(uint8(backImage));

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