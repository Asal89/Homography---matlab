%%  main script - pixelwise:

clear all; close all;

% set parmaeters:
left_image = imread('left/left_3_2018-09-05-17-33-23-261.jpg'); % the main camera
right_image = imread('right/right_3_2018-09-05-17-33-23-261.jpg');
load('stereoParams.mat', 'stereoParams')
window_size = 15; % NCC window
distance = 1.9; % for homography calculation; %1.9 

% load stereo prameters from matlab calibration file:
left_params = stereoParams.CameraParameters1; 
right_params = stereoParams.CameraParameters2;

% define plane: 
plane.normal = [0,0,-1]';
plane.distance = distance*1000; %mm 

 
% calculate homography:
H = create_homography_mat(left_params.IntrinsicMatrix, right_params.IntrinsicMatrix, ...
    stereoParams.RotationOfCamera2, stereoParams.TranslationOfCamera2, plane.distance...
    , plane.normal);

% warping:
warped_image = warp(right_image, H);

% calculate cost for each pixel:
cost_map = cost_function_pixel(left_image, warped_image);

imshow(cost_map)
