function [offsetsRows, offsetsCols, distances] = templateMatchingIntegralImage(Vsym, row,...
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

Ds = searchWindowSize;
ds = patchSize;

offsetsRows = zeros(2*Ds+1);
offsetsCols = zeros(2*Ds+1);
distances = zeros(2*Ds+1);

ii = cell(2*Ds+1);

for t1=-Ds:Ds  
    for t2=-Ds:Ds
        x = t1+Ds+1;
        y = t2+Ds+1;
        ii{x,y} = computeIntegralImage(Vsym,Ds,t1,t2);
    end
end

i1=row+ds+1; %??? Why plus 1 ??
j1=row+ds+1; %??? 
        
count = 1;

i = row + Ds + ds;
j = col + Ds + ds;

for y1 = i - Ds : i + Ds
    for y2 = j - Ds : j + Ds
        
        q = y1 - (i - Ds) + 1;
        p = y2 - (j - Ds) + 1; 
                    
        distances(count) = evaluateIntegralImage(ii{q,p}, i1, j1, patchSize);
        
        offsetsRows(count) = y1;
        offsetsCols(count) = y2;
                
        count = count+1;
    end
end

end