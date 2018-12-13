%% main script based on NCC (from zed):

close all;

% set parmaeters (zed):
left_image = imageStackLeft(:,:,:,20); % the main camera
right_image = imageStackRight(:,:,:,20);
window_size = 20; % NCC window
distance = 3; % for homography calculation; %1.9 
threshold = 1.8;

K_left = [699.842 0 0 ; 0 699.842 0 ; 611.526 374.856 1];
K_right = [700.247 0 0 ; 0 700.247 0 ; 679.833 342.491 1];
R = eye(3);
t = [-120 0 0];

% % set parmaeters (regular):
% load('stereoParams2.mat', 'stereoParams') 
% left_image = imread('left_40_2018-10-17-16-22-43-631.jpg'); % the main camera
% right_image = imread('right_40_2018-10-17-16-22-43-593.jpg');
% window_size = 20; % NCC window
% distance = 20; % for homography calculation; %1.9 
% threshold = 1.8;
% 
% K_left = stereoParams.CameraParameters1.IntrinsicMatrix;
% K_right = stereoParams.CameraParameters2.IntrinsicMatrix;
% R = stereoParams.RotationOfCamera2;
% t = stereoParams.TranslationOfCamera2;
 
 
%undistortion:
[left_image, ~] = undistortImage(left_image, cameraIntrinsics([K_left(1) ...
    K_left(5)], [K_left(3) K_left(6)], [size(left_image,2) size(left_image,1)]));
[right_image, ~] = undistortImage(right_image, cameraIntrinsics([K_right(1) ...
    K_right(5)], [K_right(3) K_right(6)], [size(right_image,2) size(right_image,1)]));

% [left_image, ~] = undistortImage(left_image, stereoParams.CameraParameters1);
% [right_image, ~] = undistortImage(right_image, stereoParams.CameraParameters2);

% % load stereo prameters from matlab calibration file:
% left_params = stereoParams.CameraParameters1; 
% right_params = stereoParams.CameraParameters2;

% define plane: 
plane.normal = [0,0,-1]';
plane.distance = distance*1000; %mm 
 
% calculate homography:
H = create_homography_mat(K_left, K_right, ...
    R, t, plane.distance...
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

% calculate XY (centered on left camera)
XY = XY_calculate(K_left(1) , K_left(5), ...
    K_left(2), K_left(3), K_left(6),...
    [x'; y'] , plane.distance);

% show:
figure(1)
imshowpair(left_image, warped_image,'blend','Scaling','joint')
title('warped (right to left)')
figure(6)
subplot(1,2,1)
imshow(cost_map)
title('result')
subplot(1,2,2)
imshow(filtered_cost_map_threshold)
title('result - filtered by threshold')


figure(7)
subplot(2,2,1)
imshow(ncc_intensity);
title('NCC on regular images')
subplot(2,2,2)
imshow(variance_map)
title('Variance map')
subplot(2,2,3)
imshow(ncc_horizontal_derivative)
title('NCC on horizontal derivative')
subplot(2,2,4)
imshow(ncc_vertical_derivative)
title('NCC on vertical derivative')

figure(8)
imshow(left_image)
hold on
scatter(y, x, 2, 'red','.')

figure(9)
scatter3( (1/1000)*XY(2,:)',(1/1000)*XY(1,:)', (1/1000)*plane.distance*ones(size(XY,2), 1));
xlabel('X [meters]')
ylabel('Y [meters]')
zlabel('Z [meters]')

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
