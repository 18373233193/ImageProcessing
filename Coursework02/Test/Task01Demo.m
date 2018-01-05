I = imread('image/zelda.jpg');

I = im2double(rgb2gray(I));

imshow(I);

% x = [240 245 255 270 285 290 280 270 250 240];
% y = [155 165 170 173 172 166 161 155 153 155];
% 
x = [409 464 502 488 466 405 409];
y = [126 113 142 158 160 142 126];

hold on
plot(x,y,'y')
hold off

axis([390 510 100 170]);


mask = poly2mask(x,y,450,800);
imshow(mask);

h = surf(I);
h.EdgeColor = 'none';
h.FaceColor = 'interp';
axis ij
view(-10,80);

xlim([390 510]);
ylim([100 170]);

h.FaceAlpha = 'interp';
h.AlphaData = ~mask;

J = I;
J(mask) = mean(I(mask));
h.ZData = J;
h.AlphaData = true(size(J));

title('Region filled with mean value')

imshow(J)
title('Region filled with mean value')

axis([390 510 100 170]);

u = find(mask);

w = find(~mask);

M = size(mask,1);
u_north = u - 1;
u_east = u + M;
u_south = u + 1;
u_west = u - M;

v = ones(size(u));
ijv_mask = [...
    u  u         1.00*v
    u  u_north  -0.25*v
    u  u_east   -0.25*v
    u  u_south  -0.25*v
    u  u_west   -0.25*v ];

ijv_nonmask = [w  w  1.00*ones(size(w))];

ijv = [ijv_mask; ijv_nonmask];
A = sparse(ijv(:,1),ijv(:,2),ijv(:,3));

spy(A);

b = I(:);
b(mask(:)) = 0;

x = A\b;

J2 = reshape(x,size(I));
imshow(J2);

subplot(2,2,1)
imshow(I)
axis([390 510 100 170]);
title('Original')

subplot(2,2,2)
imshow(J)
axis([390 510 100 170]);
title('Region filled with mean')

subplot(2,2,3)
imshow(J2)
axis([390 510 100 170]);
title('Region filled using Laplace equation solution')