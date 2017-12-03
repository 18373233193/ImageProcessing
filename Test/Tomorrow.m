function DenoisedImg = Tomorrow(I,sigma,ds,Ds,h)  

[N1,N2] = size(I);

DenoisedImg = zeros(N1,N2); 

Vsym = padarray(I,[Ds+ds,Ds+ds],'symmetric','both');  

d2 = (2*ds+1)*(2*ds+1);

ST = cell(2*Ds+1);

for t1 = -Ds:Ds
    for t2 = -Ds:Ds
        %st = integralImgSqDiff(Vsym,Ds,ds,t1,t2); 
        
        Sd = zeros(N1+2*ds,N2+2*ds);
        
        Sd(1,1) = (Vsym(6,6)-Vsym(6-t1,6-t2))^2;

        for i1 = 2 : N1+2*ds
            x1 = i1+Ds;
            Y = 1+Ds; 
            Dist2 = (Vsym(x1,Y)-Vsym(x1-t1,Y-t2))^2;
            Sd(i1,1) = Dist2 + Sd(i1-1,1);
        end

        for i2 = 2 : N2+2*ds
            X = 1+Ds;
            x2 = i2+Ds;
            Dist2 = (Vsym(X,x2)-Vsym(X-t1,x2-t2))^2;
            Sd(1,i2) = Dist2 + Sd(1,i2-1);
        end

        for i1 = 2 : N1+2*ds
            for i2 = 2 : N2+2*ds
                x1 = i1+Ds;
                x2 = i2+Ds;
                Dist2 = (Vsym(x1,x2)-Vsym(x1-t1,x2-t2))^2;
                Sd(i1,i2) = Dist2 + Sd(i1-1,i2) + Sd(i1,i2-1) - Sd(i1-1,i2-1);
            end
        end
        
        ST{t1+Ds+1,t2+Ds+1} = Sd;
    end
end

for x1 = 1:N1  
    for x2 = 1:N2
        %patch 1 center : x1,x2
        
        i1 = x1 + Ds;
        i2 = x2 + Ds;
        
        W = ones(2*Ds+1,2*Ds+1);
        
        for y1 = i1-Ds:i1+Ds
            for y2 = i2-Ds:i2+Ds
                %patch 2 center : y1,y2
                
                t1 = y1 - (i1 - Ds) + 1;
                t2 = y2 - (i2 - Ds) + 1;
                
                q1 = x1 + ds;
                q2 = x2 + ds;
                
                %disp('--------->>>');
                %disp(q1);
                %disp(q2);
                
                Dist2 = ST{t1,t2}(q1+ds,q2+ds)+ST{t1,t2}(q1-ds,q2-ds)-ST{t1,t2}(q1+ds,q2-ds)-ST{t1,t2}(q1-ds,q2+ds); 
                Dist2 = Dist2/d2;
                
                W(y1,y2) = computeWeighting(Dist2, h, sigma, ds);
                
            end
            %disp('--------->>><<<<<<<<<');
        end 
        
        r = 0;
        s = 0;
        
        for y1 = i1-Ds:i1+Ds
            for y2 = i2-Ds:i2+Ds
                r = r + W(y1,y2)*Vsym(y1,y2);
                s = s + W(y1,y2);
            end
        end
        
        DenoisedImg(x1,x2) = r/s;
        
    end
end

end






