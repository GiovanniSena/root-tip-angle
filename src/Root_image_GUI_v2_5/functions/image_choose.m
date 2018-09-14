function image_choose(handles)
%
evalin('base','clear')
% 10.8.18, ~10:30
% I just pulled existing code from lychtst2
[file_name,file_path] = uigetfile('*.jpg');
original_roots_img = imread(strcat(file_path,file_name));

original_roots_img = double(original_roots_img) /255; % Converting to double

% Update see LOG 22.8.18 12:18
assignin('base','file_name',file_name)

% Update - see LOG 19.7.18 13:32
if(mean(mean(mean(original_roots_img))) < 0.4)
    original_roots_img = original_roots_img * 3; % Multiplying by 3
end

% And another medfilt 18.7.18 11:26
original_roots_img(:,:,1) = medfilt2(original_roots_img(:,:,1));
original_roots_img(:,:,2) = medfilt2(original_roots_img(:,:,2));
original_roots_img(:,:,3) = medfilt2(original_roots_img(:,:,3));

% UPDATE 19.7.18 12:42 (see LOG)
original_roots_img = 6 * imadjust(original_roots_img,[],[],2);


 original_roots_img = adaptthresh(original_roots_img,1,'NeighborhoodSize',1,'Statistic','median'); % Blurs things up. not good.
% Showing the inverted image in the left axis
image(handles.orig_img, 1. - original_roots_img);
assignin('base','original_roots_img',original_roots_img);
% Added on 4.9.18 03:14 when it occured to me that every time I choose a
% new image I should disable this slider again until I have
% cropped_roots_img.
handles.clean_power.Enable = 'off';
end