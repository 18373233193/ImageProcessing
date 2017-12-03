function [patchSum] = evaluateIntegralImage(ii, row, col, patchSize)
% This function should calculate the sum over the patch centred at row, col
% of size patchSize of the integral image ii

ds = patchSize;
i1 = row;
j1= col;
patchSum = ii(i1+ds,j1+ds)+ii(i1-ds-1,j1-ds-1)-ii(i1+ds,j1-ds-1)-ii(i1-ds-1,j1+ds); 

end