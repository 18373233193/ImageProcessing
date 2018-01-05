clear;
close all;
clc;

A = magic(5)

rows = [2 1 3];
cols = [2 4 4];

idx = sub2ind(size(A), rows, cols)

A(idx)