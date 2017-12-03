function [result] = Dawn(I,sigma,h,ds,Ds)  

[N1,N2]=size(I);  
Vsym = padarray(I,[Ds+ds+1,Ds+ds+1],'symmetric');  % why plus 1 ??

result = zeros(N1,N2); 

ii = cell(2*Ds+1);

for t1=-Ds:Ds  
    for t2=-Ds:Ds
        x = t1+Ds+1;
        y = t2+Ds+1;
        ii{x,y} = computeIntegralImage(Vsym,Ds,t1,t2);
    end
end


for x1=1:N1  
    for x2=1:N2 
        
        [offsetsRows, offsetsCols, distances] = templateMatchingIntegralImage(Vsym, ii, x1, x2, ds, Ds);
        
        w = computeWeighting(distances, h, sigma, ds);
        
        sweight = sum(sum(w)) - 1;
        
        average = sum(sum((w').*Vsym(offsetsRows(1):offsetsRows(end),offsetsCols(1):offsetsCols(end)))) - I(x1,x2);
        
        result(x1,x2) = average/sweight;

    end
end

end
