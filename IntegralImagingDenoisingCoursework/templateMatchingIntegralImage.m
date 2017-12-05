function [offsetsRows, offsetsCols, distances] = templateMatchingIntegralImage(Vsym, ii,row,...
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

x1 = row;
x2 = col;

i1 = x1+Ds+ds+1;
j1 = x2+Ds+ds+1;

count = 1;

for y1 = i1 - Ds : i1 + Ds
    for y2 = j1 - Ds : j1 + Ds
                
        if(y1 == i1 && y2 == j1)
            distances(count) = 0;
        else
            p = y1 - (i1 - Ds) + 1;
            q = y2 - (j1 - Ds) + 1; 
                
            f1=x1+ds+1;
            g1=x2+ds+1;
            
            distances(count) = evaluateIntegralImage(ii{p,q}, f1, g1, ds);
        end
        
        offsetsRows(count) = y1-1;
        offsetsCols(count) = y2-1;
                
        count = count+1;

    end
end

end