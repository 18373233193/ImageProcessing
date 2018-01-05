function [result] = Noon(image, sigma, ds, Ds, h)  

[N1,N2] = size(image);  
result = zeros(N1,N2);

%ds patch size
Vsym = padarray(image, [Ds+ds,Ds+ds], 'symmetric'); 

kernel=ones(2*ds+1,2*ds+1);  
kernel=kernel./((2*ds+1)*(2*ds+1));

for x1 = 1:N1  
    for x2 = 1:N2  
        
        i = x1 + Ds + ds;  
        j = x2 + Ds + ds; 
        
        patch1 = Vsym(i-ds : i+ds, j-ds : j+ds);
        
        average=0;  
        sweight=0; 
        
        for y1 = i - Ds:i + Ds  
            for y2 = j - Ds:j + Ds  
                
                if(y1 == i && y2 == j)
                    continue;  
                end  
                
                patch2 = Vsym(y1 - ds : y1+ds, y2 - ds : y2 + ds);% patch window 2  
                
                Dist2=sum(sum(kernel.*(patch1-patch2).*(patch1-patch2)));%SSD 
                
                %w=exp(-max(Dist2-2*3^2,0.0)/h2);%weight  
                w = computeWeighting(Dist2, h, sigma, ds); 
                
                sweight=sweight+w;  %(C(p))
                average=average+w*Vsym(y1,y2); % 
                
            end  
        end  

        result(x1,x2)=average/sweight;  
    end  
end


