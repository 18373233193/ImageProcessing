function neighbors = calcAdjancency( Mask )

[height, width]      = size(Mask);
[row_mask, col_mask] = find(Mask);

% sparse Create sparse matrix.
% sparse(indexX,indexY,value)
neighbors = sparse(length(row_mask), length(row_mask), 0);

% the linear indexs of all the pixels in the mask
roi_idxs = sub2ind([height, width], row_mask, col_mask);

for k = 1:size(row_mask, 1), %traverse all the pixels in the mask
    %4 the neighbors of [row_mask(k), col_mask(k)]
    connected_4 = [row_mask(k), col_mask(k)-1;%left
                   row_mask(k), col_mask(k)+1;%right
                   row_mask(k)-1, col_mask(k);%top
                   row_mask(k)+1, col_mask(k)];%bottom
    
    % the linear indexs of the 4 neighbors           
    ind_neighbors = sub2ind([height, width], connected_4(:, 1), connected_4(:, 2));
    
    %?????? i = ismembc2(t, X)???t?X???????X???????????
    for neighbor_idx = 1: 4, %number of neighbors, 
        adjacent_pixel_idx =  ismembc2(ind_neighbors(neighbor_idx), roi_idxs);
        if (adjacent_pixel_idx ~= 0)
%         adjacent_pixel_idx =  ismember(ind_neighbors(neighbor_idx), roi_idxs); 
%         disp(adjacent_pixel_idx);
%         if (adjacent_pixel_idx)
            neighbors(k, adjacent_pixel_idx) = 1;
        end
    end 

end
end