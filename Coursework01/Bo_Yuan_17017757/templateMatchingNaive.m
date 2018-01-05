function [offsetsRows, offsetsCols, distances] = templateMatchingNaive(paddedImage, row, col,...
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

ss = searchWindowSize;
ps = patchSize;

% three matrix for offsets and distances, the size is equal to the size of search window
offsetsRows = zeros(2*ss + 1);
offsetsCols = zeros(2*ss + 1);
distances = zeros(2*ss + 1);

% i and j is the point in the non-padded image
% cuz the Coordinate System has changed by padding
i = row + ss + ps;
j = col + ss + ps;
        
patch1 = paddedImage(i-ps : i+ps, j-ps : j+ps);

count = 1;

for y1 = i - ss : i + ss
    for y2 = j - ss : j + ss
                
        if(y1 == i && y2 == j)
            distances(count) = 0; % they are the same point, ignore that
        else        
            patch2 = paddedImage(y1-ps : y1+ps, y2-ps : y2+ps);
                
            dist2 = sum(sum((patch1-patch2).^2));
        
            distances(count) = dist2;
        end
        
        offsetsRows(count) = y1;
        offsetsCols(count) = y2;
                
        count = count+1;
    end
end

end