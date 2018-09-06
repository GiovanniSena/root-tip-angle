function angle_file(root_angle,user_flag)
% Will get the savename string if necessary and then create a .txt file
% that will contain the angle with some fluff indicating which root it is
% and from what picture.
% For the use of this if block see LOG 22.8.18 12:39
if (evalin('base',"(exist('savename','var'))") ~=1)
    savename_crea
end
% Creating a file whose name consists either of 'root_angles.csv' or the same
% but with 'user_assisted' depending on user_flag (see LOG 22.8.18 16:57)
%  (Thanks to the a permission it will create the file if
% necessary). Then it prints to the file the formatSpec with the savename
% and the angle instead of %s and %f.
% UPDATE 26.8.18 (see LOG 14:49) - will change the file name to consist of
% date_root#_angles.csv (or user_assisted_...). Will do it by taking the
% beginning of savename and its end and concatanating with the relevant
% stuff.
savename = evalin('base','savename');
filesavename = strcat(savename(1:11),savename(end-4:end));
if (user_flag == 1)
    filesavename = strcat('user_assisted_',filesavename,'_angles.csv');
    fileID = fopen(filesavename,'a');
else
    filesavename = strcat(filesavename,'_angles.csv');
    fileID = fopen(filesavename,'a');
end
% formatSpec = 'The angle for the root identified by %s is %f';
% See LOG 22.8.18 16:48
formatSpec = '%s  %8.4f\n';
fprintf(fileID,formatSpec,savename,root_angle);
fclose(fileID);
end