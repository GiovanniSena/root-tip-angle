function var_saver(~)
% The function creates a variable called varnames which contains the names
% of the relevant vars. It then pulls them from the base workspace and lets
% the user save them in a mat file.
varnames = {'skelmatR','max_curv_point','skelmatR_simp'};
skelmatR = evalin('base','skelmatR'); %#ok<*NASGU,*ASGLU>
max_curv_point = evalin('base','max_curv_point'); %#ok<*ASGLU>
skelmatR_simp = evalin('base','skelmatR_simp'); %#ok<*ASGLU>
uisave(varnames);
end