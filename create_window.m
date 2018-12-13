function [ rect ] = create_window( center_x, center_y, size_x, size_y )
%TODO: add decription 

xmin = center_x - floor(size_x/2);
ymin = center_y - floor(size_y/2);
xmax = center_x + floor(size_x/2);
ymax = center_y + floor(size_y/2);
width = xmax - xmin;
height = ymax - ymin;

rect = [xmin, ymin, width, height];

end

