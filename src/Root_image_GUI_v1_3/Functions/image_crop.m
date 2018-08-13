function image_crop(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NEW SECTION 19.7.18 23:28 (see old_version_Log)                             %
%                       Optional free hand cropping                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uiwait(msgbox('Crop a region around the root by hand to improve the efficiency.', 'Cropping'));


flag = true;
% A while loop that allows the user to try again if he is not pleased with
% the result.
brightcrop = evalin('base', 'bright_filt_img'); % see LOG 20.7 11:42
% UPDATE 10.8.18, 22:16 by accident I found out showing the inverted image
% might be a better tactic
while (flag == true)
    colorcrop = evalin('base', 'color_filt_img'); % temp matrix
    imshow(1. - colorcrop, 'Parent', handles.alt_img);
    h = imfreehand(handles.alt_img); %draw the cropping window
    M = ~h.createMask(); % Creates a mask in which the outside of the region will later be zeroed
    colorcrop(M) = 0; % Zeroes it
    brightcrop(M) = 0; % see LOG 20.7 11:42
    imshow(colorcrop, 'Parent', handles.alt_img); %Shows the result.
    answer = questdlg('Would you like to redo the cropping?', 'Another try?','Yes','No','No');
    
    switch answer
        case 'Yes'
            flag = true;
        case 'No'
            flag = false;
            % Finally returning the cropped image home
            % see LOG 20.7 11:42
            assignin('base','color_filt_img',colorcrop);
            assignin('base','bright_filt_img',brightcrop);
    end
    
    
end

end