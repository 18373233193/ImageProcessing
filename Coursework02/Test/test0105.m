close all;
clear;
clc;

im_source   = imread('image/plane.jpg');
im_whole_target   = imread('image/city.jpg');

im_source = rgb2gray(im_source);
im_whole_target = rgb2gray(im_whole_target);

im_source = double(im_source);
im_whole_target = double(im_whole_target);

% position
position_in_target = [50,50];

[rows, cols] = size(im_source);

scale_x = position_in_target(2):(position_in_target(2)+rows-1);
scale_y = position_in_target(1):(position_in_target(1)+cols-1);

im_target = im_whole_target(scale_x,scale_y);

im_out = im_target;

polygon = [29,56;16,94;93,126;151,147;252,177;288,143;281,102;292,69;253,40;215,64;164,64;109,53;63,31];

x = polygon(:,1);
y = polygon(:,2);

% mask of source image
im_mask = poly2mask(x,y,rows,cols);

%find the number of unknown pixels based on the mask
n=size(find(im_mask==1),1);

%create the gradient mask for the first derivative
grad_mask_x=[-1 1];
grad_mask_y=[-1;1]; 
        
%get the first derivative of the target image

g_x_target=conv2(im_target(:,:),grad_mask_x, 'same');
g_y_target=conv2(im_target(:,:),grad_mask_y, 'same');
g_mag_target=sqrt(g_x_target.^2+g_y_target.^2);
        
%get the first derivative of the source image
g_x_source=conv2(im_source(:,:),grad_mask_x, 'same');
g_y_source=conv2(im_source(:,:),grad_mask_y, 'same');
g_mag_source=sqrt(g_x_source.^2+g_y_source.^2);
        
%work with 1-D
g_mag_target=g_mag_target(:);
g_mag_source=g_mag_source(:);
        
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
g_x_final=reshape(g_x_final,size(im_source,1),size(im_source,2));
g_y_final=reshape(g_y_final,size(im_source,1),size(im_source,2));
        
%get the final laplacian of the combination between the source and
%target images lap=second deriv of x + second deriv of y
lap=conv2(g_x_final,grad_mask_x, 'same');
lap=lap+conv2(g_y_final,grad_mask_y, 'same');

%create the laplacian mask for the second derivative of the source image
laplacian_mask=[0 1 0; 1 -4 1; 0 1 0];

%create look up table
map=zeros(size(im_mask));

%loop through the mask image to initialize the look up table for mapping
counter=0;
for x=1:size(map,1)
    for y=1:size(map,2)
        if im_mask(x,y)==1 %is it unknow pixel?
            counter=counter+1;
            map(x,y)=counter;  %map from (x,y) to the corresponding pixel
            %in the 1D vector
        end
    end
end

%At most, there are 5 coefficients per row according to eq (3)
%in the report
coeff_num=5;

%create the sparse matrix to save memory
A=spalloc(n,n,n*coeff_num);

%create the right hand side of the linear system of equations (AX=B)
B=zeros(n,1);

counter=0;
for x=1:size(map,1)
    for y=1:size(map,2)
        if im_mask(x,y)==1
            counter=counter+1;
            A(counter,counter)=4; %the diagonal represent the current pixel

            %check the boundary
            if im_mask(x-1,y)==0 %known left pixel
                B(counter)=im_target(x-1,y); %add it to B
            else %unknown boundary
                A(counter,map(x-1,y))=-1; %set its coefficient to -1
            end
            if im_mask(x+1,y)==0 %known right pixel
                B(counter)=B(counter)+im_target(x+1,y); %add it to B
            else %unknown boundary
                A(counter,map(x+1,y))=-1; %set its coefficient to -1
            end
            if im_mask(x,y-1)==0 %known bottom pixel
                B(counter)=B(counter)+im_target(x,y-1); %add it to B
            else %unknown boundary
                A(counter,map(x,y-1))=-1; %set its coefficient to -1
            end
            if im_mask(x,y+1)==0 %known top pixel
                B(counter)=B(counter)+im_target(x,y+1); %add it to B
            else %unknown boundary
                A(counter,map(x,y+1))=-1; %set its coefficient to -1
            end

            %update the B vector with the laplacian value

            B(counter)=B(counter)-lap(x,y);

        end
    end
end
    
%solve the linear system of equation
X=A\B;

for counter=1:length(X)
    [index_x,index_y]=find(map==counter);
    im_out(index_x,index_y)=X(counter);

end

figure;
imshow(im_out,[]);
