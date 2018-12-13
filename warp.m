function [ J ] = warp( I, H )
%TODO: add description

% store all I's pixels in vectors:
[y,x] = find(I(:,:,1) >= 0); 

% move to homog coordinate:
uvw = [x'; y'; ones(1, length(x))];

% transform to reff image:
new_uvw = H * uvw;

% back to pixels
new_xy = bsxfun(@times, new_uvw, 1./new_uvw(3,:));
new_x = new_xy(1,:);
new_y = new_xy(2,:);

% calculate displacment:
flow_x = (new_x' - x);
flow_y = (new_y' - y);

% create displacment matrix:
flow_matrix_x = reshape(flow_x, size(I,1), size(I,2));
flow_matrix_y = reshape(flow_y, size(I,1), size(I,2));
Displacement_matrix(:,:,1) = flow_matrix_x;
Displacement_matrix(:,:,2) = flow_matrix_y;

% warp:
J = imwarp(I, Displacement_matrix);
end

