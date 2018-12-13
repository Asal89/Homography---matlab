function [images_stack] = imagestack_create(images_dir)
%TODO: add description. note that this function deals with folders that may
%contain subfolders, but not deals with files that are not a valid image.
%note that images_dir us not sesitive to '/' ending
%note that if  number of input images us greater then 'max_num_of_images' 
%some images may be excluded

    % craete [num_of_files x 1] struct that holds 
    % file-only names:
    names  = dir(images_dir);
    names_length = length(names);
    jj = 1;
    while jj <= length(names)
        if names(jj).isdir == 1 
            names(jj) = [];
            jj = jj-1;
            names_length = names_length-1;
        end
        jj = jj+1;
    end

    % sort filenames alphabeticaly:
    [names_sorted , ~ ]  = sort_nat({names(:).name});

    % first element in names_sorted is garbage. remove it:
    names_sorted(1) = [];
    
    % create imagestack 
    images_width = 1936; %TODO: fix constants dependencies 
    images_height = 1216; %TODO: fix constants dependencies
    num_of_images = length(names_sorted);
    if (num_of_images >= 250)
        num_of_images = 250;
    end
    images_stack  = uint8(zeros(images_height,images_width,3,num_of_images));    
    
    if images_dir(end) ~= '/'
        images_dir = [images_dir '/'];
    end
    
    for j=1:num_of_images
        current_image = imread([images_dir  names_sorted{j}]);    
        images_stack(:,:,:,j) = current_image;
        
    end

end

