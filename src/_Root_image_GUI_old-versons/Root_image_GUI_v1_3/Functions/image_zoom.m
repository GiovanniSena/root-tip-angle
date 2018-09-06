function image_zoom(handles)
% Inverting the image
original_roots_img = 1.- evalin('base', 'original_roots_img');
image(handles.orig_img, original_roots_img);
uiwait(msgbox('Please zoom on the area of the desired root.','User instructions 1','modal'));
zoom on

% Added a flag so that the user can go back to choosing points if he is not
% pleased
% assignin('base','zoom_flag',0);
end