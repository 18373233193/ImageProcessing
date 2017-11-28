function [ii] = computeIntegralImage(image)

[m,n] = size(image);

ii = zeros(m,n);

for x = 1:m
    for y = 1:n
        
        if x-1<1
            B = 0;
        else
            B = ii(x-1,y);
        end
        
        if y-1<1
            C = 0;
        else
            C = ii(x,y-1);
            
        end
        
        if x==1||y==1
            D = 0;
        else
            D = ii(x-1,y-1);
        end
        
        ii(x,y) = image(x,y) + B + C - D;
    end
end

%REPLACE THIS
%ii = zeros(size(image));

end