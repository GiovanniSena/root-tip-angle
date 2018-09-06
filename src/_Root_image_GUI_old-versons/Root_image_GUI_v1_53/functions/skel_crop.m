function skel_crop(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NEW FUNCTION 23.8.18 20:44 (see Log)                             %
%            Optional free hand cropping of skeleton                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uiwait(msgbox('Crop a region around the skeleton by hand to remove things outside of the region.', 'Cropping'));


flag = true;
% A while loop that allows the user to try again if he is not pleased with
% the result.
while (flag == true)
    skelcrop = evalin('base', 'unified_skeleton'); % temp matrix
    imshow( skelcrop, 'Parent', handles.alt_img);
    h = imfreehand(handles.alt_img); %draw the cropping window
    M = ~h.createMask(); % Creates a mask in which the outside of the region will later be zeroed
    skelcrop(M) = 0; % Zeroes it
    imshow(skelcrop, 'Parent', handles.alt_img); %Shows the result.
    answer = questdlg('Would you like to redo the cropping?', 'Another try?','Yes','No','No');
    
    switch answer
        case 'Yes'
            flag = true;
        case 'No'
            flag = false;
            % Finally returning the cropped image home
            % see LOG 20.7 11:42
            assignin('base','unified_skeleton',skelcrop);
    end
    
    
end

end