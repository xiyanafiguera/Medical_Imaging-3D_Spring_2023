clear 
clc

[v, f] = read_vtk('/Users/xiyana/Downloads/med-course/homeworks/hw3/input_data/lh.white.vtk');


%%%%%%%%%%%%% Task 2-1 %%%%%%%%%%%%%%%%%%%%

% Create sparse matrix 
mask_f_matrix = create_sparse_matrix(f);
[row_indices, col_indices, values] = find(mask_f_matrix);

% Compute edge lengths using Euclidean distances 
edge_lengths = sqrt(sum((v(row_indices,:) - v(col_indices,:)).^2, 2));

% Compute average length of edge
avg_edge_length = mean(edge_lengths);

% Compute Gaussian weights with mean 0 and sd as average length of edge
gaussian_weights = exp(-(edge_lengths.^2)/(2 * avg_edge_length^2))/(avg_edge_length*sqrt(2*pi));

% Update weights of the sparse adjacency matrix
mask_f_matrix(sub2ind(size(mask_f_matrix), row_indices, col_indices)) = gaussian_weights;
mask_f_matrix(sub2ind(size(mask_f_matrix), col_indices, row_indices)) = gaussian_weights;

% Set diagonal to 0
W = mask_f_matrix - diag(diag(mask_f_matrix));

% normalize
W = bsxfun(@rdivide, W, sum(W, 2)); 

size(W)


%%%% Function for creating the sparse matrix

function [mask_f_matrix] = create_sparse_matrix(f)
    
    len = size(f, 1);
    f_list = zeros(len * 6, 2);   
    
    for i=1:len
       
        vtx = f(i, :);
        f_list((i-1)*6+1, :) = [vtx(1), vtx(2)];
        f_list((i-1)*6+2, :) = [vtx(2), vtx(3)];
        f_list((i-1)*6+3, :) = [vtx(3), vtx(1)];
        f_list((i-1)*6+4, :) = [vtx(2), vtx(1)];
        f_list((i-1)*6+5, :) = [vtx(3), vtx(2)];
        f_list((i-1)*6+6, :) = [vtx(1), vtx(3)];
    end
    
    n = max(f_list, [], 'all') + 1;  % convert to matlab one-based indexing
    mask_f_matrix = sparse(f_list(:,1) + 1, f_list(:,2) + 1, 1, n, n);  % convert to matlab one-based indexing
    
end



