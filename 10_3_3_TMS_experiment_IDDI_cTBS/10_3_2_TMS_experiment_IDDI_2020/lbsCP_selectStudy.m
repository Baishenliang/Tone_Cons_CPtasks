function varargout = lbsCP_selectStudy(varargin)
% LBSCP_SELECTSTUDY MATLAB code for lbsCP_selectStudy.fig
%      LBSCP_SELECTSTUDY, by itself, creates a new LBSCP_SELECTSTUDY or raises the existing
%      singleton*.
%
%      H = LBSCP_SELECTSTUDY returns the handle to a new LBSCP_SELECTSTUDY or the handle to
%      the existing singleton*.
%
%      LBSCP_SELECTSTUDY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LBSCP_SELECTSTUDY.M with the given input arguments.
%
%      LBSCP_SELECTSTUDY('Property','Value',...) creates a new LBSCP_SELECTSTUDY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before lbsCP_selectStudy_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to lbsCP_selectStudy_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lbsCP_selectStudy

% Last Modified by GUIDE v2.5 02-Jan-2019 15:03:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lbsCP_selectStudy_OpeningFcn, ...
                   'gui_OutputFcn',  @lbsCP_selectStudy_OutputFcn, ...
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


% --- Executes just before lbsCP_selectStudy is made visible.
function lbsCP_selectStudy_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to lbsCP_selectStudy (see VARARGIN)

ha=axes('units','normalized','pos',[0 0 1 1]);
uistack(ha,'down');
ii=imread('starting_PIC.jpg');
image(ii);
colormap gray
set(ha,'handlevisibility','off','visible','off');

% Choose default command line output for lbsCP_selectStudy
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes lbsCP_selectStudy wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = lbsCP_selectStudy_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(handles.figure1);


% --- Executes on selection change in select_study.
function select_study_Callback(hObject, eventdata, handles)
% hObject    handle to select_study (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns select_study contents as cell array
%        contents{get(hObject,'Value')} returns selected item from select_study


% --- Executes during object creation, after setting all properties.
function select_study_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_study (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global study_code study_name
study_code=get(handles.select_study,'value');
if study_code==1
    study_name='原泉MCI实验';
elseif study_code==2
    study_name='梁柏燊CP实验';
end
uiresume(handles.figure1);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
