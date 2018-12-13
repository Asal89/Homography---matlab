function [ filtered_cost_map_variance ] = variance_filter( cost_map, variance_map )
%TODO: add description
%TODO: demolish this function if it unnecessary
% note that both inputs has to be with the same dimensions
filtered_cost_map_variance = zeros(size(cost_map,1), size(cost_map,2));
filtered_cost_map_variance(variance_map < 0.15) = 1;
filtered_cost_map_variance = filtered_cost_map_variance .* cost_map;

end

