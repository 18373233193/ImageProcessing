function [result] = nonLocalMeans(image, sigma, h, patchSize, windowSize)

image = double(image);  
[m,n] = size(image);

result = zeros(m,n);

padded_image = padarray(image, [patchSize,patchSize], 'symmetric'); 

for i=1:m  
    for j=1:n
        
        i_offset = i + patchSize;  
        j_offset = j + patchSize; 
        
        patch_1 = padded_image(i_offset-patchSize:i_offset+patchSize,j_offset-patchSize:j_offset+patchSize); % patch 1
        
        average=0;  
        sweight=0;
        
        % search window  
        x_min = max(i_offset - windowSize, patchSize + 1);  
        x_max = min(i_offset + windowSize, m + patchSize);  
        y_min = max(j_offset - windowSize, patchSize + 1);  
        y_max = min(j_offset + windowSize, n + patchSize);
        
        for x = x_min:x_max  
            for y = y_min:y_max  
                
                if(x == i_offset && y == j_offset) %???????? 
                    continue;  
                end  
                
                patch_2 = padded_image(x - patchSize : x + patchSize, y - patchSize : y + patchSize);% patch 2 
                
                %kernel=ones(2*patchSize+1,2*patchSize+1);  
                %kernel=kernel./((2*patchSize+1)*(2*patchSize+1));
                
                %Dist2=sum(sum((1/(2*patchSize+1^2)).*(patch_1 - patch_2)^2));%SSD 
                %Dist2=sum(sum(kernel.*(W1-W2).*(W1-W2)));%SSD 
                Dist2=sum(sum((ones(2*patchSize+1,2*patchSize+1)./((2*patchSize+1)*(2*patchSize+1))).*(patch_1-patch_2).*(patch_1-patch_2)));%SSD 
                
                w = computeWeighting(Dist2, h, sigma, patchSize);
                
                sweight=sweight+w;  %(C(p))
                average=average+w*padded_image(x,y); % 
            end  
        end 
             
        result(i,j)=average/sweight; 
    end
end


end
