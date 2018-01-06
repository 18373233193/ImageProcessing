function result = mixGradient(im_target,im_source)

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

result = lap;

end