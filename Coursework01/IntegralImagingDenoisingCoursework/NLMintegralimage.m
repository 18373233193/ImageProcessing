function [result] = NLMintegralimage(image,sigma,h,ds,Ds)  

[N1,N2] = size(image);
result = zeros(N1,N2);

Vsym = padarray(image,[Ds+ds,Ds+ds],'symmetric');

ii = cell(2*Ds+1);

for t1=-Ds:Ds  
    for t2=-Ds:Ds
        x = t1+Ds+1;
        y = t2+Ds+1;
        ii{x,y} = computeIntegralImage(Vsym,Ds,t1,t2);
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

end
