function [offsetsRows, offsetsCols, distances] = templateMatchingIntegralImage(iiCell,row,...
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

ss = searchWindowSize;
ps = patchSize;

% three matrix for offsets and distances, the size is equal to the size of search window
offsetsRows = zeros(2*ss + 1);
offsetsCols = zeros(2*ss + 1);
distances = zeros(2*ss + 1);

% i and j is the point in the non-padded image
% cuz the Coordinate System has changed by padding
i = row + ss + ps + 1;
j = col + ss + ps + 1;

count = 1;

for x = i - ss : i + ss
    for y = j - ss : j + ss
                
        if(x == i && y == j)
            distances(count) = 0; % they are the same point, ignore that
        else
            % p and q are the index of the cell which stores all the integral images 
            % x and y are the index in a search window which the center is i and j
            % making sure that p and q is from 1 to 2*ss+1 (search window size)
            p = x - (i - ss) + 1;
            q = y - (j - ss) + 1; 
            
            %t1 and t2 are the point in the integral image, using t1 and t2 to find the distance 
            t1 = row + ps + 1;
            t2 = col + ps + 1;
            
            distances(count) = evaluateIntegralImage(iiCell{p,q}, t1, t2, ps);
        end
        
        offsetsRows(count) = x - 1;
        offsetsCols(count) = y - 1;
                
        count = count + 1;

    end
end

end