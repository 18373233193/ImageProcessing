function DenoisedImg = FNLM(I,ds,Ds,h)  

[N1,N2] = size(I);

DenoisedImg = zeros(N1,N2); 

W = zeros(N1,N2);

Vsym = padarray(I,[Ds+ds,Ds+ds],'symmetric','both');  

d2=(2*ds+1)^2;

ST = cell(2*Ds+1);

for t1 = -Ds:Ds
    for t2 = -Ds:Ds
        st = integralImgSqDiff(Vsym,Ds,t1,t2);  
        ST{t1+Ds+1,t2+Ds+1} = st;
    end
end

for x1 = 1+Ds+ds:N1+Ds+ds  
    for x2 = 1+Ds+ds:N2+Ds+ds
        %patch 1 center : x1,x2
        for y1 = x1-Ds:x1+Ds
            for y2 = x2-Ds:x2+Ds
                %patch 2 center : y1,y2
                
                t1 = - (x1 - y1) + Ds + 1;
                t2 = - (x2 - y2) + Ds + 1;
                
                X1 = x1 - Ds;
                X2 = x2 - Ds;
                
                %Dist2 = ST{t1,t2}(x1+ds,x2+ds)+ST{t1,t2}(x1-ds,x2-ds)-ST{t1,t2}(x1+ds,x2-ds)-ST{t1,t2}(x1-ds,x2+ds);
                Dist2 = ST{t1,t2}(X1+ds,X2+ds)+ST{t1,t2}(X1-ds,X2-ds)-ST{t1,t2}(X1+ds,X2-ds)-ST{t1,t2}(X1-ds,X2+ds); 
                Dist2 = Dist2/d2;
                
                %W = computeWeighting(Dist2, h, 3, ds);
                W = exp(-Dist2/(h^2)); 
                
            end
        end
        
        r = 0;
        s = 0;
        
        for y1 = x1-Ds:x1+Ds
            for y2 = x2-Ds:x2+Ds
                r = r + W*Vsym(y1,y2);
                s = s + W;
            end
        end
        
        DenoisedImg(x1-Ds-ds,x2-Ds-ds) = r/s;
        
    end
end

end


function Sd = integralImgSqDiff(PaddedImg,Ds,t1,t2)  
%PaddedImg: 
%Ds:search window
%(t1,t2):offsets 
%Sd: integral image
[m,n]=size(PaddedImg);  
m1=m-2*Ds;  %
n1=n-2*Ds;  %
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
