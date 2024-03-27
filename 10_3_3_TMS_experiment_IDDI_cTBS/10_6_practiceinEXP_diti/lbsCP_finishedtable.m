function varargout = lbsCP_finishedtable(varargin)
% LBSCP_FINISHEDTABLE MATLAB code for lbsCP_finishedtable.fig
%      LBSCP_FINISHEDTABLE, by itself, creates a new LBSCP_FINISHEDTABLE or raises the existing
%      singleton*.
%
%      H = LBSCP_FINISHEDTABLE returns the handle to a new LBSCP_FINISHEDTABLE or the handle to
%      the existing singleton*.
%
%      LBSCP_FINISHEDTABLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LBSCP_FINISHEDTABLE.M with the given input arguments.
%
%      LBSCP_FINISHEDTABLE('Property','Value',...) creates a new LBSCP_FINISHEDTABLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before lbsCP_finishedtable_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to lbsCP_finishedtable_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lbsCP_finishedtable

% Last Modified by GUIDE v2.5 02-Dec-2018 18:31:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lbsCP_finishedtable_OpeningFcn, ...
                   'gui_OutputFcn',  @lbsCP_finishedtable_OutputFcn, ...
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


% --- Executes just before lbsCP_finishedtable is made visible.
function lbsCP_finishedtable_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to lbsCP_finishedtable (see VARARGIN)

handles.in1 = varargin{1};
set(handles.showtable,'Data',handles.in1);
% Choose default command line output for lbsCP_finishedtable
handles.output = hObject;



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes lbsCP_finishedtable wait for user response (see UIRESUME)
%uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = lbsCP_finishedtable_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%delete(handles.figure1);


% --- Executes on button press in finishedtable_close.
function finishedtable_close_Callback(hObject, eventdata, handles)
% hObject    handle to finishedtable_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);



function show_ind_graph_Callback(hObject, eventdata, handles)
% hObject    handle to show_ind_graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of show_ind_graph as text
%        str2double(get(hObject,'String')) returns contents of show_ind_graph as a double


% --- Executes during object creation, after setting all properties.
function show_ind_graph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to show_ind_graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
