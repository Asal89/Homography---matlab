function [ derivative_map ] = horizontal_derivative( I )
%TODO: add description
%note - can get rgb input image, as well as gray image

% check if rgb:
if ndims(I) == 3
    I = rgb2gray(I);
end

h = [-1,0,1];
derivative_map = imfilter(I,h);
    
end

