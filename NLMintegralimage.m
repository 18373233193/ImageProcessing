function [result] = NLMintegralimage(I,sigma,h,ds,Ds)  

image = double(I); 

[N1,N2] = size(image);
result = zeros(N1,N2);

Vsym = padarray(image,[Ds+ds,Ds+ds],'symmetric');

ii = cell(2*Ds+1);

for t2 = -Ds : Ds
    for t1 = -Ds : Ds  
        
        ss = Ds;
        
        x = t1 + ss + 1;
        y = t2 + ss + 1; 

        dist = (Vsym(1 + ss : end - ss, 1 + ss : end - ss) - ...
            Vsym(1 + ss + t1 : end - ss + t1, 1 + ss + t2 : end - ss + t2)).^2;  

        ii{x,y} = computeIntegralImage(dist);
        
    end
end

for x2 = 1:N2
    for x1 = 1:N1  
  
        [offsetsRows, offsetsCols, distances] = templateMatchingIntegralImage(Vsym, ii, x1, x2, ds, Ds);
        
        w = computeWeighting(distances, h, sigma, ds);
        
        sweight = sum(sum(w)) - 1;
        
        average = sum(sum((w').*Vsym(offsetsRows(1):offsetsRows(end),offsetsCols(1):offsetsCols(end)))) - image(x1,x2);
        
        result(x1,x2) = average/sweight;

    end
end

result = uint8(result);

end
