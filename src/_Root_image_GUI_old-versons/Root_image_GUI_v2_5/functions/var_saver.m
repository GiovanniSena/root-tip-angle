function var_saver(~)
% The function creates a variable called varnames which contains the names
% of the relevant vars. It then pulls them from the base workspace and lets
% the user save them in a mat file.
% Update (see LOG 22.8.18 15:12). Decided to add savename to the list of
% saved variables to allow the named saving of things after loading a .mat
% file.

varnames = {'skelmatR','max_curv_point','skelmatR_simp','savename'};
skelmatR = evalin('base','skelmatR'); %#ok<*NASGU,*ASGLU>
max_curv_point = evalin('base','max_curv_point'); %#ok<*ASGLU>
skelmatR_simp = evalin('base','skelmatR_simp'); %#ok<*ASGLU>
% See LOG 22.8.18 12:39 to see when was it added
if (evalin('base',"(exist('savename','var'))") ~=1)
    savename_crea    
end
% See LOG 22.8.18 12:39 to see when was it added
savingname = strcat(evalin('base','savename'),'.mat');

savename = evalin('base','savename');
uisave(varnames,savingname);
end