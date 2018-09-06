function point_choose(handles)
% 10.8.18, 10:41
% I just pulled existing code from lychtst2
% 10.8.18, 22:02
% Will now pull updated code from lychtst3

rootx = [];
rooty = [];

%10.8.18 13:26 - Now for the points near the tip
uiwait(msgbox({'Please choose 5 points close to the tip.' 'Press BACKWARDS to delete point' 'Press ENTER when finished'},'User instructions','modal'));
hold on
% Getting the 5 points from the user
% 10.8.18 13:44 - New functionality - a spararte functions that checks for
% number of points.
point_get(5,5,'tempx','tempy',handles.orig_img)

hold off
% Adding them to the existing vectors
rootx = [rootx;tempx];
rooty = [rooty;tempy];

%10.8.18 13:28 - Finally the evenly spaced ones
uiwait(msgbox({'Please choose 5 - 10 evenly spaced points on the desired root starting with the tip.' 'Press BACKWARDS to delete point' 'Press ENTER when finished'},'User instructions','modal'));

hold on
% Getting the 5 points from the user
% 10.8.18 13:44 - New functionality - a spararte functions that checks for
% number of points.
point_get(5,10,'tempx','tempy',handles.orig_img)

hold off
% Adding them to the existing vectors
rootx = [rootx;tempx];
rooty = [rooty;tempy];

% Rounding the indices. MOVED HERE 10.8 22:58 because of reorganization
rootx=round(rootx);
rooty=round(rooty);

assignin('base','rootx',rootx);
assignin('base','rooty',rooty);

original_roots_img = evalin('base', 'original_roots_img');

% UPDATE 18.7.18 10:45 -
% Will try to implement an approach where the crop window will get smaller
% if the area around the points is bright. See log.

% First the default value
 crop_str = 0.5;
% see LOG 24.8.2018 02:04; Changed it back on 31.8.18, 14:23
%crop_str = 1;

% Inverted back to avoid a lot of problems - 18.7.18 11:07
% Inverting the image - OBSOLETE as of 10.8.18 evening since the inverted
% version is not saved to base workspace
% original_roots_img = 1.- original_roots_img;

rxmin = min(rootx)- crop_str * std(rootx); % The minimal x of the rect.
rymin = min(rooty)- crop_str * std(rooty); % The minimal y of the rect.
rwidth = max(rootx)+ crop_str * std(rootx) - rxmin; % The width of the rect.
rheight = max(rooty)+ crop_str * std(rooty) - rymin; % The height of the rect.
crop_window = [rxmin, rymin, rwidth, rheight]; % The rect object that will be used in imcrop
% The cropping of the image using the crop_window
cropped_roots_img = imcrop(original_roots_img,crop_window);

assignin('base','cropped_roots_img',cropped_roots_img);

% UPDATE 4.9.18 03:07 - In implementing the new cleaning slider, will now
% define its max value as 1% of the size of cropped_roots_img (the 2d) and
% enable it. see LOG 4.9.18 02:49
handles.clean_power.Max = round((size(cropped_roots_img,1) * size(cropped_roots_img,2))/100 );
handles.clean_power.Enable = 'on';

% UPDATE - 4.9.18 03:40
% Added a toggle button controlling whether the tip will be chosen at this
% night, so now a new if is added
if(handles.tip_choice.Value == 1)
% 10.8.18 15:48 - Moved the tip selection to after the cropping
uiwait(msgbox({'Please click on the tip of the root (in the image on the right).' 'Press BACKWARDS to delete point' 'Press ENTER when finished'},'User instructions','modal'));
% Had to adjust after I added the relevant_axes variable
% Showing the cropped part (Also this moved ^)
image(handles.alt_img, cropped_roots_img)
hold on
% Getting the tip from the user (See function for desc)
point_get(1,1,'tipx','tipy',handles.alt_img)
hold off

% Rounding the indices
tipx=round(tipx);
tipy=round(tipy);

assignin('base','tipx',tipx);
assignin('base','tipy',tipy);
end


  
  
  end