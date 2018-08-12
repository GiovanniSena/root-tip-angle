function force_tip(handles)
% This function prompts the user to create a polygon encircling the area
% between the edgs of the current skeleton and the tip.
% It then proceeds to whiten it and try skeletonization again.
brightcrop = evalin('base', 'bright_filt_img');
colorcrop = evalin('base', 'color_filt_img'); % temp matrix
uiwait(msgbox('Create a tubular polygon around the edge, starting a little above the end of the skeleton and ending a little after the real tip.', 'Cropping'));
    h = impoly(handles.alt_img); %draw the cropping window
    M = h.createMask(); % Creates a mask in which the outside of the region will later be zeroed
    colorcrop(M) = evalin('base','root_points_color'); % 12.8.18, 18:51. Using the root_points_color instead of 1.
    brightcrop(M) = evalin('base','root_points_color'); % 12.8.18, 18:51. Using the root_points_color instead of 1. % see LOG 20.7 11:42
assignin('base','color_filt_img',colorcrop);
            assignin('base','bright_filt_img',brightcrop);

end