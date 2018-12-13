function [ cost_map ] = cost_function_NCC( intensity, horizontal_derivative, vertical_derivative, variance_map )
%TODO: add description
% note - inputs are NCC's maps with the same dimensions

gamma_intense = 1;
gamma_horizon = 1;
gamma_vertical = 1;
gamma_variance = -8;

cost_map = gamma_intense*intensity + gamma_horizon*horizontal_derivative + gamma_vertical*vertical_derivative ...
    + gamma_variance*variance_map;

end

