function [offsetsRows, offsetsCols, distances] = templateMatchingNaive(Vsym, row, col,...
    patchSize, searchWindowSize)
% This function should for each possible offset in the search window
% centred at the current row and col, save a value for the offsets and
% patch distances, e.g. for the offset (-1,-1)
% offsetsRows(1) = -1;
% offsetsCols(1) = -1;
% distances(1) = 0.125;

% The distance is simply the SSD over patches of size patchSize between the
% 'template' patch centred at row and col and a patch shifted by the
% current offset

%REPLACE THIS

Ds = searchWindowSize;
ds = patchSize;

offsetsRows = zeros(2*Ds+1);
offsetsCols = zeros(2*Ds+1);
distances = zeros(2*Ds+1);

i = row + Ds + ds;
j = col + Ds + ds;
        
patch1 = Vsym(i-ds : i+ds, j-ds : j+ds);

count = 1;

for y1 = i - Ds : i + Ds
    for y2 = j - Ds : j + Ds
                
        if(y1 == i && y2 == j)
            distances(count) = 0; 
        else        
            patch2 = Vsym(y1-ds : y1+ds, y2-ds : y2+ds);
                
            dist2=sum(sum((patch1-patch2).^2));
        
            distances(count) = dist2;
        end
        
        offsetsRows(count) = y1;
        offsetsCols(count) = y2;
                
        count = count+1;
    end
end

end