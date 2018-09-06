function angle_handler(handles,user_flag)
% New - see LOG 4.9.18 01:38


% SEE LOG. 22.8.18 17:09 & 17:16
if(user_flag == 1)
    % see LOG 22.8.18 18:46 for uniqueness and the if
    [root_angle,uniqueness] = getAngle(evalin('base','skelmatR_simp'),evalin('base','max_curv_point'));
else
    % see LOG 22.8.18 18:46 for uniqueness and the if
    [root_angle,uniqueness] = getAngle(evalin('base','skelmatR_simp'),[]);
end
% UPDATE 30.8.18, 12:29 - moved it here to fix a bug
assignin('base','root_angle',root_angle)
% Update - see LOG 30.8.18 10:57
% Overwriting the user's input to create better lines.
% A change was made several minutes later (11:16) to fix a bug. see LOG.
[tipyv,tipxv] = find(evalin('base','unified_skeleton')); % white pixels of the skeleton
% UPDATE from 30.8.18 11:46, adding an if block with a slightly altered
% version for values close to or lesser than zero of the root angle (or
% close to 160). see LOG 30.8.18 11:43
if ( (evalin('base','root_angle')<10.0) | (evalin('base','root_angle')>120.0) )
    tipx = min(tipxv);
    tipy = tipyv(find(tipx==tipxv(:,1),1));
    assignin('base','tipy',tipy);
    assignin('base','tipx',tipx);
else
    tipy = max(tipyv);
    tipx = tipxv(find(tipy==tipyv(:,1),1));
    assignin('base','tipy',tipy);
    assignin('base','tipx',tipx);
end
% UPDATE see 31.8.18 20:20
try
    % Update - see LOG 28.8.18 19:12
    angle_drawer(handles, [evalin('base','tipy'),evalin('base','tipx')], root_angle)
catch
    warning('Failed to draw the angles')
end
if (uniqueness == 0)
    uiwait(msgbox('Warning! The point of max curvature is not unique! There are others woth the same curvature'));
end
% 15.8.18 21:27 added suppresion and message box.
% UPDATE - on 4.9.18 01:52 changed to a question dialog to make the saving
% of the angle optional. See LOG of 01:38
answer = questdlg({'The calculated angle (in degrees) is:',num2str(root_angle)}, 'Angle','Save',"Don't save","Don't save");

% It wasn't happy with using 'Yes' as a condition when 'No' was chosen.
% So a new variable was created. logical.
% Again. maybe Matlab has 'do while'
switch answer
    case 'Save'
        flag = true;
    case "Don't save"
        flag = false;
end

% Update - see LOG 22.8.18 13:23
% Update - for if see LOG 4.9.18 01:38
if(flag == true)
    angle_file(root_angle,user_flag)
end
end