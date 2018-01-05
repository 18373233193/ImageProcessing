function [result] = Damn(image, sigma, h, patchSize, searchWindowSize)

[m,n] = size(image);

result = zeros(m,n);

%ds patch size
paddedImage = padarray(image, [patchSize,patchSize], 'symmetric'); 

kernel=ones(2*patchSize+1,2*patchSize+1);  
kernel=kernel./((2*patchSize+1)*(2*patchSize+1));

for i=1:m  
    for j=1:n
        
        i1 = i + patchSize;  
        j1 = j + patchSize; 
        
        patch1 = paddedImage(i1-patchSize : i1+patchSize, j1-patchSize : j1+patchSize); % patch 1
        
        average=0;  
        sweight=0;
        
        % search window  
        xMin = max(i1 - searchWindowSize, patchSize + 1);  
        xMax = min(i1 + searchWindowSize, m + patchSize);  
        yMin = max(j1 - searchWindowSize, patchSize + 1);  
        yMax = min(j1 + searchWindowSize, n + patchSize);
        
        for x = xMin:xMax  
            for y = yMin:yMax  
                
                if(x == i1 && y == j1) %???? 
                    continue;  
                end  
                
                %patch2 = paddedImage(x - patchSize : x+patchSize, y - patchSize : y + patchSize);% patch window 2 
                patch2 = paddedImage(x - patchSize : x + patchSize, y - patchSize : y + patchSize);% patch 2 

                %Dist2=sum(sum(kernel.*(patch1-patch2).*(patch1-patch2)));%SSD 
                Dist2=sum(sum(kernel.*(patch1-patch2).*(patch1-patch2)));%SSD 
 
                
                %w = computeWeighting(Dist2, h, sigma, patchSize); 
                w = computeWeighting(Dist2, h, sigma, patchSize);
                
                %sweight=sweight+w;  %(C(p))
                sweight=sweight+w;  %(C(p))
                
                %average=average+w*paddedImage(x,y); % 
                average=average+w*paddedImage(x,y); % 
            end  
        end 
        %result(i,j)=average/sweight;     
        result(i,j)=average/sweight; 
    end
end

