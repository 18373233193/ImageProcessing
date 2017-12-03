function [offsetsRows, offsetsCols, distances] = templateMatchingIntegralImage(paddedImage,row,...
    col,patchSize, searchWindowSize)
% This function should for each possible offset in the search window
% centred at the current row and col, save a value for the offsets and
% patch distances, e.g. for the offset (-1,-1)
% offsetsX(1) = -1;
% offsetsY(1) = -1;
% distances(1) = 0.125;

% The distance is simply the SSD over patches of size patchSize between the
% 'template' patch centred at row and col and a patch shifted by the
% current offset

% This time, use the integral image method!
% NOTE: Use the 'computeIntegralImage' function developed earlier to
% calculate your integral images
% NOTE: Use the 'evaluateIntegralImage' function to calculate patch sums

%REPLACE THIS

Ds = searchWindowSize;

ST = cell(2*Ds+1);

for t1 = -Ds:Ds
    for t2 = -Ds:Ds
        st = integralImgSqDiff(paddedImage,Ds,t1,t2);  
        ST{t1+Ds+1,t2+Ds+1} = st;
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