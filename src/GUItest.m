function varargout = GUItest(varargin)
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

% Last Modified by GUIDE v2.5 10-Aug-2018 12:02:09

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

function image_choose(handles)
% 10.8.18, ~10:30
% I just pulled existing code from lychtst2
[file_name,file_path] = uigetfile('*.jpg');
lych_tst2 = imread(strcat(file_path,file_name));

lych_tst2 = double(lych_tst2) /255; % Converting to double

% Update - see LOG 19.7.18 13:32
if(mean(mean(mean(lych_tst2))) < 0.4)
    lych_tst2 = lych_tst2 * 3; % Multiplying by 3
end

% And another medfilt 18.7.18 11:26
lych_tst2(:,:,1) = medfilt2(lych_tst2(:,:,1));
lych_tst2(:,:,2) = medfilt2(lych_tst2(:,:,2));
lych_tst2(:,:,3) = medfilt2(lych_tst2(:,:,3));

% UPDATE 19.7.18 12:42 (see LOG)
lych_tst2 = 6 * imadjust(lych_tst2,[],[],2);


lych_tst2 = adaptthresh(lych_tst2,1,'NeighborhoodSize',1,'Statistic','median'); % Blurs things up. not good.

% Inverting the image
lych_tst2 = 1.- lych_tst2;
uiwait(msgbox('Please zoom on the area of the desired root.','User instructions 1','modal'));
image(lych_tst2);
zoom on
% pause

assignin('base','lych_tst2',lych_tst2);

% Added a flag so that the user can go back to choosing points if he is not
% pleased
assignin('base','zoom_flag',0);



% --- Executes on button press in point_chooser.
function point_chooser_Callback(hObject, eventdata, handles)
% hObject    handle to point_chooser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% If user wants to try again:
if (evalin('base', 'zoom_flag') == 1)
    % Inverting the image
    lych_tst2 =  evalin('base', 'lych_tst2');
    uiwait(msgbox('Please zoom in again.','User instructions 1','modal'));
    image(lych_tst2);
    zoom on
    pause
end
point_choose(handles)

function point_choose(handles)
% 10.8.18, 10:41
% I just pulled existing code from lychtst2

uiwait(msgbox({'Please choose 5 - 10 evenly spaced points on the desired root starting with the tip.' 'Press BACKWARDS to delete point' 'Press ENTER when finished'},'User instructions','modal'));


hold on
% Getting the 5 points from the user
[rootx,rooty] = getpts;
hold off
assignin('base','rootx',rootx);
assignin('base','rooty',rooty);


% --- Executes on button press in skel_getter.
function skel_getter_Callback(hObject, eventdata, handles)
% hObject    handle to skel_getter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
lychtest_GUI % RUNS the rest of the script
assignin('base','zoom_flag',1);
