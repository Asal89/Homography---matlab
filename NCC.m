function [ ncc ] = NCC( f, g, windowsize )
%TODO: add Summary of this function 
% f and g are input rgb images. window is a row vector represent dimensions of 
% the window - [row col]

threshold = 0.5;


% converting rgb images to gray (with edges):
double_f = 255*im2double(f);
double_g = 255*im2double(g);

% create averageing kernel:
%h = ones(windowsize, 1) ./ windowsize;
h = ones(windowsize, windowsize) ./ (windowsize^2);

% calc std and mean:
% meanf = colfilter(colfilter(double_f,h).',h).';
% meang = colfilter(colfilter(double_g,h).',h).';
meanf = imfilter(double_f, h);
meang = imfilter(double_g, h);

sqr_f = double_f.*double_f;
sqr_g = double_g.*double_g;


% mean_sqr_f = colfilter(colfilter(sqr_f,h).',h).';
% mean_sqr_g = colfilter(colfilter(sqr_g,h).',h).';
mean_sqr_f = imfilter(sqr_f, h);
mean_sqr_g = imfilter(sqr_g, h);


var_f = mean_sqr_f - meanf.*meanf;
var_g = mean_sqr_g - meang.*meang;

% create logical matrixes correspond to where var_f greater then 0:
positive_f = bsxfun(@gt, var_f, 0);
positive_g = bsxfun(@gt, var_g, 0);

%only apply sqrt to positive variances, set negative ones to below
%threshold so they are ignored
std_f = sqrt(positive_f .* var_f) + (1 - positive_f) * threshold / 10;
std_g = sqrt(positive_g .* var_g) + (1 - positive_g) * threshold / 10;

% calc NCC:
f_g = double_f.*double_g;
meanf_meang = meanf.*meang;
%mean_fg = colfilter(colfilter(f_g,h).',h).';
mean_fg = imfilter(f_g, h);
stdprod = std_f.*std_g;
ncc = (mean_fg - meanf_meang) ./ stdprod;


end

