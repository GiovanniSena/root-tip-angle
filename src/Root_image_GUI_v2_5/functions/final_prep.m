function final_prep(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Extracting only the tip and then from that the relevant [x,y] values %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
unified_skeleton = evalin('base', 'unified_skeleton');
%  

% Attempting to implement the optional "choose the point with mean
% curvature". 13.8.18 13:29
% Asking the user if they want to choose the point with highest mean
% curvature.

%SEE LOG 13.8.18 15:16 why it's here
unified_skeleton=imrotate(unified_skeleton,90);

% Moved here on 26.8.18 14:19. see LOG for reason.
% Vectors for positions of 1's (new x ordered [x after rotation])
    [skerowx,skecolx] = find(unified_skeleton);
    % And a matrix
    skelmatR_simp = cat(2,skecolx,skerowx);

answer = questdlg({'Would you like to choose the point with highest local curvature?','Doing so might help with the calculations'}, 'Curvature?','Yes','No','No');

switch answer
    case 'Yes'
        flag = true;
    case 'No'
        flag = false;
end
% If the user clicked Yes they will be prompted to choose one point whose
% coordinates will be inserted to usercurvx and usercurvy. Then, the point
% in skelmatR closest to that point will be chosen
if (flag == true)
    
    imshow(unified_skeleton,'Parent',handles.alt_img)
    uiwait(msgbox({'Choose the point in the rotated skeleton (image that appeared in the right) that seems to have the highest curvature','Press ENTER to finish'}, 'Curvature!'));
    point_get(1,1,'usercurvx','usercurvy',handles.alt_img)
    
    curvdist = sqrt((skelmatR_simp(:,1)-usercurvx).^2+(skelmatR_simp(:,2)-usercurvy).^2);
    max_curv_point = skelmatR_simp(curvdist == min(curvdist),:);
    handles.user_angle.Enable = 'on'; % Added on 15.8.18 18:02. SEE LOG

else
    max_curv_point = [];
end

% SEE LOG 13.8.18 14:42 for why it was moved here 
% Creating a rotated matrix
% Important! because it is now rotated, had to switch between lastrow and
% junk
[~, lastrow] = find(unified_skeleton, 1, 'last' ); % last white pixel is tip of the skeleton
unified_skeleton_size = size(unified_skeleton);
% crop_window = [0, lastrow-50, unified_skeleton_size(2), 65];
% final_skeleton = imcrop(unified_skeleton,crop_window);
% final_skeletonR=imrotate(final_skeleton,90);

%SEE LOG 13.8.18 15:16 for the changes
crop_window = [lastrow-75, 0, 90, unified_skeleton_size(2)];
final_skeletonR = imcrop(unified_skeleton,crop_window);


%  % Vectors for positions of 1's (new x ordered [x after rotation])
[skerowx,skecolx] = find(final_skeletonR);
%  % And a matrix
skelmatR = cat(2,skecolx,skerowx);

handles.curv_angle.Enable = 'on'; % Added on 15.8.18 18:04. SEE LOG

% In order to be used in curvature script
assignin('base','skelmatR',skelmatR);
assignin('base','skelmatR_simp',skelmatR_simp);
assignin('base','max_curv_point',max_curv_point);


end