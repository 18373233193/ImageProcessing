clear;
clc;

mask = [0 0 0 0 0 0;0 0 1 1 1 0;0 1 1 1 0 0;  0 1 1 0 0 0 ; 0 0 1 1 0 0 ;0 0 0 0 0 0];
[row,col] = find(mask);

start_pos = [min(col), min(row)]; 
end_pos   = [max(col), max(row)];
frame_size  = end_pos - start_pos + 1;