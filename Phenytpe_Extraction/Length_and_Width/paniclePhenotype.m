% IOWA STATE UNIVERSITY

%   Developed by Seyed Vahid Mirnezami September 27, 2018 -
%   vahid@iastate.edu - vahid.gvg@gmail.com
    
%   Copyright 2017-2018 Prof. Baskar Ganapathysubramanian -
%   baskarg@iastate.edu 

% this code is developed to measure the length and width of the panicle
% using the images.


% Inputs: img_fol = the path where the images are.
function [] = paniclePhenotype(img_fol)

% img_fol: the path where the images are

% obtain all the images in the folder
try
    imgs = [dir(fullfile(img_fol,'*.JPG'));dir(fullfile(img_fol,'*.jpg'))];
catch
    disp('The input path is incorrect')
end

if size(imgs,1)>0
    mkdir (img_fol,'result_images')
   
    for j=1:length(imgs)
        
        % read the image
        IMG = imread(fullfile(img_fol,imgs(j).name));
        image_name{j,1} = imgs(j).name;
        
        % find the panicle path using "panicleMainPath" function
        [path_top, right_boundary, left_boundary, xskeBW, yskeBW] = ...
            panicleMainPath(IMG);
        
        % panicle length
        path_top_sub = [yskeBW(path_top), xskeBW(path_top)];
        panicle_length{j,1}=length(unique(path_top_sub(:,1)));
        
        % smooth the panicle path using Savitzky-Golay algorithm
        smooth_path = smoothdata(unique(path_top_sub,'rows'),'sgolay','SmoothingFactor',1);
        
        %% panicle width calculation
        step = 50; % this number is needed to know how
        count = 0;
        distance = [];
        idxLength = [];
        % find the slope of the denoised path at every "step" pixels
        for i=2:step:size(smooth_path,1)-1
            count = count + 1;
            slope = (smooth_path(i-1,1) - smooth_path(i+1,1)) / ...
                (smooth_path(i-1,2) - smooth_path(i+1,2));
            m = -1/slope;
            
            % locate the lines which intercept the boundaries and prependicular to
            % the denoised path
            temp_data = -m*smooth_path(i,2)+smooth_path(i,1);
            result_right = abs(m*right_boundary(:,2)-right_boundary(:,1) + temp_data);
            [numRight,idx_right] = min(result_right);
            result_left = abs(m*left_boundary(:,2)-left_boundary(:,1) + temp_data);
            [numLeft,idxLeft] = min(result_left);
            distance= [distance;[left_boundary(idxLeft,:) smooth_path(i,:) right_boundary(idx_right,:)]];
            
        end
        
        % calculate the distance of between the boundaries
        mean_each5 = [];
        for i =1:size(distance)
            clear X Y w
            mean_each5 = [];
            X = distance(:,1:2);
            Y = distance(:,5:6);
            w = diag(pdist2(X,Y));
            for iter=5:5:size(w,1)
                mean_each5 = [mean_each5;mean(w(iter-4:iter,1))];
            end
            panicle_width{j,1} = max(mean_each5);
        end
        
        %% saving the images after processing
        
        % show the image with the denoised path
        close all
        h=figure;
        subplot(1,2,1)
        set(h, 'Visible', 'on');
        imshow(IMG)
        hold on
        scatter(smooth_path(:,2),smooth_path(:,1),'*g','LineWidth',2);
        
        % show the image with the boudaries and widths at the different
        % locations
        hold off
        subplot(1,2,2)
        set(h, 'Visible', 'on');
        imshow(IMG)
        hold on
        for t=1:count
            line ([distance(t,2),distance(t,4),distance(t,6)] ,[distance(t,1),distance(t,3),distance(t,5)]);
        end
        scatter(right_boundary(:,2),right_boundary(:,1),'*b','LineWidth',2);
        scatter(left_boundary(:,2),left_boundary(:,1),'*r','LineWidth',2);
        scatter(smooth_path(:,2),smooth_path(:,1),'*g','LineWidth',2);
        
        save_image_result_name = fullfile(img_fol,'result_images',strcat(strtok(imgs(j).name,'.'),'.jpg')); % name of image
        saveas(h,save_image_result_name);
       
    end
    
    %% saving the results
    % results are saved in the folder where images are located. The name of
    % excel file containig the results is obtained based on the name of the
    % folder
    
    result_table = [cell2table(image_name), cell2table(panicle_length), cell2table(panicle_width)];
    save_image_result_name = fullfile(img_fol,'result_images','data_result.xlsx');
    writetable(result_table,save_image_result_name);
   
else
    disp('No image with *.jpg or *.JPG formats was found!')
end