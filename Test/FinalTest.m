function [result] = FinalTest(I,sigma,ds,Ds,h)  

[m,n]=size(I);  
PaddedImg = padarray(I,[Ds+ds,Ds+ds],'symmetric');  % why plus 1 ??
PaddedV = padarray(I,[Ds,Ds],'symmetric');  

average=zeros(m,n);  
sweight=average;  

d2=(2*ds+1)^2; 

for t1=-Ds:Ds  
    for t2=-Ds:Ds
        
        if(t1 == 0 && t2 == 0)  
            continue;  
        end
        
        St = integralImgSqDiff(PaddedImg,Ds,t1,t2); 
        % padded with ds (integral image)
        
        v = PaddedV(1+Ds+t1:end-Ds+t1,1+Ds+t2:end-Ds+t2); % offset image
        % from 1+Ds to end-Ds => original image
        
        w = zeros(m,n); 
        % w's size is equal to oringinal image
        
        for i=1:m  
            for j=1:n 
                
                i1=i+ds; %??? Why plus 1 ??
                j1=j+ds; %??? 
                
                Dist2=St(i1+ds,j1+ds)+St(i1-ds,j1-ds)-St(i1+ds,j1-ds)-St(i1-ds,j1+ds);  %??? Why minus 1 ??
                Dist2=Dist2/d2;
                
                w(i,j) = computeWeighting(Dist2, h, sigma, ds);
                sweight(i,j)=sweight(i,j)+w(i,j);  
                average(i,j)=average(i,j)+w(i,j)*v(i,j);  
                
            end  
        end  
          
    end  
end  
 
result = average./sweight; 

end


function Sd = integralImgSqDiff(PaddedImg,Ds,t1,t2)  

[m,n]=size(PaddedImg);  
m1=m-2*Ds;  
n1=n-2*Ds;  
Sd=zeros(m1,n1);  
Dist2=(PaddedImg(1+Ds:end-Ds,1+Ds:end-Ds)-PaddedImg(1+Ds+t1:end-Ds+t1,1+Ds+t2:end-Ds+t2)).^2;  

for i=1:m1  
    for j=1:n1  
         if i==1 && j==1  
             Sd(i,j)=Dist2(i,j);  
         elseif i==1 && j~=1  
             Sd(i,j)=Sd(i,j-1)+Dist2(i,j);   
         elseif i~=1 && j==1  
             Sd(i,j)=Sd(i-1,j)+Dist2(i,j);  
         else  
             Sd(i,j)=Dist2(i,j)+Sd(i-1,j)+Sd(i,j-1)-Sd(i-1,j-1);  
         end  
     end  
end

end