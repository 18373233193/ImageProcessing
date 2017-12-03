function [result] = Today(image, sigma, ds, Ds, h)    

[N1,N2] = size(image);  
result = zeros(N1,N2);

Vsym = padarray(image, [Ds+ds,Ds+ds], 'symmetric');

for x1 = 1:N1  
    for x2 = 1:N2 
        
        [offsetsRows, offsetsCols, distances] = templateMatchingNaive(Vsym, x1, x2, ds, Ds);
        
        w = computeWeighting(distances, h, sigma, ds);
        
        sweight = sum(sum(w)) - 1;
        
        average = sum(sum((w').*Vsym(offsetsRows(1):offsetsRows(end),offsetsCols(1):offsetsCols(end)))) - image(x1,x2);
        
        result(x1,x2) = average/sweight;
        
    end
end

end



