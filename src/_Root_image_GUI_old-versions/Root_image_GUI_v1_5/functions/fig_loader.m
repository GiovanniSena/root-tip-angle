function fig_loader(handles)
% Will now try to implement that whichever Radio button is pressed will
% determine the axes in which it will be opened.
% if (get(handles.left_load,'Value')==1)
%     
%     relev_panel = handles.orig_panel;
%     relev_axes = handles.orig_img;
% else
%     relev_panel = handles.alt_panel;
%     relev_axes = handles.alt_img;
% end
% The next 4 lines were completed at 15.8.18 18:44.
% What they do: They get the file path and name from user,
% open the figure in an invisible state with open fig
% Change the axes to relev_axes
% and then make it visible
[file_name,file_path] = uigetfile('*.fig');
figu = openfig(strcat(file_path,file_name),'reuse','invisible');
figu.Visible = 'off';
%newAxes = copyobj(relev_axes,figu); % Copy the appropriate axes
%newAxes = copyobj(figu, relev_axes); % Copy the appropriate axes
%figu.Visible = 'on';
% imshow(openfig(strcat(file_path,file_name),'reuse','invisible'),'Parent',relev_axes)
%imshow(imread(strcat(file_path,file_name),'reuse','invisible'),'Parent',relev_axes)
%figu.Parent = handles.figure1;
%figu.Child = ;
%relev_axes.Parent = figu

%newAxes = copyobj(relev_axes,figu); % Copy the appropriate axes
%newAxes = copyobj(figu.CurrentAxes,relev_panel); % Copy the appropriate axes
%relev_axes = newAxes;
if (get(handles.left_load,'Value')==1)
    handles.orig_img = copyobj(figu.CurrentAxes,handles.orig_panel);
else
    handles.alt_img = copyobj(figu.CurrentAxes,handles.alt_panel);
end
%newAxes.Parent = relev_axes
%newAxes = relev_panel
%cur_pos = relev_axes.Position;
%relev_axes = copyobj(figu.CurrentAxes,handles.figure1); % Copy the appropriate axes
%relev_axes.Position = cur_pos;
%relev_axes.Position = [26.429 9.412 123.571 41.235];
%relev_axes.Visible = 'on';
%figu.Visible = 'on';
%delete(figu)
%delete(newAxes)
%newAxes.Visible = 'on'
%newAxes = copyobj(figu.CurrentAxes,relev_axes); % Copy the appropriate axes
end