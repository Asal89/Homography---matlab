

% clear all; close all;

% load images:
left_image = imread('left/left_3_2018-09-05-17-33-23-261.jpg'); 
right_image = imread('right/right_3_2018-09-05-17-33-23-261.jpg');

% load stereo prameters from matlab calibration file:
load ('stereoParams.mat');
left_params = stereoParams.CameraParameters1; % the main camera
right_params = stereoParams.CameraParameters2;

% define plane: 
plane.normal = [0,0,-1]';
plane.distance = 6.18*1000; %mm 
 
% calculate homography:
H = create_homography_mat(left_params.IntrinsicMatrix, right_params.IntrinsicMatrix, ...
    stereoParams.RotationOfCamera2, stereoParams.TranslationOfCamera2, plane.distance...
    , plane.normal);

% warping:
warped_image = warp(right_image, H);

% show:
figure(2)
hold on
title('warped right on original left');
imshowpair(left_image, warped_image,'blend','Scaling','joint');

figure(3)
imshow(left_image);

while true
   
   [xi,yi] = getpts(figure(3));
   center_x = xi(1);
   center_y = yi(1);
   rect_size_x = 30;
   rect_size_y = 30;
   
   rect = create_window( center_x, center_y, rect_size_x, rect_size_y );
   RGB = insertShape(left_image,'Rectangle',rect,'LineWidth',5);
   imshow(RGB);
   
   [corr_matrix, max_corr] = find_correlation(left_image, warped_image, rect);   
   %title(['correlation is: ' num2str(max_corr)]);
   title({['for d = ',num2str(plane.distance/1000),' meters - correlation: ',num2str(max_corr)]})
   hold on
   
end

