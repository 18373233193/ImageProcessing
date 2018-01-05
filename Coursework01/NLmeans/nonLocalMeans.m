function [result] = nonLocalMeans(image, sigma, h, patchSize, searchWindowSize)

image = double(image);  
[m,n] = size(image);

result = zeros(m,n);

paddedImage = padarray(image, [patchSize,patchSize], 'symmetric'); 


for i=1:m  
    for j=1:n
        
        average=0;  
        sweight=0;

        [offsetsRows, offsetsCols, distances] = templateMatchingNaive(paddedImage, i, j, patchSize, searchWindowSize);
        
        x_min = max(i + patchSize - searchWindowSize, patchSize + 1);  
        x_max = min(i + patchSize + searchWindowSize, m + patchSize);  
        y_min = max(j + patchSize - searchWindowSize, patchSize + 1);  
        y_max = min(j + patchSize + searchWindowSize, n + patchSize);
        
        %w = zeros(size(distances));
        w = computeWeighting(distances, h, sigma, patchSize);
        w(1,1) = 0;

        
        sweight = sweight + sum(w(:));
       
        %sweight=sweight+w;  %(C(p))
        
        temp = w .* paddedImage(x_min:x_max,y_min:y_max);
        
        average = average + sum(sum(temp)); % 
        
        %result(i,j)= sum(sum(temp./w)); 
        result(i,j) = average/sweight;        
        
    end
end


end
