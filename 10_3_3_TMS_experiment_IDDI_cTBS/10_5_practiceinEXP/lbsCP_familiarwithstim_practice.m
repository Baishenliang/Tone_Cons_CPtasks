function varargout = lbsCP_familiarwithstim_practice(varargin)
% LBSCP_FAMILIARWITHSTIM_PRACTICE MATLAB code for lbsCP_familiarwithstim_practice.fig
%      LBSCP_FAMILIARWITHSTIM_PRACTICE, by itself, creates a new LBSCP_FAMILIARWITHSTIM_PRACTICE or raises the existing
%      singleton*.
%
%      H = LBSCP_FAMILIARWITHSTIM_PRACTICE returns the handle to a new LBSCP_FAMILIARWITHSTIM_PRACTICE or the handle to
%      the existing singleton*.
%
%      LBSCP_FAMILIARWITHSTIM_PRACTICE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LBSCP_FAMILIARWITHSTIM_PRACTICE.M with the given input arguments.
%
%      LBSCP_FAMILIARWITHSTIM_PRACTICE('Property','Value',...) creates a new LBSCP_FAMILIARWITHSTIM_PRACTICE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before lbsCP_familiarwithstim_practice_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to lbsCP_familiarwithstim_practice_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lbsCP_familiarwithstim_practice

% Last Modified by GUIDE v2.5 19-Dec-2018 18:30:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lbsCP_familiarwithstim_practice_OpeningFcn, ...
                   'gui_OutputFcn',  @lbsCP_familiarwithstim_practice_OutputFcn, ...
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


% --- Executes just before lbsCP_familiarwithstim_practice is made visible.
function lbsCP_familiarwithstim_practice_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to lbsCP_familiarwithstim_practice (see VARARGIN)

% Choose default command line output for lbsCP_familiarwithstim_practice
handles.output = hObject;

%for example: soundstim={1,2,3,4};
%for example: soundstim_Tag={'bā(扒)','bá(拔)','pā(趴)','pá(爬)'};

handles.soundstim = varargin{1};
handles.soundstim_Tag = varargin{2};
handles.repeattimes = 5;

num_of_stim=size(handles.soundstim,2);

handles.results=zeros(3,num_of_stim*handles.repeattimes);
handles.trialcount=0;
% 第一行：stim_code；第二行：response；第三行：correct

for miniblock_code = 1:handles.repeattimes
    handles.results(1,((miniblock_code-1)*num_of_stim+1):miniblock_code*num_of_stim)=Shuffle(1:num_of_stim);
end
    
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

set(handles.choice_syllable1,'String',handles.soundstim_Tag{1});
set(handles.choice_syllable2,'String',handles.soundstim_Tag{2});
set(handles.choice_syllable3,'String',handles.soundstim_Tag{3});
set(handles.choice_syllable4,'String',handles.soundstim_Tag{4});

%关闭所有按钮，只显示指导语：
set(handles.play_sound,'Visible','off');
set(handles.choice_syllable1,'Visible','off');
set(handles.choice_syllable2,'Visible','off');
set(handles.choice_syllable3,'Visible','off');
set(handles.choice_syllable4,'Visible','off');

% UIWAIT makes lbsCP_familiarwithstim_practice wait for user response (see UIRESUME)
 uiwait(handles.figure1);

function disable_buttons(handles)
    set(handles.play_sound,'enable','on');
    set(handles.choice_syllable1,'enable','off');
    set(handles.choice_syllable2,'enable','off');
    set(handles.choice_syllable3,'enable','off');
    set(handles.choice_syllable4,'enable','off');

function trial_response(resp,handles,hObject)

handles.results(2,handles.trialcount) = resp;

if handles.results(1,handles.trialcount) ==  resp;
    handles.results(3,handles.trialcount) = 1; %correct
    set(handles.trial_feedback,'String','正确!');
else
    handles.results(3,handles.trialcount) = 0; %incorrect
    set(handles.trial_feedback,'String','错误!');
end

guidata(hObject, handles);

correct_rate_raw=sum(handles.results(3,1:handles.trialcount))/size(handles.results(3,1:handles.trialcount),2);
set(handles.correct_rate,'String',['正确率:',num2str(correct_rate_raw*100),'%']);

if handles.trialcount>=size(handles.results,2)
    set(handles.play_sound,'Enable','off');
    set(handles.close_button,'Visible','on');
    if correct_rate_raw >= 0.9
        set(handles.close_button,'String','关闭(START)');
    else
        set(handles.close_button,'String','关闭(REDO)');
    end
end


% --- Outputs from this function are returned to the command line.
function varargout = lbsCP_familiarwithstim_practice_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
PsychPortAudio('Stop',handles.param);
PsychPortAudio('Close',handles.param);
delete(handles.figure1);


% --- Executes on button press in choice_syllable1.
function choice_syllable1_Callback(hObject, eventdata, handles)
% hObject    handle to choice_syllable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disable_buttons(handles)
trial_response(1,handles,hObject)

% --- Executes on button press in choice_syllable2.
function choice_syllable2_Callback(hObject, eventdata, handles)
% hObject    handle to choice_syllable2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disable_buttons(handles)
trial_response(2,handles,hObject)

% --- Executes on button press in play_sound.
function play_sound_Callback(hObject, eventdata, handles)
% hObject    handle to play_sound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.trialcount=handles.trialcount+1;

set(handles.play_sound,'enable','off');

pause(1);
PsychPortAudio('Start',handles.soundBuffer{1,handles.results(1,handles.trialcount)},1,0);
pause(0.5);
PsychPortAudio('Stop',handles.soundBuffer{1,handles.results(1,handles.trialcount)});

guidata(hObject, handles);
set(handles.trial_feedback,'String',[]);
set(handles.correct_rate,'String',[]);

set(handles.choice_syllable1,'enable','on');
set(handles.choice_syllable2,'enable','on');
set(handles.choice_syllable3,'enable','on');
set(handles.choice_syllable4,'enable','on');


% --- Executes on button press in close_button.
function close_button_Callback(hObject, eventdata, handles)
% hObject    handle to close_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(handles.close_button.String,'开始')
    %关闭所有按钮，只显示指导语：
    set(handles.play_sound,'Visible','on');
    set(handles.choice_syllable1,'Visible','on');
    set(handles.choice_syllable2,'Visible','on');
    set(handles.choice_syllable3,'Visible','on');
    set(handles.choice_syllable4,'Visible','on');
    
    set(handles.close_button,'Visible','off');
    set(handles.close_button,'String','关闭');
    set(handles.text5,'Visible','off');
else
    uiresume(handles.figure1);
end


% --- Executes on button press in choice_syllable3.
function choice_syllable3_Callback(hObject, eventdata, handles)
% hObject    handle to choice_syllable3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disable_buttons(handles)
trial_response(3,handles,hObject)

% --- Executes on button press in choice_syllable4.
function choice_syllable4_Callback(hObject, eventdata, handles)
% hObject    handle to choice_syllable4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disable_buttons(handles)
trial_response(4,handles,hObject)
