function varargout = lbsCP_playalarm(varargin)
% LBSCP_PLAYALARM MATLAB code for lbsCP_playalarm.fig
%      LBSCP_PLAYALARM, by itself, creates a new LBSCP_PLAYALARM or raises the existing
%      singleton*.
%
%      H = LBSCP_PLAYALARM returns the handle to a new LBSCP_PLAYALARM or the handle to
%      the existing singleton*.
%
%      LBSCP_PLAYALARM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LBSCP_PLAYALARM.M with the given input arguments.
%
%      LBSCP_PLAYALARM('Property','Value',...) creates a new LBSCP_PLAYALARM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before lbsCP_playalarm_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to lbsCP_playalarm_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lbsCP_playalarm

% Last Modified by GUIDE v2.5 02-Dec-2018 20:34:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lbsCP_playalarm_OpeningFcn, ...
                   'gui_OutputFcn',  @lbsCP_playalarm_OutputFcn, ...
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


% --- Executes just before lbsCP_playalarm is made visible.
function lbsCP_playalarm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to lbsCP_playalarm (see VARARGIN)

% Choose default command line output for lbsCP_playalarm
handles.output = hObject;

[kaluli, FS]=audioread('musics/kaluli.wav');

InitializePsychSound;
deviceID=setDeviceID('subject');
pahandle = PsychPortAudio('Open',deviceID,1,2,[],2);          % 主设备（这些参数就这么用OK）
PsychPortAudio('FillBuffer',pahandle,kaluli);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes lbsCP_playalarm wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = lbsCP_playalarm_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
