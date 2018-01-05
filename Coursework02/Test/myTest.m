close all;
clear;
clc;

%(1) read image
TargetImg   = imread('pool.jpg');
SourceImg   = imread('bear.jpg');
SourceMask  = imbinarize(rgb2gray(imread('bear_mask.jpg')));%creates a binary image from image

%(2) boundry array
SrcBoundry = bwboundaries(SourceMask); 
% Trace region boundaries in binary image

%(3) boundry value



%(3) laplacian
templt = [0 -1 0; -1 4 -1; 0 -1 0];
LaplacianSource = imfilter(double(SourceImg), templt, 'replicate');

%(4) set b
%Number of nonzero matrix elements
[number] = size(SrcBoundry{1});% delete boundary
b = zeros(nnz(uint8(SourceMask))-number(1),1);
I = zeros(nnz(uint8(SourceMask))-number(1),1);

[m,n,c] = size(SourceImg);

index_b = 1;


channel = SourceImg(:,:,1);
channel = channel .* uint8(SourceMask);
channel = double(channel);

S = LaplacianSource(:,:,1);

TargetImg = double(TargetImg);
b = double(b);

for i = 1:m
    for j = 1:n
            
        if(0 == SourceMask(i,j))
            continue; 
        end

        b(index_b) = S(i,j);

        if(ismember([i,j],SrcBoundry{1},'rows'))

            if(SourceMask(i+1,j) == 0)
                b(index_b) = b(index_b) + TargetImg(i+1,j);
            end

            if(SourceMask(i-1,j) == 0)
                b(index_b) = b(index_b) + TargetImg(i-1,j);
            end

            if(SourceMask(i,j+1) == 0)
                b(index_b) = b(index_b) + TargetImg(i,j+1);
            end

            if(SourceMask(i,j-1) == 0)
                b(index_b) = b(index_b) + TargetImg(i,j-1);
            end
        end

        index_b = index_b + 1;
            
    end
end


%(5) set A
A = calcAdjancency( double(SourceMask) );

%(6) solve it

tic;
I = A\b;
toc;
