function [result] = computeWeighting(d, h, sigma, patchSize)
    %Implement weighting function from the slides
    %Be careful to normalise/scale correctly!
    dist = d/(2*patchSize+1)^2;
    result = exp(-max(dist-2*sigma^2,0.0)/(h*h));
end