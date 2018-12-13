function [interpulated_y,std,relevant_uv] = Y_interpulate(XY,uv)
% TDOD: add description
% XY camera coordinate points, size 2xn
% interpulated_y scalar that represent the hight
% note - distance unit are given in [mm]

% set parameters:
std_threshold = 250;

y_vector = XY(2,:);
relevant_u = uv(1,:);
relevant_v = uv(2,:);
mean_y = mean(y_vector);
std_vector = sqrt((XY(2,:) - mean_y).^2);

y_vector(find(std_vector >= std_threshold)) = [];
relevant_u(find(std_vector >= std_threshold)) = [];
relevant_v(find(std_vector >= std_threshold)) = [];

relevant_uv = [relevant_u; relevant_v];

interpulated_y = mean(y_vector);
std = sqrt(mean((y_vector - interpulated_y).^2));
end

