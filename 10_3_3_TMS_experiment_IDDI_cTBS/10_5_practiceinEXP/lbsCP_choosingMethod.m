
function varargout = lbsCP_choosingMethod(varargin)
% LBSCP_CHOOSINGMETHOD MATLAB code for lbsCP_choosingMethod.fig
%      LBSCP_CHOOSINGMETHOD, by itself, creates a new LBSCP_CHOOSINGMETHOD or raises the existing
%      singleton*.
%
%      H = LBSCP_CHOOSINGMETHOD returns the handle to a new LBSCP_CHOOSINGMETHOD or the handle to
%      the existing singleton*.
%
%      LBSCP_CHOOSINGMETHOD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LBSCP_CHOOSINGMETHOD.M with the given input arguments.
%
%      LBSCP_CHOOSINGMETHOD('Property','Value',...) creates a new LBSCP_CHOOSINGMETHOD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before lbsCP_choosingMethod_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to lbsCP_choosingMethod_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lbsCP_choosingMethod

% Last Modified by GUIDE v2.5 19-Dec-2018 23:29:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lbsCP_choosingMethod_OpeningFcn, ...
                   'gui_OutputFcn',  @lbsCP_choosingMethod_OutputFcn, ...
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


% --- Executes just before lbsCP_choosingMethod is made visible.
function lbsCP_choosingMethod_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to lbsCP_choosingMethod (see VARARGIN)

global session
session=1;
set(handles.chos_exp1_ses1,'value',1);
% Choose default command line output for lbsCP_choosingMethod
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes lbsCP_choosingMethod wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = lbsCP_choosingMethod_OutputFcn(hObject, eventdata, handles) 

%varargout = [template_filename template];

% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global template save_filename

varargout{1}=save_filename;
varargout{2}=template;

% Get default command line output from handles structure
%varargout = handles.output;
delete(handles.figure1);


% --- Executes on button press in exp1_ses12_OK.
function exp1_ses12_OK_Callback(hObject, eventdata, handles)
% hObject    handle to exp1_ses12_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  template session

%step1_measure_type 这个是测量方法的选择：1是恒定刺激法，2是一上一下阶梯法
%step1_interact_type 这个是交互模式的选择：1是被试用鼠标点按钮（考虑到其实按键盘的模式还有一些界面上的漏洞没解决），2是被试用键盘（z和m键反应）
%stimteplength 这个是整个刺激序列的长度（一般也就是等于stimfile的长度），这个的作用比较多不一一展开

measure_constant=get(handles.exp1_ses12_method_constant,'Value');% 从选项中获知是否选取了恒定刺激法
measure_staircase=get(handles.exp1_ses12_method_staircase,'Value'); %从选项中获知是否选取了阶梯法
disp(['measure_constant=',num2str(measure_constant)]);
disp(['measure_staircase=',num2str(measure_staircase)]);

%以下：根据选择确定测量方法
if measure_constant==1 && measure_staircase==0
    exp1_ses12_measure_type=1; %恒定刺激法
elseif measure_staircase==1 && measure_constant==0
    exp1_ses12_measure_type=2; %阶梯法
end

interact_button=get(handles.exp1_ses12_interact_button,'Value');%从选项中获知是否选取了按钮交互
interact_key=get(handles.exp1_ses12_interact_key,'Value');%从选项中获取是否选取了键盘交互
disp(['interact_button=',num2str(interact_button)]);
disp(['interact_key=',num2str(interact_key)]);

%以下：根据选择确定交互方式
if interact_button==1 && interact_key==0
    exp1_ses12_interact_type=1; %按钮
elseif interact_key==1 && interact_button==0
    exp1_ses12_interact_type=2; %按键
end

template.experiment(1).session(session).type.measure_type=exp1_ses12_measure_type;
template.experiment(1).session(session).type.interact_type=exp1_ses12_interact_type;

if exp1_ses12_measure_type==1
    % method of constant stimuli:
    const_repeat_num=get(handles.const_reptimes,'String');
    const_repeat_num=str2double(const_repeat_num);
    template.experiment(1).session(session).type.constant_para.const_repeat_num=const_repeat_num;
elseif exp1_ses12_measure_type==2
    % method of staircase:
    staircase_stoprunstage=get(handles.staircase_stoprunstage,'String');
    staircase_stoprunstage=str2double(staircase_stoprunstage);
    staircase_stoprunchange=get(handles.staircase_stoprunchange,'String');
    staircase_stoprunchange=str2double(staircase_stoprunchange);
    template.experiment(1).session(session).type.staircase_para.staircase_stoprunstage=staircase_stoprunstage;
    template.experiment(1).session(session).type.staircase_para.staircase_stoprunchange=staircase_stoprunchange;
end

try
if ~isempty(template.experiment(1).session(1).type.measure_type) && ~isempty(template.experiment(1).session(1).type.interact_type) && ~isempty(template.experiment(1).session(2).type.measure_type) && ~isempty(template.experiment(1).session(2).type.interact_type) 
        set(handles.save_new_template_filename,'enable','on');
        set(handles.save_template,'enable','on');
end
catch
end
    
    
function save_new_template_filename_Callback(hObject, eventdata, handles)
% hObject    handle to save_new_template_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of save_new_template_filename as text
%        str2double(get(hObject,'String')) returns contents of save_new_template_filename as a double


% --- Executes during object creation, after setting all properties.
function save_new_template_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to save_new_template_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_template.
function save_template_Callback(hObject, eventdata, handles)
% hObject    handle to save_template (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global template save_filename
filename=get(handles.save_new_template_filename,'String');
save_filename=filename;%{1};
eval(['save ',save_filename,' template;']);
set(handles.save_new_template_filename,'Enable','off');
set(handles.save_template,'Enable','off');
set(handles.start_experiments,'Enable','on');




function template_filename_Callback(hObject, eventdata, handles)
% hObject    handle to template_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of template_filename as text
%        str2double(get(hObject,'String')) returns contents of template_filename as a double


% --- Executes during object creation, after setting all properties.
function template_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to template_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_template.
function load_template_Callback(hObject, eventdata, handles)
% hObject    handle to load_template (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global template template_filename save_filename
try
   template_filename=get(handles.template_filename,'String');
   template_temp=load([template_filename,'.mat']);
   template=template_temp.template;
   set(handles.template_filename,'Enable','off');
   set(handles.load_template,'Enable','off');
    if ~isempty(template.experiment(1).session(1).type.measure_type) && ~isempty(template.experiment(1).session(1).type.interact_type) && ~isempty(template.experiment(1).session(2).type.measure_type) && ~isempty(template.experiment(1).session(2).type.interact_type) 
            set(handles.start_experiments,'enable','on');
            save_filename=template_filename;%{1};
    end
catch
   msgbox('这啥文件，我没找到，你再认真检查一下有没有写错字。');
end
reflesh(handles)


function en_disable_buttons(on_or_off,handles)
   %on_or_off is a string
   %set(handles.chos_exp1_ses1,'enable',on_or_off);
   %set(handles.chos_exp1_ses2,'enable',on_or_off);
   set(handles.exp1_ses12_method_constant,'enable',on_or_off);
   set(handles.exp1_ses12_method_staircase,'enable',on_or_off);
   set(handles.exp1_ses12_interact_button,'enable',on_or_off);
   set(handles.exp1_ses12_interact_key,'enable',on_or_off);
   set(handles.exp1_ses12_OK,'enable',on_or_off);


% --- Executes on button press in chos_exp1_ses1.
function chos_exp1_ses1_Callback(hObject, eventdata, handles)
% hObject    handle to chos_exp1_ses1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chos_exp1_ses1
global session
if ~isempty(session)
    session=1;
end
reflesh(handles)


% --- Executes on button press in chos_exp1_ses2.
function chos_exp1_ses2_Callback(hObject, eventdata, handles)
% hObject    handle to chos_exp1_ses2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chos_exp1_ses2
global session
if ~isempty(session)
    session=2;
end
reflesh(handles)


% --- Executes on button press in load_exist_template.
function load_exist_template_Callback(hObject, eventdata, handles)
% hObject    handle to load_exist_template (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.template_filename,'enable','on');
set(handles.load_template,'enable','on');
en_disable_buttons('off',handles);
global template
template=[];


% --- Executes on button press in new_template.
function new_template_Callback(hObject, eventdata, handles)
% hObject    handle to new_template (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.template_filename,'enable','off');
set(handles.load_template,'enable','off');
en_disable_buttons('on',handles);
global template
template=[];


function reflesh(handles)

    global session template

    try

        show_measure_type=template.experiment(1).session(session).type.measure_type;
        show_interact_type=template.experiment(1).session(session).type.interact_type;

        if show_measure_type==1 
            set(handles.exp1_ses12_method_constant,'value',1);
            dispconst_repeat_num=template.experiment(1).session(session).type.constant_para.const_repeat_num;
            set(handles.const_reptimes,'String',num2str(dispconst_repeat_num));
        elseif show_measure_type==2
            set(handles.exp1_ses12_method_staircase,'value',1);
            dispstaircase_stoprunstage=template.experiment(1).session(session).type.staircase_para.staircase_stoprunstage;
            dispstaircase_stoprunchange=template.experiment(1).session(session).type.staircase_para.staircase_stoprunchange;
            set(handles.staircase_stoprunstage,'String',num2str(dispstaircase_stoprunstage));
            set(handles.staircase_stoprunchange,'String',num2str(dispstaircase_stoprunchange));
        end

        if show_interact_type==1
            set(handles.exp1_ses12_interact_button,'value',1);
        elseif show_interact_type==2
            set(handles.exp1_ses12_interact_key,'value',1);
        end

    catch errorinfo
        
        disp(errorinfo);
        set(handles.exp1_ses12_method_constant,'value',1);
        set(handles.exp1_ses12_interact_button,'value',1);

        set(handles.const_reptimes,'enable','on');
        set(handles.staircase_stoprunstage,'enable','off');
        set(handles.staircase_stoprunchange,'enable','off');
        
    end


% --- Executes on button press in exp1_ses12_interact_key.
function exp1_ses12_interact_key_Callback(hObject, eventdata, handles)
% hObject    handle to exp1_ses12_interact_key (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of exp1_ses12_interact_key


% --- Executes on button press in exp1_ses12_method_constant.
function exp1_ses12_method_constant_Callback(hObject, eventdata, handles)
% hObject    handle to exp1_ses12_method_constant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.const_reptimes,'enable','on');
set(handles.staircase_stoprunstage,'enable','off');
set(handles.staircase_stoprunchange,'enable','off');

% Hint: get(hObject,'Value') returns toggle state of exp1_ses12_method_constant


% --- Executes on button press in start_experiments.
function start_experiments_Callback(hObject, eventdata, handles)
% hObject    handle to start_experiments (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);



function staircase_stoprunstage_Callback(hObject, eventdata, handles)
% hObject    handle to staircase_stoprunstage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of staircase_stoprunstage as text
%        str2double(get(hObject,'String')) returns contents of staircase_stoprunstage as a double


% --- Executes during object creation, after setting all properties.
function staircase_stoprunstage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to staircase_stoprunstage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function staircase_stoprunchange_Callback(hObject, eventdata, handles)
% hObject    handle to staircase_stoprunchange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of staircase_stoprunchange as text
%        str2double(get(hObject,'String')) returns contents of staircase_stoprunchange as a double


% --- Executes during object creation, after setting all properties.
function staircase_stoprunchange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to staircase_stoprunchange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function const_reptimes_Callback(hObject, eventdata, handles)
% hObject    handle to const_reptimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of const_reptimes as text
%        str2double(get(hObject,'String')) returns contents of const_reptimes as a double


% --- Executes during object creation, after setting all properties.
function const_reptimes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to const_reptimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over exp1_ses12_method_constant.
function exp1_ses12_method_constant_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to exp1_ses12_method_constant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over exp1_ses12_method_staircase.
function exp1_ses12_method_staircase_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to exp1_ses12_method_staircase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in exp1_ses12_method_staircase.
function exp1_ses12_method_staircase_Callback(hObject, eventdata, handles)
% hObject    handle to exp1_ses12_method_staircase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.const_reptimes,'enable','off');
set(handles.staircase_stoprunstage,'enable','on');
set(handles.staircase_stoprunchange,'enable','on');

% Hint: get(hObject,'Value') returns toggle state of exp1_ses12_method_staircase
