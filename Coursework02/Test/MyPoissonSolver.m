function Targ_filled = MyPoissonSolver(Targ, MaskTarg, AdjacencyMat, TargBoundry)

%% params for Conjagant gradient solver

% find all the nonzero pixels in the mask
[row_mask, col_mask] = find(MaskTarg);

% get the boundary array (it includes all the positions of the boundary point)
boundary = TargBoundry{1};

% ???
Np_boundary  = zeros(size(boundary, 1), 1);
% ???
sum_boundary = zeros(size(boundary, 1), 1);

% this loop will cope with 
for k = 1:size(boundary, 1)
    %Calc Neighbour outside - at most 4 but unlikely - usually 1 for 4
    %connected
    p = boundary(k, :);
    
    x = p(1);
    y = p(2);
    
    Np_boundary(k) = sum(sum(~MaskTarg(x-1:x+1, y-1:y+1)&[0 1 0;1 1 1; 0 1 0]));
    
    mat = Targ(x-1:x+1, y-1:y+1);
    
    sum_boundary(k) = sum(mat(~MaskTarg(x-1:x+1, y-1:y+1)&[0 1 0;1 1 1; 0 1 0]));
    
end

% 
num_of_hole_pixels = size(row_mask, 1);

%{
LIA = ismember(A,B,'rows') for matrices A and B with the same number
    of columns, returns a vector containing true where the rows of A are
    also rows of B and false otherwise.

    [LIA,LOCB] = ismember(A,B,'rows') also returns a vector LOCB containing
    the lowest absolute index in B for each row in A which is a member
    of B and 0 if there is no such index.
%}
[is_boundary, boundary_list_idx] = ismember([row_mask, col_mask], boundary, 'rows');

A = sparse(diag(ones(1, num_of_hole_pixels)*4));

%subtract neighbor connections (Laplace with a 4-conn neighborhood)
A = A - AdjacencyMat;

%now we create b
%we assume that Targ has Gx+Gy pasted within the hole defined by MaskTarg

%{
linearInd = sub2ind(matrixSize, rowSub, colSub) returns the linear index equivalents 
to the row and column subscripts rowSub and colSub for a matrix of size matrixSize. 
The matrixSize input is a 2-element vector that specifies the number of rows and columns 
in the matrix as [nRows, nCols]. 
The rowSub and colSub inputs are positive, whole number scalars or vectors 
that specify one or more row-column subscript pairs for the matrix.
%}

b = Targ(sub2ind(size(Targ), row_mask, col_mask));
% b = zeros(num_of_hole_pixels, 1);
boundary_list_idx(boundary_list_idx==0) = [];%remove zero entries
b(is_boundary) = b(is_boundary) + sum_boundary(boundary_list_idx);

%Starting point
%x0 = mean(sum_boundary./Np_boundary)*ones(num_of_hole_pixels, 1);
%Solve using conjagant gradient descent
%X = cgs(sparse(A), b, tolerance, max_iter, [], [], x0);

X = A\b;

Targ_filled = Targ;
%fill in mask with result, clipp with zero from below to prevent small
%negative numbers
Targ_filled(sub2ind(size(Targ), row_mask, col_mask)) = max(X, 0);

end

