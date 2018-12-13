function [ ix, iy, filtered ] = threshold_filter( I, threshold )
%TODO: add description
filtered = zeros(size(I,1), size(I,2));
filtered(I > threshold) = 1; 
filtered = filtered .* I;
[iy,ix] = find(I > threshold); %note! [iy, ix] = [row, col]


end

