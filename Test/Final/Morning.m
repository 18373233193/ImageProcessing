function [result] = Morning(I,sigma,h,ds,Ds)  

[m,n]=size(I);  
Vsym = padarray(I,[Ds+ds+1,Ds+ds+1],'symmetric');  % why plus 1 ??

result = zeros(m,n); 

ii = cell(2*Ds+1);

for t1=-Ds:Ds  
    for t2=-Ds:Ds
        x = t1+Ds+1;
        y = t2+Ds+1;
        ii{x,y} = computeIntegralImage(Vsym,Ds,t1,t2);
    end
end


for i=1:m  
    for j=1:n 
        
        average = 0;  
        sweight = 0;
        
        i1 = i+Ds+ds+1;
        j1 = j+Ds+ds+1;

        for y1 = i1 - Ds : i1 + Ds
            for y2 = j1 - Ds : j1 + Ds
                
                if(y1 == i1 && y2 == j1)
                    continue;  
                end

                p = y1 - (i1 - Ds) + 1;
                q = y2 - (j1 - Ds) + 1; 

                
                f1=i+ds+1; %??? Why plus 1 ??
                g1=j+ds+1; %??? 
                
                dist = evaluateIntegralImage(ii{p,q}, f1, g1, ds);
                
                %{
                A = ii{q,p}(f1+ds,g1+ds);
                B = ii{q,p}(f1-ds-1,g1-ds-1);
                C = ii{q,p}(f1+ds,g1-ds-1);
                D = ii{q,p}(f1-ds-1,g1+ds);
                dist = A+B-C-D;
                %}

                w = computeWeighting(dist, h, sigma, ds);

                sweight=sweight+w;
                average=average+w*Vsym(y1,y2);

            end
        end
        
        result(i,j) = average/sweight;

    end
end

end
