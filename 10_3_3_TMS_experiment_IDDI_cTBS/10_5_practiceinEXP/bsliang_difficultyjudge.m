function varargout = bsliang_difficultyjudge(varargin)
% BSLIANG_DIFFICULTYJUDGE MATLAB code for bsliang_difficultyjudge.fig
%      BSLIANG_DIFFICULTYJUDGE, by itself, creates a new BSLIANG_DIFFICULTYJUDGE or raises the existing
%      singleton*.
%
%      H = BSLIANG_DIFFICULTYJUDGE returns the handle to a new BSLIANG_DIFFICULTYJUDGE or the handle to
%      the existing singleton*.
%
%      BSLIANG_DIFFICULTYJUDGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BSLIANG_DIFFICULTYJUDGE.M with the given input arguments.
%
%      BSLIANG_DIFFICULTYJUDGE('Property','Value',...) creates a new BSLIANG_DIFFICULTYJUDGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bsliang_difficultyjudge_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bsliang_difficultyjudge_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bsliang_difficultyjudge

% Last Modified by GUIDE v2.5 14-Sep-2019 17:01:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bsliang_difficultyjudge_OpeningFcn, ...
                   'gui_OutputFcn',  @bsliang_difficultyjudge_OutputFcn, ...
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


% --- Executes just before bsliang_difficultyjudge is made visible.
function bsliang_difficultyjudge_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bsliang_difficultyjudge (see VARARGIN)

set(handles.figure1,'Position',[2079.40000000000,234.600000000000,1172.80000000000,428.800000000000]);

% Choose default command line output for bsliang_difficultyjudge
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bsliang_difficultyjudge wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = bsliang_difficultyjudge_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
out_num=0;
if get(handles.radiobutton1,'Value')==1
    out_num=1;
elseif get(handles.radiobutton2,'Value')==1
    out_num=2;
elseif get(handles.radiobutton3,'Value')==1
    out_num=3;
elseif get(handles.radiobutton4,'Value')==1
    out_num=4;
elseif get(handles.radiobutton5,'Value')==1
    out_num=5;
end
varargout{1} = out_num;
delete(handles.figure1);



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);
