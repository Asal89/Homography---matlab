function [ mask, diff_matrix ] = create_mask( I1, I2, threshold )
% TODO: add decription
mask = zeros(size(I1,1), size(I1,2));

I1_gray = rgb2gray(I1);
I2_gray = rgb2gray(I2);

I1_gray = (1/max(I1_gray));

diff_matrix = abs(I1_gray - I2_gray);

[x,y] = find(diff_matrix < threshold);
linearInd = sub2ind(size(I1), x, y);
mask(linearInd) = 1;

end

