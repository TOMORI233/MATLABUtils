function B = shuffleData(A, dim)
% Shuffle N-D matrix A along specific dimension, with each slice shuffled
% independently.

nd = ndims(A);

if dim < 1 || dim > nd
    error('dim must be between 1 and ndims(A)');
end

% move target dim to the first dimension
perm = 1:nd;
perm([1, dim]) = [dim, 1];
A_perm = permute(A, perm);

sz_perm = size(A_perm); % size of current matrix (for inverse permuting)
len = sz_perm(1); % size of the dimension to be shuffled
num_blocks = prod(sz_perm(2:end)); % numel of the rest dimensions

% Generate random shuffled orders for each column
[~, idx] = sort(rand(len, num_blocks), 1);  % len x num_blocks

% Re-indexing
A_reshaped = reshape(A_perm, len, num_blocks);

% Shuffle
lin_idx = sub2ind([len, num_blocks], idx(:), repelem((1:num_blocks)', len, 1));
B_reshaped = A_reshaped(lin_idx);
B_perm = reshape(B_reshaped, sz_perm);

% Inverse permute
B = ipermute(B_perm, perm);

return;
end
