function [ corr_matrix, max_corr ] = find_correlation( I1, I2, rect )
%TODO: add description

template_1 = imcrop(I1, rect);
template_2 = imcrop(I2, rect);

corr_matrix = normxcorr2(rgb2gray(template_1), rgb2gray(template_2));
center_x = floor(size(corr_matrix,1)/2) + 1;
center_y = floor(size(corr_matrix,2)/2) + 1;
max_corr = corr_matrix(center_x, center_y);

end

