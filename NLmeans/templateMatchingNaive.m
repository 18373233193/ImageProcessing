function [offsetsRows, offsetsCols, distances] = templateMatchingNaive(paddedImage,row, col,...
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

[m,n] = size(paddedImage);

i_offset = row + patchSize;  
j_offset = col + patchSize; 
        
patchRef = paddedImage(i_offset-patchSize:i_offset+patchSize,j_offset-patchSize:j_offset+patchSize); % patch 1
        
%average=0;  
%sweight=0;
        
% search window  
x_min = max(i_offset - searchWindowSize, patchSize + 1);  
x_max = min(i_offset + searchWindowSize, m - 2*patchSize + patchSize);  
y_min = max(j_offset - searchWindowSize, patchSize + 1);  
y_max = min(j_offset + searchWindowSize, n - 2*patchSize + patchSize);

offsetsRows = zeros(x_max - x_min, y_max - y_min);
offsetsCols = zeros(x_max - x_min, y_max - y_min);
distances = zeros(x_max - x_min , y_max - y_min);

for x = x_min:x_max  
    for y = y_min:y_max  
                
        if(x == i_offset && y == j_offset) % ignore the central pixel 
            continue;  
        end  
                
        patch = paddedImage(x - patchSize : x + patchSize, y - patchSize : y + patchSize);% patch 2 
                
        %kernel=ones(2*patchSize+1,2*patchSize+1);  
        %kernel=kernel./((2*patchSize+1)*(2*patchSize+1));
                
        %Dist2=sum(sum((1/(2*patchSize+1^2)).*(patch_1 - patch_2)^2));%SSD 
        %Dist2=sum(sum(kernel.*(W1-W2).*(W1-W2)));%SSD 
        dist2 = sum(sum((ones(2*patchSize+1,2*patchSize+1)./((2*patchSize+1)*(2*patchSize+1))).*(patchRef-patch).*(patchRef-patch)));%SSD 
        
        distances(x-x_min+1, y-y_min+1) = dist2;
        offsetsRows(x-x_min+1, y-y_min+1) = x - i_offset;
        offsetsCols(x-x_min+1, y-y_min+1) = y - j_offset;
        
        %w = computeWeighting(Dist2, h, sigma, patchSize);
                
        %sweight=sweight+w;  %(C(p))
        %average=average+w*padded_image(x,y); % 
    end  
end 


end

