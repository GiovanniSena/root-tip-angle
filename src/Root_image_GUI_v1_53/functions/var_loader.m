function var_loader(handles)
% Migrated here the ability to load variables and also implemented the
% enabling of appropriate angle calculation buttons.
% SEE LOG 15.8.18 21:01
% ...And then migrated back by 21:13 so that I won't have to fuss with
% assigning.
% ...And then migrated again when I realised I have to fuss with it
% anyways. 21:15

% See LOG 22.8.18 16:52
clear variables

uiopen('*.mat') %Added on 15.8.18 18:14. For opening the workspace variables you once saved.

if((exist('skelmatR_simp','var')) ==1)
    assignin('base','max_curv_point',max_curv_point);
    assignin('base','skelmatR_simp',skelmatR_simp);
end
assignin('base','skelmatR',skelmatR);
% see LOG 22.8.18 16:52
assignin('base','savename',savename);

end