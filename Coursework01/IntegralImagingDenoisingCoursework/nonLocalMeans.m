function [result] = nonLocalMeans(I, sigma, h, patchSize, windowSize)

Ds = windowSize;
ds = patchSize;

[m,n]=size(I);  
PaddedImg = padarray(I,[Ds+ds,Ds+ds],'symmetric'); 
PaddedV = padarray(I,[Ds,Ds],'symmetric');  

average=zeros(m,n);  
sweight=average;  

for t1=-Ds:Ds  
    for t2=-Ds:Ds
        
        if(t1 == 0 && t2 == 0)  
            continue;  
        end
        
        % padded with ds (integral image)
        St = computeIntegralImage(PaddedImg,Ds,t1,t2);
        
        % from 1+Ds to end-Ds => original image
        % offset image
        v = PaddedV(1+Ds+t1:end-Ds+t1,1+Ds+t2:end-Ds+t2); 
 
        % w's size is equal to oringinal image
        w = zeros(m,n);  
        
        for i=1:m  
            for j=1:n 
                
                i1=i+ds+1; 
                j1=j+ds+1; 
                
                Dist2 = evaluateIntegralImage(St, i1, j1, ds);
                
                w(i,j) = computeWeighting(Dist2, h, sigma, ds);
                
                sweight(i,j) = sweight(i,j)+w(i,j);  
                average(i,j) = average(i,j)+w(i,j)*v(i,j);  
                
            end  
        end  
          
    end  
end  
 
result = average./sweight;

end