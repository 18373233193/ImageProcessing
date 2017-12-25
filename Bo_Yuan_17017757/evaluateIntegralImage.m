function [patchSum] = evaluateIntegralImage(ii, row, col, patchSize)
% This function should calculate the sum over the patch centred at row, col
% of size patchSize of the integral image ii

ds = patchSize;
i1 = row;
j1= col;
patchSum = ii(i1+ds,j1+ds) + ii(i1-ds-1,j1-ds-1) - ii(i1+ds,j1-ds-1) - ii(i1-ds-1,j1+ds); 

%%
%{
%The reason of why minus 1 in j1-ds-1

A = [1,2,3;4,5,6;7,8,9]

A =

     1     2     3
     4     5     6
     7     8     9

B = integralImage(A) 

B =

     0     0     0     0
     0     1     3     6
     0     5    12    21
     0    12    27    45
%}


end