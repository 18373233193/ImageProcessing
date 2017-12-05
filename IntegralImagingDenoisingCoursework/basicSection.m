%% Some parameters to set - make sure that your code works at image borders!

% Row and column of the pixel for which we wish to find all similar patches 
% NOTE: For this section, we pick only one patch
row = 4;
col = 5;

% Patchsize - make sure your code works for different values
patchSize = 2;

% Search window size - make sure your code works for different values
searchWindowSize = 5;


%% Implementation of work required in your basic section-------------------

% TODO - Load Image
img = imread('images/alleyNoisy_sigma20.png');
I = double(rgb2gray(img));  
paddedI = padarray(I,[searchWindowSize+patchSize,searchWindowSize+patchSize],'symmetric');

% TODO - Fill out this function
%computeii() is just used to compute integral image
%computeIntegralImage() is used to compute integral image with some parameters
image_ii = computeii(I); 

% TODO - Display the normalised Integral Image
% NOTE: This is for display only, not for template matching yet!
figure('name', 'Normalised Integral Image');
%imshow(image_ii,[]);

% ii saves all the integral image of all the offsets
ii = cell(2*searchWindowSize+1);

for t2 = -searchWindowSize : searchWindowSize
    for t1 = -searchWindowSize : searchWindowSize  
        x = t1 + searchWindowSize + 1;
        y = t2 + searchWindowSize + 1;
        ii{x,y} = computeIntegralImage(paddedI, searchWindowSize, t1, t2);
    end
end

% TODO - Template matching for naive SSD (i.e. just loop and sum)
[offsetsRows_naive, offsetsCols_naive, distances_naive] = templateMatchingNaive(paddedI, row, col,...
    patchSize, searchWindowSize);

% TODO - Template matching using integral images
[offsetsRows_ii, offsetsCols_ii, distances_ii] = templateMatchingIntegralImage(paddedI, ii, row, col,...
    patchSize, searchWindowSize);

%% Let's print out your results--------------------------------------------

% NOTE: Your results for the naive and the integral image method should be
% the same!
for i=1:length(offsetsRows_naive)
    disp(['offset rows: ', num2str(offsetsRows_naive(i)), '; offset cols: ',...
        num2str(offsetsCols_naive(i)), '; Naive Distance = ', num2str(distances_naive(i),10),...
        '; Integral Im Distance = ', num2str(distances_ii(i),10)]);
end