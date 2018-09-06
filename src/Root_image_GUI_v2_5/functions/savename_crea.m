function savename_crea(~)
% See LOG 22.8.18 12:39 to see when was it added
% %Update - see LOG 22.8.18 12:18
rootnum = inputdlg('Enter the Root number (starting from the left)','Root number');
waitfor(rootnum)
file_name = evalin('base','file_name');
% And savename will combine the file_name (minus the last 4 characters representing
% the .jpg) and rootnum and will tell uisave
% to make it the default name.
savename = strcat(file_name(1:end-4), '_root',rootnum{1});
% %
assignin('base','savename',savename);
end