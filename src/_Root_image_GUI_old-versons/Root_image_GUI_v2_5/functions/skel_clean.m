function skel_clean(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Optional additional cleaning (see old LOG 19.7.18 19:01)           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Will remove object according to the value from the clean_power slider
% (see LOG from around 03:15 4.9.18 for this new development)
uiwait(msgbox({'This cleaning process will remove objects proportional to the slider.','If not careful you might accidentally erase the root,','which is why you will be offered to undo the cleaning.'}, 'Cleaning instructions'));

% To implement the optional additional cleaning, created a variable
% howClean instead of a static number
% UPDATE - Now with a value from a slider. 4.9.18 03:18 see LOG.
howClean = round(handles.clean_power.Value);

unified_skeleton = evalin('base', 'unified_skeleton');


temp_skeleton=bwareaopen(unified_skeleton,howClean);
imshowpair(evalin('base', 'cropped_roots_img')*2,temp_skeleton, 'Parent', handles.alt_img);

% Now I shall offer the possibility to undo last step.
% In actuallity, if you press 'Yes' nothing will happen because the
% information of the last step is in temp_skeleton which is not used later.
% If you press 'No' the info from temp_skeleton will be put in unified_skeleton.
answer = questdlg('Would you like to undo last step?', 'Undo last step','Yes','No','No');
switch answer
    case 'No'
        unified_skeleton = temp_skeleton;
end

% And finally, showing results
imshowpair(evalin('base', 'cropped_roots_img')*2,unified_skeleton, 'Parent', handles.alt_img);

%%%%%%%%% 15.8.18 01:30
% IT DIDN'T ASSIGN THE RESULT TO BASE WORK SPACE BEFORE. WILL FIX.
assignin('base','unified_skeleton',unified_skeleton)

end