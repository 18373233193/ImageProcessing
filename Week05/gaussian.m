function result = gaussian(size,sigma)

interval = 0.25;

a = (size-1)/2;

[X,Y] = meshgrid(-a*interval:interval:a*interval,-a*interval:interval:a*interval);
Z = (1/(2*pi*sigma.^2)) * exp(-(X.^2 + Y.^2)/(2*sigma.^2));

result = Z;

end