clear all; close all;

% set parmaeters:
left_images_dir = '/home/jetski/Documents/Asaf/plane/data/35/set1/35mm_pishpash_long/left/';
right_images_dir = '/home/jetski/Documents/Asaf/plane/data/35/set1/35mm_pishpash_long/right/';
load('/home/jetski/Documents/Asaf/plane/data/35/set1/stereoParams35.mat', 'stereoParams')
window_size = 10; % NCC window
threshold = 1.5;
distance = 47;
start_frame = 20;
end_frame = 200;

% create image stacks:
left_stack = imagestack_create(left_images_dir);
right_stack = imagestack_create(right_images_dir);

% load stereo prameters from matlab calibration file:
left_params = stereoParams.CameraParameters1; 
right_params = stereoParams.CameraParameters2;

% define plane: 
plane.normal = [0,0,-1]';
plane.distance = distance*1000; %mm 


% ensure that both stacks contains the same amount of images:
if size(left_stack, 4) ~= size(right_stack,4)
    'image stacks are not fitted';
    return;
end

 % calculate homography:
H = create_homography_mat(left_params.IntrinsicMatrix, right_params.IntrinsicMatrix, ...
    stereoParams.RotationOfCamera2, stereoParams.TranslationOfCamera2, plane.distance...
    , plane.normal);

% loop over the stacks and show results:
stacks_length = size(left_stack, 4);

% store each frame's interpulated y in a vector:
interpulated_y = zeros(2,length(start_frame:end_frame)); 

for ii=start_frame:end_frame%stacks_length
   
    disp(ii)
    left_image = left_stack(:,:,:,ii);
    right_image = right_stack(:,:,:,ii);
    
    tic;
    
    % undistortion:
    [left_image, ~] = undistortImage(left_image,stereoParams.CameraParameters1);
    [right_image, ~] = undistortImage(right_image,stereoParams.CameraParameters2); 

    toc;
    
  
    
    % warping:
    warped_image = warp(right_image, H);

    disp('warping')
    toc;
    
    % calculate NCC's:
    ncc_intensity = NCC(rgb2gray(left_image), rgb2gray(warped_image), window_size);
    disp('NCC intensity')
    toc;
    ncc_vertical_derivative = NCC(vertical_derivative(left_image), vertical_derivative(warped_image), window_size);
    disp('NCC vertical derivative')
    toc;
    ncc_horizontal_derivative = NCC(horizontal_derivative(left_image), horizontal_derivative(warped_image), window_size);
    disp('NCC horizontal derivative')
    toc;
    
    % calculate variance:
    variance_map = variance(ncc_intensity, ncc_vertical_derivative, ncc_horizontal_derivative);
    disp('vriance')
    toc;
    
    % calculate cost for each pixel:
    cost_map = cost_function_NCC(ncc_intensity, ncc_horizontal_derivative, ncc_vertical_derivative, variance_map);
    disp('cost map')
    toc;
    
    % filterring cost map using threshold:
    [x, y, filtered_cost_map_threshold] = threshold_filter(cost_map, threshold);
    disp('threshold')
    toc;
    
    % calculate XY (centered on left camera)
    XY = XY_calculate(left_params.FocalLength(1), left_params.FocalLength(2), ...
    left_params.Skew, left_params.PrincipalPoint(1), left_params.PrincipalPoint(2),...
    [x'; y'] , plane.distance);
    disp('XY caculate')
    toc;
    
    % interpulate value for Y
    [interpulated, std, relevant_xy] = Y_interpulate(XY, [x'; y']);
    interpulated_y(1, ii) = interpulated;
    interpulated_y(2, ii) = std;
    
    % plot:
    figure(1)
    % figure('visible','off')
    imshow(left_image)
    title(['Frame No.' num2str(ii) '. Y = ' num2str(interpulated_y(1,ii)/1000) ' std = ' num2str(interpulated_y(2,ii)/1000)])
    hold on
    scatter(x, y, 2, 'red' ,'.')
    scatter(relevant_xy(1,:), relevant_xy(2,:), 2, 'blue' ,'.')
    hold off
    F(ii) = getframe(gcf) ;
    drawnow
end

% plot y and variance:
figure(2)
plot((1:size(interpulated_y,2)), interpulated_y(1,:)/1000, 'r', ...
    (1:size(interpulated_y,2)), interpulated_y(2,:)/1000, 'g')
legend('Y[m]','std')

% create the video writer
writerObj = VideoWriter('myVideo.avi');
writerObj.FrameRate = 5;
% open the video writer
open(writerObj);
% write the frames to the video
for i=155:173%length(F)
    disp(i)
    % convert the image to a frame
    frame = F(i) ;    
    writeVideo(writerObj, frame);
end
% close the writer object
close(writerObj);

