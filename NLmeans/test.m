close all;  
clear all;  
clc 

%{
m = [5 2 5 2; 3 6 3 6; 5 2 5 2; 3 6 3 6];
%m = [5 2 5 2 3 6 3 6 5 2 5 2 3 6 3 6];

ii = computeIntegralImage(m);

r = evaluateIntegralImage(ii,1,1,2);
%}  
%%

img = imread('images/alleyNoisy_sigma20.png');
img = rgb2gray(img);
I=double(img);  

tic
%myOut=FNLM(I,2,5,20);
myOut=fastNLmeans(I,2,5,20);
%Out=fastNonLocalMeans(I,3,10,2,5);
toc


%{
tic
Out=fastNLmeans(I,2,5,10);
toc
%}

imshow([I,myOut],[]);


%%

%%
%{
img = imread('images/alleyNoisy_sigma21.png');
R = double(img(:,:,1));
G = double(img(:,:,2));
B = double(img(:,:,3));

%{
tic
noise_free(:,:,1)=NLmeans(R,2,5,10);
noise_free(:,:,2)=NLmeans(G,2,5,10);
noise_free(:,:,3)=NLmeans(B,2,5,10);
toc
%}

tic
noise_free(:,:,1)=nonLocalMeans(R,1,10,3,10);
noise_free(:,:,2)=nonLocalMeans(G,1,10,3,10);
noise_free(:,:,3)=nonLocalMeans(B,1,10,3,10);
toc

imshow([img,uint8(noise_free)]);
%}


%%
%{
function noise_free = noise_removal(nfun, img, varargin)

[sx,sy,sz] = size(img);

if sz > 1
    %colour image, channels handled seperatly 
    noise_free = zeros(sx,sy,sz);
    noise_free(:,:,1) = nfun(img(:,:,1), varargin{:});
    noise_free(:,:,2) = nfun(img(:,:,2), varargin{:});
    noise_free(:,:,3) = nfun(img(:,:,3), varargin{:});
else
    %grey image
    noise_free = nfun(img, varargin{:});
end

end
%}
%%
%{

%I=double(imread('noisy.jpg')); 
image = imread('images/alleyNoisy_sigma21.png');
I = double(rgb2gray(image));
%I=I+10*randn(size(I));
D = NLmeans(I,2,5,15);
imshow(D);
%I = double(image);
%R = double(image(:,:,2));


%a = zeros(size(image, 1), size(image, 2));


%justR = cat(3, R, a, a);

%imshow(justR);

%denosiedR = NLmeans(R,2,5,15);

imshow(I);

%imshow(image(:,:,1));
%{
R = image(:,:,1);
G = image(:,:,2);
B = image(:,:,3);
%imshow(image);


%I=I+10*randn(size(I));  

tic  
%O1=NLmeans(I,2,5,15);  


%denosiedR = NLmeans(R,2,5,15);
%denosiedG = NLmeans(G,2,5,15);
%denosiedB = NLmeans(B,2,5,15);

toc  

imshow(image);

%imshow(cat(3,R,G,B));
%}
%}
