function [patchSum] = evaluateIntegralImage(ii, row, col, patchSize)
% This function should calculate the sum over the patch centred at row, col
% of size patchSize of the integral image ii

%REPLACE THIS!

patchSum= ii(row,col)+ii(row+patchSize,col+patchSize)-ii(row,col+patchSize)-ii(row+patchSize,col);

end