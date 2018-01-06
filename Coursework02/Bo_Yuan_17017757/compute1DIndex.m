function result = compute1DIndex(mask)

%create a matrix, its size is equal to the mask
[m,n] = size(mask);
matrix = zeros();

index = 1;

for i = 1:m
    for j = 1:n
        
        % if the point is the one which needs to compute (value is equal to 1)
        if mask(i,j) == 1 
            
            % give the point a 1d index
            matrix(i,j) = index; 
            
            index=index+1;
        end
    end
end

result = matrix;

end