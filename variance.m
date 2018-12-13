function [ variance_map ] = variance( intensity, horizontal_derivative, vertical_derivative )
%TODO: add description
average = (1/3)*(intensity + horizontal_derivative + vertical_derivative);

intensity_diff = (intensity - average).^2;
horizontal_derivative_diff = (horizontal_derivative - average).^2;
vertical_derivative_diff = (vertical_derivative - average).^2;

cov = (1/3)*(intensity_diff + horizontal_derivative_diff + vertical_derivative_diff);
variance_map = sqrt(cov);

end

