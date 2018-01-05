function [result] = computeWeighting(d, h, sigma, patchSize)
    %Implement weighting function from the slides
    %Be careful to normalise/scale correctly!
    result = exp(-max(d-2*sigma^2,0.0)/(h*h));
end