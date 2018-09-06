function fig_saver(handles)
% Will now try to implement that only checked checkboxes will have their
% thing saved

% Update - See LOG 22.8.18 12:39 to see why the whole savename thing
% was added
if (evalin('base',"(exist('savename','var'))") ~=1)
    savename_crea
end

if (get(handles.crop_save,'Value')==1)
    fignew = figure('Visible','off'); % Invisible figure
    image(evalin('base','cropped_roots_img'))
    set(fignew,'CreateFcn','set(gcbf,''Visible'',''on'')'); % Make it visible upon loading   
    % Update - See LOG 22.8.18 12:39 to see why the whole savename thing
    % was added
    savefig(fignew,strcat(evalin('base','savename'),'_cropped.fig'));
    delete(fignew);
end
if (get(handles.alt_save,'Value')==1)
    fignew = figure('Visible','off'); % Invisible figure
    newAxes = copyobj(handles.alt_img,fignew); % Copy the appropriate axes
    set(newAxes,'Position',get(groot,'DefaultAxesPosition')); % The original position is copied too, so adjust it.
    set(fignew,'CreateFcn','set(gcbf,''Visible'',''on'')'); % Make it visible upon loading    
    % Update - See LOG 22.8.18 12:39 to see why the whole savename thing
    % was added
    savefig(fignew,strcat(evalin('base','savename'),'_skeleton.fig'));
    delete(fignew);
    delete(newAxes);
end
end