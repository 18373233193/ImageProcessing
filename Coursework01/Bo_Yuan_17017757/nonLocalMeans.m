function [result] = nonLocalMeans(I, sigma, h, patchSize, windowSize)

I = double(I); 

ss = windowSize;
ps = patchSize;

[m,n] = size(I);  
paddedImage = padarray(I, [ ss + ps, ss + ps], 'symmetric'); 
paddedV = padarray(I, [ ss, ss ], 'symmetric');  

average = zeros(m,n);  
sweight = zeros(m,n);  

for x = -ss : ss  
    for y = -ss : ss
        
        if(x == 0 && y == 0)  
            continue;  
        end
        
        % compute dist between two images
        distance = (paddedImage(1 + ss : end - ss, 1 + ss : end - ss) - ...
            paddedImage(1 + ss + x : end - ss + x, 1 + ss + y : end - ss + y)).^2; 
        
        % compute integral image
        ii = computeIntegralImage(distance);
        
        % from 1+ss to end-ss => original image
        % later it will be used to compute weight
        v = paddedV(1 + ss + x : end - ss + x, 1 + ss + y : end - ss + y); 
 
        % w's size is equal to oringinal image
        w = zeros(m,n);  
        
        for i = 1 : m  
            for j = 1 : n 
                
                i1 = i + ps + 1; 
                j1 = j + ps + 1; 
                
                d = evaluateIntegralImage(ii, i1, j1, ps);
                
                w(i,j) = computeWeighting(d, sigma, h, ps);
                
                sweight(i,j) = sweight(i,j) + w(i,j); 
                
                average(i,j) = average(i,j) + w(i,j) * v(i,j);  
                
            end  
        end  
          
    end  
end  
 
result = average./sweight;

result = uint8(result);

end
