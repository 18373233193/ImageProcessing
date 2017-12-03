function [result] = nonLocalMeans(image, sigma, h, patchSize, windowSize)

Ds = windowSize;
ds = patchSize;

I = rgb2gray(image);
I = double(I); 

[m,n]=size(I);  
PaddedImg = padarray(I,[Ds+ds+1,Ds+ds+1],'symmetric');  % why plus 1 ??
PaddedV = padarray(I,[Ds,Ds],'symmetric');  

average=zeros(m,n);  
sweight=average;  

for t1=-Ds:Ds  
    for t2=-Ds:Ds
        
        if(t1 == 0 && t2 == 0)  
            continue;  
        end
        
        St = computeIntegralImage(PaddedImg,Ds,t1,t2); 
        % padded with ds (integral image)
        
        v = PaddedV(1+Ds+t1:end-Ds+t1,1+Ds+t2:end-Ds+t2); % offset image
        % from 1+Ds to end-Ds => original image
        
        w = zeros(m,n); 
        % w's size is equal to oringinal image
        
        for i=1:m  
            for j=1:n 
                
                i1=i+ds+1; %??? Why plus 1 ??
                j1=j+ds+1; %??? 
                
                %Dist2=St(i1+ds,j1+ds)+St(i1-ds-1,j1-ds-1)-St(i1+ds,j1-ds-1)-St(i1-ds-1,j1+ds);  %??? Why minus 1 ??
                Dist2 = evaluateIntegralImage(St, i1, j1, ds);
                
                w(i,j) = computeWeighting(Dist2, h, sigma, ds);
                
                sweight(i,j)=sweight(i,j)+w(i,j);  
                average(i,j)=average(i,j)+w(i,j)*v(i,j);  
                
            end  
        end  
          
    end  
end  
 
result = average./sweight;

result = uint8(result);

end