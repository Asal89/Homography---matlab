function [ xy ] = pixels_projection( XYZ, projection_matrix )
% pixel_projection returns the projected location matrix (2xN)
% when each row represent singel pixel. input args are XYZ(3XN) - matrix of  
% 3d points when each row represents single point, and projection_matrix
% (3X4)

XYZhomog = cat(1, XYZ, ones(1, size(XYZ,2)));
xyw = projection_matrix * XYZhomog;
xy = bsxfun(@times, xyw(1:2,:), 1./xyw(:,3));


end

