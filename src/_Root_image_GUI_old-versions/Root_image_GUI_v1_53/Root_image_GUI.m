function varargout = Root_image_GUI(varargin)
% GUITEST MATLAB code for GUItest.fig
%      GUITEST, by itself, creates a new GUITEST or raises the existing
%      singleton*.
%
%      H = GUITEST returns the handle to a new GUITEST or the handle to
%      the existing singleton*.
%
%      GUITEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUITEST.M with the given input arguments.
%
%      GUITEST('Property','Value',...) creates a new GUITEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUItest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUItest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUItest

% Last Modified by GUIDE v2.5 23-Aug-2018 22:52:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUItest_OpeningFcn, ...
    'gui_OutputFcn',  @GUItest_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUItest is made visible.
function GUItest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUItest (see VARARGIN)

% Choose default command line output for GUItest
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Clear workspace and base workspace
clear variables
evalin('base','clear')
addpath('functions');
% UIWAIT makes GUItest wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUItest_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in file_getter.
function file_getter_Callback(hObject, eventdata, handles)
% hObject    handle to file_getter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_choose(handles)

% --- Executes on button press in zoomer.
function zoomer_Callback(hObject, eventdata, handles)
% hObject    handle to zoomer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_zoom(handles)

% --- Executes on button press in point_chooser.
function point_chooser_Callback(hObject, eventdata, handles)
% hObject    handle to point_chooser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Supposedly unnecessary since there is now a zoom button (see Log)
% % If user wants to try again:
% if (evalin('base', 'zoom_flag') == 1)
%     % Inverting the image
%     original_roots_img =  1. - evalin('base', 'original_roots_img');
%     image(original_roots_img);
%     uiwait(msgbox('Please zoom in again.','User instructions 1','modal'));
%     zoom on
%     %pause
% end
point_choose(handles)
% 11.8.18 18:52
% Will now make it so when this is pressed it will enable saving the
% skeleton
handles.crop_save.Enable = 'on';




% --- Executes on button press in skel_getter.
function skel_getter_Callback(hObject, eventdata, handles)
% hObject    handle to skel_getter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
root_skel % RUNS the rest of the script
assignin('base','zoom_flag',1);
% 11.8.18 18:52
% Will now make it so when this is pressed it will enable saving the
% skeleton
handles.alt_save.Enable = 'on';
handles.shower.Enable = 'on'; % 13.8.18 08:59; 09:30 moved from process image to get skel.


% --- Executes on button press in im_process.
function im_process_Callback(hObject, eventdata, handles)
% hObject    handle to im_process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_process(handles)



% --- Executes on button press in image_crop.
function image_crop_Callback(hObject, eventdata, handles)
% hObject    handle to image_crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_crop(handles)


% --- Executes on button press in root_cleaner.
function root_cleaner_Callback(hObject, eventdata, handles)
% hObject    handle to root_cleaner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
skel_clean(handles)


% --- Executes on button press in final_button.
function final_button_Callback(hObject, eventdata, handles)
% hObject    handle to final_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
final_prep(handles)


% --- Executes on button press in force_tip.
function force_tip_Callback(hObject, eventdata, handles)
% hObject    handle to force_tip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
force_tip(handles)


% --- Executes on button press in varsave.
function varsave_Callback(hObject, eventdata, handles)
% hObject    handle to varsave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% update 13.8.18 13:57 - I need to import the wanted stuff from the base
% workspace and then use them in uisave
var_saver


% --- Executes on button press in save_fig.
function save_fig_Callback(hObject, eventdata, handles)
% hObject    handle to save_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% In order for it to work as I wanted, I searched for it online.
% This allows to save a specific axes in the GUI.
fig_saver(handles) %15.8.18 18:13


% --- Executes on button press in crop_save.
function crop_save_Callback(hObject, eventdata, handles)
% hObject    handle to crop_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of crop_save


% --- Executes on button press in alt_save.
function alt_save_Callback(hObject, eventdata, handles)
% hObject    handle to alt_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of alt_save


% --- Executes on button press in shower.
function shower_Callback(hObject, eventdata, handles)
% hObject    handle to shower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.orig_img,'reset')
imshow(1. - evalin('base','unified_skeleton'),'Parent',handles.orig_img)
imshowpair(evalin('base', 'cropped_roots_img')*2,evalin('base', 'unified_skeleton'), 'Parent', handles.alt_img);

% --- Executes on button press in clearer.
function clearer_Callback(hObject, eventdata, handles)
% hObject    handle to clearer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Will now try to implement that only checked checkboxes will have their
% thing saved
if (get(handles.lefty,'Value')==1)
    cla(handles.orig_img,'reset')
end
if (get(handles.righter,'Value')==1)
    cla(handles.alt_img)
end

% --- Executes on button press in lefty.
function lefty_Callback(hObject, eventdata, handles)
% hObject    handle to lefty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lefty


% --- Executes on button press in righter.
function righter_Callback(hObject, eventdata, handles)
% hObject    handle to righter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of righter


% --- Executes on button press in user_angle.
function user_angle_Callback(hObject, eventdata, handles)
% hObject    handle to user_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% see LOG 22.8.18 18:46 for uniqueness and the if
[root_angle,uniqueness] = getAngle(evalin('base','skelmatR_simp'),evalin('base','max_curv_point'));
% Update - see LOG 28.8.18 19:12
angle_drawer(handles, [evalin('base','tipy'),evalin('base','tipx')], root_angle)
if (uniqueness == 0)
    uiwait(msgbox('Warning! The point of max curvature is not unique! There are others with the same curvature'));
end
% 15.8.18 21:27 added suppression and message box.
uiwait(msgbox({'The calculated angle (in degrees) is:',num2str(root_angle)}, 'Angle'));
assignin('base','root_angle',root_angle)
% Update - see LOG 22.8.18 13:23
angle_file(root_angle,1)



% --- Executes on button press in curv_angle.
function curv_angle_Callback(hObject, eventdata, handles)
% hObject    handle to curv_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% SEE LOG. 22.8.18 17:09 & 17:16

% see LOG 22.8.18 18:46 for uniqueness and the if
[root_angle,uniqueness] = getAngle(evalin('base','skelmatR_simp'),[]);
% Update - see LOG 28.8.18 19:12
angle_drawer(handles, [evalin('base','tipy'),evalin('base','tipx')], root_angle)
if (uniqueness == 0)
    uiwait(msgbox('Warning! The point of max curvature is not unique! There are others woth the same curvature'));
end
% 15.8.18 21:27 added suppresion and message box.
uiwait(msgbox({'The calculated angle (in degrees) is:',num2str(root_angle)}, 'Angle'));
assignin('base','root_angle',root_angle)
% Update - see LOG 22.8.18 13:23
angle_file(root_angle,0)

% --- Executes on button press in load_var.
function load_var_Callback(hObject, eventdata, handles)
% hObject    handle to load_var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
var_loader(handles)
% see LOG 22.8.18 17:35
if(evalin('base',"(exist('max_curv_point','var'))") ==1)
    handles.user_angle.Enable = 'on';
end
handles.curv_angle.Enable = 'on';



% --- Executes on button press in load_fig.
function load_fig_Callback(hObject, eventdata, handles)
% hObject    handle to load_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fig_loader(handles)


% --- Executes on button press in left_load.
function left_load_Callback(hObject, eventdata, handles)
% hObject    handle to left_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of left_load
assignin('base','loadflag', 1) % 15.8.18 18:22


% --- Executes on button press in right_load.
function right_load_Callback(hObject, eventdata, handles)
% hObject    handle to right_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of right_load
assignin('base','loadflag', 0) % 15.8.18 18:22


% --- Executes on button press in crop_skel.
function crop_skel_Callback(hObject, eventdata, handles)
% hObject    handle to crop_skel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
skel_crop(handles)
