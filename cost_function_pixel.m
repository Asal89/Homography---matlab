function [ cost_map ] = cost_function_pixel( I1, I2 )
%TODO: add description

% set parameters:
lamda1 = 1;
lamda2 = 0;
lamda3 = 0;
threshold = 2;
% check if rgb:
if ndims(I1) == 3
    I1 = rgb2gray(I1);
end

if ndims(I2) == 3
    I2 = rgb2gray(I2);
end

% calculate costs:
c1 = abs(I1-I2);
c2 = abs(horizontal_derivative(I1) - horizontal_derivative(I2));
c3 = abs(vertical_derivative(I1) - vertical_derivative(I2));

c = lamda1*c1 + lamda2*c2 + lamda3*c3;

cost_map = zeros(size(I1,1), size(I1,2));
cost_map(c < threshold) = 1;
cost_map = cost_map.*I1;

end

