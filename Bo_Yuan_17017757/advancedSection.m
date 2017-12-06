clear all
close all
clc

%% Some parameters to set - make sure that your code works at image borders!
patchSize = 2;
sigma = 10; % standard deviation (different for each image!)
h = 0.5; %decay parameter
windowSize = 5;

%TODO - Read an image (note that we provide you with smaller ones for
%debug in the subfolder 'debug' int the 'image' folder);
%Also unless you are feeling adventurous, stick with non-colour
%images for now.
%NOTE: for each image, please also read its CORRESPONDING 'clean' or
%reference image. We will need this later to do some analysis
%NOTE2: the noise level is different for each image (it is 20, 10, and 5 as
%indicated in the image file names)

image = imread('images/alleyNoisy_sigma20.png');

imageReference = imread('images/alleyReference.png');

%TODO - Implement the non-local means function
tic
r = NLMintegralimage(image(:,:,1),h,sigma,2,5);
g = NLMintegralimage(image(:,:,2),h,sigma,2,5);
b = NLMintegralimage(image(:,:,3),h,sigma,2,5);
toc

filtered = cat(3,r,g,b);


%% Let's show your results!

%Show the denoised image
figure('name', 'NL-Means Denoised Image');
imshow(filtered);


%Show difference image
diff_image = abs(image - filtered);

%if I display the diff_image directly, almost every pixel is 0, 
%so everything is black, then I try to change it to white and show a better image.
[m,n,c] = size(diff_image);
for k = 1:c
    for i = 1:m
        for j = 1:n
            if diff_image(i,j,k) == 0
                diff_image(i,j,k) = 255;
            end
        end
    end
end

figure('name', 'Difference Image');
%imshow(diff_image ./ max(max((diff_image))));
imshow(diff_image);

figure('name', 'Reference Image');
imshow(imageReference);

%Print some statistics ((Peak) Signal-To-Noise Ratio)
disp('For Noisy Input');
[peakSNR, SNR] = psnr(image, imageReference);
disp(['SNR: ', num2str(SNR, 10), '; PSNR: ', num2str(peakSNR, 10)]);


disp('For Denoised Result');
[peakSNR, SNR] = psnr(filtered, imageReference);
disp(['SNR: ', num2str(SNR, 10), '; PSNR: ', num2str(peakSNR, 10)]);
%{%}

%Feel free (if you like only :)) to use some other metrics (Root
%Mean-Square Error (RMSE), Structural Similarity Index (SSI) etc.)
