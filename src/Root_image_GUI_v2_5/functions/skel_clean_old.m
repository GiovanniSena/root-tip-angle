function skel_clean(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Optional additional cleaning (see old LOG 19.7.18 19:01)           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Will ask the user whether it wants additional cleaning, and then loop on
% it until he is satisfied.
uiwait(msgbox({'This cleaning process will attempt to remove bigger and bigger objects with every iteration.','If not careful you might accidentally erase the root,','which is why you will be offered to undo the last step.'}, 'Cleaning instructions'));

% Loop control variable
flag = true;

% To implement the optional additional cleaning, created a variable
% howClean instead of a static number
howClean = 100;

unified_skeleton = evalin('base', 'unified_skeleton');

if (flag == true)
    temp_skeleton = unified_skeleton; % That new addition that allows reverting to the one step before last.
    while (flag == true)
        % First will take the one from the last iteration. The statement is here so
        % that the undoing of the last step will be possible. If I put it
        % at the end of the while loop, the information will be lost.
        unified_skeleton = temp_skeleton;
        % Now that the howClean variable exists, we can increment it.
        howClean = howClean + 30;
        temp_skeleton=bwareaopen(unified_skeleton,howClean);
        imshowpair(evalin('base', 'cropped_roots_img')*2,temp_skeleton, 'Parent', handles.alt_img);
        answer = questdlg('Would you like more cleaning?', 'Cleaning query','Yes','No','Yes');
        
        % It wasn't happy with using 'Yes' as a condition when 'No' was chosen.
        % So a new variable was created. logical.
        % Again. maybe Matlab has 'do while'
        switch answer
            case 'Yes'
                flag = true;
            case 'No'
                flag = false;
        end
    end
    % Now I shall offer the possibility to undo last step.
    % In actuallity, if you press 'Yes' nothing will happen because the
    % information of the last step is in temp_skeleton which is not used later.
    % If you press 'No' the info from temp_skeleton will be put in unified_skeleton.
    answer = questdlg('Would you like to undo last step?', 'Undo last step','Yes','No','No');
    switch answer
        case 'No'
            unified_skeleton = temp_skeleton;
    end
end

% And finally, showing results
imshowpair(evalin('base', 'cropped_roots_img')*2,unified_skeleton, 'Parent', handles.alt_img);

%%%%%%%%% 15.8.18 01:30
% IT DIDN'T ASSIGN THE RESULT TO BASE WORK SPACE BEFORE. WILL FIX.
assignin('base','unified_skeleton',unified_skeleton)

end