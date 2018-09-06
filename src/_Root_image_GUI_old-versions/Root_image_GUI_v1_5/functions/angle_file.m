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
if (user_flag == 1)
    fileID = fopen('user_assisted_root_angles.csv','a');
else
    fileID = fopen('root_angles.csv','a');
end
% formatSpec = 'The angle for the root identified by %s is %f';
% See LOG 22.8.18 16:48
formatSpec = '%s  %8.4f\n';
fprintf(fileID,formatSpec,evalin('base','savename'),root_angle);
fclose(fileID);
end