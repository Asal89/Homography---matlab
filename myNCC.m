function [ correlation_matrix ] = myNCC( f, g, window )
%TODO: add Summary of this function 
% f and g are input rgb images. window is a row vector represent dimensions of 
% the window - [row col]

% converting rgb images to gray:
double_f = im2double(rgb2gray(f));
double_g = im2double(rgb2gray(g));

% create averageing kernel:
h = ones(window(1), window(2)) / (window(1)*window(2));

% create summing kernel:
s = ones(window(1), window(2));

% filtering with h:
avarage_f = imfilter(double_f,h);
avarage_g = imfilter(double_g,h);

% normallize each pixel by it's block's average. each pixel coordinates
% are the upper-left corner of the block: 
normallized_f = double_f - avarage_f;
normallized_g = double_g - avarage_g;

% multuply pixelwise:
normallized_multiplication = normallized_f .* normallized_g;

% filltering with s. each pixel represent the normallized correlation uppon
% a window:
sum_normallized_multiplication = imfilter(normallized_multiplication,s);

% calculate std:
var_f = imfilter(normallized_f.*normallized_f ,s);
var_g = imfilter(normallized_g.*normallized_g ,s);
std = var_f .* var_g;

correlation_matrix = sum_normallized_multiplication ./ std;

end

