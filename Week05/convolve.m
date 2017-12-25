function result = convolve(I,F)

[m,n] = size(I);
[h,w] = size(F);

a = h/2;
b = w/2;

if(mod(h,2) ~= 0)
    a = (h-1)/2;
end

if(mod(w,2) ~= 0)
    b = (w-1)/2;
end

I = padarray(I,[a,b],'symmetric');

result = zeros(m,n);

for x = 1:m
    for y = 1:n
        i = x + a;
        j = y + b;
        
        kernel = F;
        patch = I(i-a:i+a,j-b:j+b);
        result(x,y) = sum(sum(kernel.*patch));
    end
end

% result = uint8(result);

end