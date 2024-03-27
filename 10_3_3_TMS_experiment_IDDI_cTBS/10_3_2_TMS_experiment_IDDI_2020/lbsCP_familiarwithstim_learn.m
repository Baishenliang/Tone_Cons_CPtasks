function varargout = lbsCP_familiarwithstim_learn(varargin)
% LBSCP_FAMILIARWITHSTIM_LEARN MATLAB code for lbsCP_familiarwithstim_learn.fig
%      LBSCP_FAMILIARWITHSTIM_LEARN, by itself, creates a new LBSCP_FAMILIARWITHSTIM_LEARN or raises the existing
%      singleton*.
%
%      H = LBSCP_FAMILIARWITHSTIM_LEARN returns the handle to a new LBSCP_FAMILIARWITHSTIM_LEARN or the handle to
%      the existing singleton*.
%
%      LBSCP_FAMILIARWITHSTIM_LEARN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LBSCP_FAMILIARWITHSTIM_LEARN.M with the given input arguments.
%
%      LBSCP_FAMILIARWITHSTIM_LEARN('Property','Value',...) creates a new LBSCP_FAMILIARWITHSTIM_LEARN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before lbsCP_familiarwithstim_learn_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to lbsCP_familiarwithstim_learn_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lbsCP_familiarwithstim_learn

% Last Modified by GUIDE v2.5 18-Dec-2018 19:28:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lbsCP_familiarwithstim_learn_OpeningFcn, ...
                   'gui_OutputFcn',  @lbsCP_familiarwithstim_learn_OutputFcn, ...
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


% --- Executes just before lbsCP_familiarwithstim_learn is made visible.
function lbsCP_familiarwithstim_learn_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to lbsCP_familiarwithstim_learn (see VARARGIN)

% Choose default command line output for lbsCP_familiarwithstim_learn
handles.output = hObject;

%for example: soundstim={1,2,3,4};
%for example: soundstim_Tag={'bā(扒)','bá(拔)','pā(趴)','pá(爬)'};

handles.soundstim = varargin{1};
handles.soundstim_Tag = varargin{2};

% soundstim is a cell:
% soundstim{1}; soundstim{2}; soundstim{3};....

InitializePsychSound;
deviceID=setDeviceID('subject');
param = PsychPortAudio('Open',deviceID,1+8,2,[],2);          % 主设备（这些参数就这么用OK）
soundBuffer=cell(1,size(handles.soundstim,2)); %这是储存缓冲了的声音文件的buffer
PsychPortAudio('Start',param,0,0);

ajk=load('soundint_k.mat');
adjust_k=ajk.adjust_k*0.5; % 左右耳系数

% 第一行输入slaveID，第二行输入buffer
for soundID=1:size(handles.soundstim,2)
   soundBuffer{1,soundID}=PsychPortAudio('OpenSlave',param,1,2);
   PsychPortAudio('FillBuffer',soundBuffer{1,soundID}, [adjust_k(1)*handles.soundstim{1,soundID}';adjust_k(2)*handles.soundstim{1,soundID}']);
end

handles.param=param;
handles.soundBuffer=soundBuffer;

% Update handles structure
guidata(hObject, handles);

for button_code=1:size(handles.soundstim,2)
    visible_buttons(button_code,handles);
end
    

% UIWAIT makes lbsCP_familiarwithstim_learn wait for user response (see UIRESUME)
uiwait(handles.figure1);

function visible_buttons(button_code,handles)
    eval(['set(handles.playsound_',num2str(button_code),',''Visible'',''on'');']);
    eval(['set(handles.playsound_',num2str(button_code),',''String'',handles.soundstim_Tag{',num2str(button_code),'});']);

% --- Outputs from this function are returned to the command line.
function varargout = lbsCP_familiarwithstim_learn_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
PsychPortAudio('Stop',handles.param);
PsychPortAudio('Close',handles.param);
delete(handles.figure1);

% --- Executes on button press in finish.
function finish_Callback(hObject, eventdata, handles)
% hObject    handle to finish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);

function play_sound(stim_code,handles)
PsychPortAudio('Start',handles.soundBuffer{1,stim_code},1,0);
pause(0.5);
PsychPortAudio('Stop',handles.soundBuffer{1,stim_code});

% --- Executes on button press in playsound_1.
function playsound_1_Callback(hObject, eventdata, handles)
% hObject    handle to playsound_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
play_sound(1,handles)


% --- Executes on button press in playsound_2.
function playsound_2_Callback(hObject, eventdata, handles)
% hObject    handle to playsound_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
play_sound(2,handles)


% --- Executes on button press in playsound_3.
function playsound_3_Callback(hObject, eventdata, handles)
% hObject    handle to playsound_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
play_sound(3,handles)


% --- Executes on button press in playsound_4.
function playsound_4_Callback(hObject, eventdata, handles)
% hObject    handle to playsound_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
play_sound(4,handles)


% --- Executes on button press in playsound_5.
function playsound_5_Callback(hObject, eventdata, handles)
% hObject    handle to playsound_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
play_sound(5,handles)


% --- Executes on button press in playsound_6.
function playsound_6_Callback(hObject, eventdata, handles)
% hObject    handle to playsound_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
play_sound(6,handles)


% --- Executes on button press in playsound_7.
function playsound_7_Callback(hObject, eventdata, handles)
% hObject    handle to playsound_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
play_sound(7,handles)


% --- Executes on button press in playsound_8.
function playsound_8_Callback(hObject, eventdata, handles)
% hObject    handle to playsound_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
play_sound(8,handles)
