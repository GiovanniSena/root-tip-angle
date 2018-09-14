function force_tip(handles)
% This function prompts the user to create an open polygon
% between the edge of the current skeleton and the tip.
% It then proceeds to whiten it.
% brightcrop = evalin('base', 'bright_filt_img');
% colorcrop = evalin('base', 'color_filt_img'); % temp matrix
temp_skel = evalin('base','unified_skeleton');
uiwait(msgbox({'Drag a line from a the end of the skeleton and ending at the real tip.','Press ENTER to finish'}, 'Cropping'));
% h = impoly(handles.alt_img,'Closed',false); %draw the cropping window. CHANGED 13.8 09:26
h = imline(handles.alt_img); %draw the extension line. 13.8 10:11
M = h.createMask(); % Creates a mask in which the outside of the region will later be zeroed
%     colorcrop(M) = evalin('base','root_mean_color'); % 12.8.18, 18:51. Using the root_points_color instead of 1.
%     brightcrop(M) = evalin('base','root_mean_color'); % 12.8.18, 18:51. Using the root_points_color instead of 1. % see LOG 20.7 11:42
temp_skel(M) = 1;
% assignin('base','color_filt_img',colorcrop);
%             assignin('base','bright_filt_img',brightcrop);
assignin('base','unified_skeleton',temp_skel);

end