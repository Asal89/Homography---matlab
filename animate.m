
clear all; close all;
% set parmaeters:
left_image = imread('/home/jetski/Documents/Asaf/plane/data/35/set1/35mm_pishpash_long/left_303_2018-11-15-09-48-38-226.jpg'); % the main camera
right_image = imread('/home/jetski/Documents/Asaf/plane/data/35/set1/35mm_pishpash_long/right_303_2018-11-15-09-48-38-225.jpg');
load('/home/jetski/Documents/Asaf/plane/data/35/set1/stereoParams35.mat', 'stereoParams')
window_size = 15; % NCC window
threshold = 1.8;
minimum_distance = 40;
maximum_distance = 50;
distance_delta = 2;


% create distance vector:
% distance_vector = [minimum_distance:distance_delta:maximum_distance];
distance_vector = [7 10 13 15 20 25 30 35 40];

% crate color vector:
% color_vector = rand(1,3, length(distance_vector));
color_vector = [0 0 0.6235; 0 0 1; 0 0.3098 1; 0 0.5608 1; 0.1843 1 0.8118;...
                0.749 1 0.2471; 1 0.6235 0; 1 0.05882 0; 0.498 0 0]; 
% undistortion:
[left_image, ~] = undistortImage(left_image,stereoParams.CameraParameters1);
[right_image, ~] = undistortImage(right_image,stereoParams.CameraParameters2);

% load stereo prameters from matlab calibration file:
left_params = stereoParams.CameraParameters1; 
right_params = stereoParams.CameraParameters2;

% define plane: 
plane.normal = [0,0,-1]';


figure(1)
% imshow(left_image)
imshow(left_image)
title('Result')
hold on

color_idx = 1;
for ii=distance_vector
    
    % update plane distance
    plane.distance = ii*1000; % *1000 - units conversion 
    
    % calculate homography:
    H = create_homography_mat(left_params.IntrinsicMatrix, right_params.IntrinsicMatrix, ...
         stereoParams.RotationOfCamera2, stereoParams.TranslationOfCamera2, plane.distance...
         , plane.normal);
    
     % warping:
    warped_image = warp(right_image, H);

    % calculate NCC's:
    ncc_intensity = NCC(rgb2gray(left_image), rgb2gray(warped_image), window_size);
    ncc_vertical_derivative = NCC(vertical_derivative(left_image), vertical_derivative(warped_image), window_size);
    ncc_horizontal_derivative = NCC(horizontal_derivative(left_image), horizontal_derivative(warped_image), window_size);

    % calculate variance:
    variance_map = variance(ncc_intensity, ncc_vertical_derivative, ncc_horizontal_derivative);

    % calculate cost for each pixel:
    cost_map = cost_function_NCC(ncc_intensity, ncc_horizontal_derivative, ncc_vertical_derivative, variance_map);

    % filterring cost map using threshold:
    [x, y, filtered_cost_map_threshold] = threshold_filter(cost_map, threshold);
    
    % plot:
    
    
    scatter(x, y, 2, color_vector(color_idx,:) ,'.')
    drawnow
    
    color_idx = color_idx+1;
end

 




% % calculate XY (centered on left camera)
% XY = XY_calculate(left_params.FocalLength(1), left_params.FocalLength(2), ...
%     left_params.Skew, left_params.PrincipalPoint(1), left_params.PrincipalPoint(2),...
%     [x'; y'] , plane.distance);
% 
% % show:
% figure(1)
% imshowpair(left_image, warped_image,'blend','Scaling','joint')
% title('warped (right to left)')
% figure(6)
% subplot(1,2,1)
% imshow(cost_map)
% title('result')
% subplot(1,2,2)
% imshow(filtered_cost_map_threshold)
% title('result - filtered by threshold')
% 
% 
% figure(7)
% subplot(2,2,1)
% imshow(ncc_intensity);
% title('NCC on regular images')
% subplot(2,2,2)
% imshow(variance_map)
% title('Variance map')
% subplot(2,2,3)
% imshow(ncc_horizontal_derivative)
% title('NCC on horizontal derivative')
% subplot(2,2,4)
% imshow(ncc_vertical_derivative)
% title('NCC on vertical derivative')
% 
% figure(8)
% imshow(left_image)
% hold on
% scatter(y, x, 2, 'red','.')
% 
% figure(9)
% scatter3( (1/1000)*XY(2,:)',(1/1000)*XY(1,:)', (1/1000)*plane.distance*ones(size(XY,2), 1));
% xlabel('X [meters]')
% ylabel('Y [meters]')
% zlabel('Z [meters]')
% 
% % create colormap:
% R = left_image(:,:,1);
% G = left_image(:,:,2);
% B = left_image(:,:,3);
% 
% color = ones(size(XY,2), 3);
% color(:,1) = R(sub2ind([size(R,1), size(R,2)],x,y)); 
% color(:,2) = G(sub2ind([size(G,1), size(G,2)],x,y));
% color(:,3) = B(sub2ind([size(B,1), size(B,2)],x,y));
% 
% % create cloud:
% cloud(:,1) = (1/1000)*XY(2,:)';
% cloud(:,2) = (1/1000)*XY(1,:)';
% cloud(:,3) = (1/1000)*plane.distance*ones(size(XY,2), 1);
% 
% figure(10)
% pcshow(cloud, uint8(color));
% xlabel('X [meters]')
% ylabel('Y [meters]')
% zlabel('Z [meters]')
% 
% 
