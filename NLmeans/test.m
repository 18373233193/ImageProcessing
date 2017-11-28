clear all

m = [5 2 5 2; 3 6 3 6; 5 2 5 2; 3 6 3 6];
%m = [5 2 5 2 3 6 3 6 5 2 5 2 3 6 3 6];

ii = computeIntegralImage(m);

r = evaluateIntegralImage(ii,1,1,2);