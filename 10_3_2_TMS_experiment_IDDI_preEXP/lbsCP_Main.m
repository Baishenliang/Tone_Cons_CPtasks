%11��21���������һ�³���

function varargout = lbsCP_Main(varargin)
%���������Matlab�Լ����ɵģ��������������
% LBSCP_MAIN MATLAB code for lbsCP_Main.fig
%      LBSCP_MAIN, by itself, creates a new LBSCP_MAIN or raises the existing
%      singleton*.
%h          
%      H = LBSCP_MAIN returns the handle to a new LBSCP_MAIN or the handle to
%      the existing singleton*.
%
%      LBSCP_MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LBSCP_MAIN.M with the given input arguments.
%
%      LBSCP_MAIN('Property','Value',...) creates a new LBSCP_MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before lbsCP_Main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to lbsCP_Main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lbsCP_Main

% Last Modified by GUIDE v2.5 14-Jun-2019 23:59:46

% Begin initialization code - DO NOT EDIT
%���������Ѷ���
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lbsCP_Main_OpeningFcn, ...
                   'gui_OutputFcn',  @lbsCP_Main_OutputFcn, ...
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


% --- Executes just before lbsCP_Main is made visible.
function lbsCP_Main_OpeningFcn(hObject, eventdata, handles, varargin)
%��������ǵ�������֮ǰ����������һϵ��Ļ������������һһ�ֽ⡣
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to lbsCP_Main (see VARARGIN)

lbsCP_selectStudy();

%����һ���������������������ʱ������ص����б�����Ϣ�����û�еĻ��ʹ���һ����������ᣩ
global STUDY study_name session to_test_substep study_code sub_test_count

sub_test_count=0;
to_test_substep=0;
%===================��Ԥʵ���Ԥʵ�顿==============================
session=1;
%===================��ԭ��session��[]���ĳ���1��==================

set(handles.show_study,'String',study_name)

try %try catch end����ṹ��˼�ǳ�����һЩ���飬�������Ļ���������catch����Ĵ��롣
    %���Լ�����ʷ��¼��'STUDY'���Ǵ��������б�����Ϣ�ͽ�����ļ�
    study_data=load('DATA.mat');%����
    STUDY=study_data.STUDY;%�����һ�������ݽṹ������ת������Ϊ������֮������ʵ�ǡ���������������
            
    set(handles.step1_session1,'enable','on');
    set(handles.step1_session2,'enable','on');
    set(handles.par_info_code,'enable','on');
    set(handles.par_info_reload,'enable','on');
    
    STUDY(study_code)
            
catch
    
    set(handles.step1_session1,'enable','off');
    set(handles.step1_session2,'enable','off');
    set(handles.par_info_code,'enable','off');
    set(handles.par_info_reload,'enable','off');
    
    STUDY(study_code).participant=[];
    STUDY(study_code).type=[];
    save DATA STUDY
    %û����ʷ��¼�ļ�������һ��
end

refresh_show_method(handles);


%��������д����ǵ����Լ����ɵģ�����
% Choose default command line output for lbsCP_Main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes lbsCP_Main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function refresh_show_method(handles)
    
    global template STUDY study_code
    
    try
        template_filename=STUDY(study_code).type.templatename;
        template_temp=load([template_filename,'.mat']);
        template=template_temp.template;

        set(handles.show_method_template_filename,'String',template_filename);

        show_measure_type(1)=template.experiment(1).session(1).type.measure_type;
        show_interact_type(1)=template.experiment(1).session(1).type.interact_type;
        show_measure_type(2)=template.experiment(1).session(2).type.measure_type;
        show_interact_type(2)=template.experiment(1).session(2).type.interact_type;

        STUDY(study_code).type.experiment(1).session(1).measure_type=show_measure_type(1);
        STUDY(study_code).type.experiment(1).session(2).measure_type=show_measure_type(2);
        STUDY(study_code).type.experiment(1).session(1).interact_type=show_interact_type(1);
        STUDY(study_code).type.experiment(1).session(2).interact_type=show_interact_type(2);


        if show_measure_type(1)==1
            set(handles.show_method_exp1_ses1,'String','�㶨�̼���');
            STUDY(study_code).type.experiment(1).session(1).constant_para.const_repeat_num=template.experiment(1).session(1).type.constant_para.const_repeat_num;
        elseif show_measure_type(1)==2
            set(handles.show_method_exp1_ses1,'String','���½��ݷ�');
            STUDY(study_code).type.experiment(1).session(1).staircase_para.staircase_stoprunstage=template.experiment(1).session(1).type.staircase_para.staircase_stoprunstage;
            STUDY(study_code).type.experiment(1).session(1).staircase_para.staircase_stoprunchange=template.experiment(1).session(1).type.staircase_para.staircase_stoprunchange;
        end

        if show_measure_type(2)==1
            set(handles.show_method_exp1_ses2,'String','�㶨�̼���');
            STUDY(study_code).type.experiment(1).session(2).constant_para.const_repeat_num=template.experiment(1).session(2).type.constant_para.const_repeat_num;
        elseif show_measure_type(2)==2
            set(handles.show_method_exp1_ses2,'String','���½��ݷ�');
            STUDY(study_code).type.experiment(1).session(2).staircase_para.staircase_stoprunstage=template.experiment(1).session(2).type.staircase_para.staircase_stoprunstage;
            STUDY(study_code).type.experiment(1).session(2).staircase_para.staircase_stoprunchange=template.experiment(1).session(2).type.staircase_para.staircase_stoprunchange;
        end

        if show_interact_type(1)==1
            set(handles.show_interact_exp1_ses1,'String','��Ļ��ť');
        elseif show_interact_type(1)==2
            set(handles.show_interact_exp1_ses1,'String','���̰���');
        end

        if show_interact_type(2)==1
            set(handles.show_interact_exp1_ses2,'String','��Ļ��ť');
        elseif show_interact_type(2)==2
            set(handles.show_interact_exp1_ses2,'String','���̰���');
        end

        save DATA STUDY
    catch
    end


% --- Outputs from this function are returned to the command line.
function varargout = lbsCP_Main_OutputFcn(hObject, eventdata, handles) 
%�������������Լ����ɵĺ���
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function step1_1_editstimfile_CreateFcn(hObject, eventdata, handles)
%�������������Լ����ɵĺ���
% hObject    handle to step1_1_editstimfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function par_name_Callback(hObject, eventdata, handles)
% hObject    handle to par_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of par_name as text
%        str2double(get(hObject,'String')) returns contents of par_name as a double


% --- Executes during object creation, after setting all properties.
function par_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function par_age_Callback(hObject, eventdata, handles)
% hObject    handle to par_age (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of par_age as text
%        str2double(get(hObject,'String')) returns contents of par_age as a double


% --- Executes during object creation, after setting all properties.
function par_age_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par_age (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_girl.
function radiobutton_girl_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_girl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_girl


% --- Executes on button press in radiobutton_boy.
function radiobutton_boy_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_boy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_boy


function par_info_code_Callback(hObject, eventdata, handles)
% hObject    handle to par_info_code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of par_info_code as text
%        str2double(get(hObject,'String')) returns contents of par_info_code as a double


% --- Executes during object creation, after setting all properties.
function par_info_code_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par_info_code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in par_info_reload.
function par_info_reload_Callback(hObject, eventdata,handles)

% hObject    handle to par_info_reload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global session
session=1;
set(handles.step1_session1,'Value',1);
load_history_data(handles)


function load_history_data(handles)
global  STUDY study_code par_code
% par_code��һ��������ʵ������е�ʶ���룬participant�����б��Ե���Ϣ 
par_code=get(handles.par_info_code,'String');
par_code=str2double(par_code);

try
    %���Դ���ʷ��¼�ж�ȡ������Ϣ�����Ҽ��ص��û�������
    set(handles.par_name,'String',STUDY(study_code).participant(par_code).par_name); %��������
    set(handles.par_age,'String',num2str(STUDY(study_code).participant(par_code).par_age)); %��������
    
    %����Ϊ��ȡ�Ա�
    if STUDY(study_code).participant(par_code).par_gender==1 %1����Ů
        set(handles.radiobutton_girl,'Value',1);
        set(handles.radiobutton_boy,'Value',0);
    elseif STUDY(study_code).participant(par_code).par_gender==2 %2������
        set(handles.radiobutton_girl,'Value',0);
        set(handles.radiobutton_boy,'Value',1);
    end
    %����Ϊ��ȡ���
    if STUDY(study_code).participant(par_code).par_group==1 %1����ʵ����
        set(handles.radiobutton_exp,'Value',1);
        set(handles.radiobutton_ctr,'Value',0);
    elseif STUDY(study_code).participant(par_code).par_group==2 %2���������
        set(handles.radiobutton_exp,'Value',0);
        set(handles.radiobutton_ctr,'Value',1);
    end
    set(handles.beizhu_edit,'String',STUDY(study_code).participant(par_code).beizhu);%��ע
    %���ϣ���������ϸ��Ϣ��������ʷ��¼������
    
    set(handles.par_name,'Enable','off'); %����һ�����룬���ܸ�
    set(handles.par_age,'Enable','off'); %����һ�����룬���ܸ�
    set(handles.radiobutton_girl,'Enable','off'); %�Ա��ܸ�
    set(handles.radiobutton_boy,'Enable','off');
    set(handles.radiobutton_exp,'Enable','off'); %����ܸ�
    set(handles.radiobutton_ctr,'Enable','off');
    set(handles.par_info_OK,'Enable','off'); %���ܰ�OK������
    set(handles.beizhu_edit,'Enable','on');%�����ñ��Եı�עҳ��
    set(handles.beizhu_save,'Enable','on');%�����ñ��Եı�ע���水ť
    %���ϣ�disable��ϸ��Ϣ���޸Ĺ��ܣ����Ҫ�޸ı�����Ϣ����Ҫ�ֶ��޸�struct���߽���һ���µı��Ա��
    
    enable_test_module(handles);
    %���ϣ����ݱ��Խ���������ģ�顣
    
catch 
    %������һ�����������ŵı�������������£���Ҫ���뱻����Ϣ��Ȼ��ȷ����
    set(handles.par_name,'Enable','on');
    set(handles.par_age,'Enable','on');
    set(handles.radiobutton_girl,'Enable','on');
    set(handles.radiobutton_boy,'Enable','on');
    set(handles.radiobutton_exp,'Enable','on');
    set(handles.radiobutton_ctr,'Enable','on');
    set(handles.par_info_OK,'Enable','on');
    %���ϣ������ʷ��¼��û�иñ��ԣ�������������Կ������뱻�Եĸ�����Ϣ
    
    set(handles.par_name,'String',[]);
    set(handles.beizhu_edit,'String',[]);
    set(handles.par_age,'String',[]);
    %set(handles.step1_method_staircase,'Value',1);
    %set(handles.step1_interact_button,'Value',1);
    set(handles.radiobutton_girl,'Value',1);
    set(handles.radiobutton_exp,'Value',1);
    %���ϣ�������Ϣ������������ԭ�����ڵĶ���
    set(handles.beizhu_edit,'Enable','off');
    set(handles.beizhu_save,'Enable','off');
    %���ϣ��ص���ע���ںͱ��水ť

end


function enable_test_module(handles)
    global session par_code STUDY study_code
    try
        %�����������������ʷ��¼��������ָʾ������������ı��Զ��ԣ�ȥ����Ͳ�������Ե��Ӵ���
        %������������һЩ��Ŀ����ô���ȣ�������ָʾ�����ʾ������Щ����ˣ�Ȼ����������Ǳ��ԵĽ����Ϣ��ȷ����Щ������Ҫ��������Ϊ�գ��򼤻�ڣ�
        if ~isempty(session)
            if session == 1
                set(handles.step1_1_editstimfile,'String','di1_di2.mat');
                set(handles.step1_2_editstimfile,'String','di2_ti2.mat');
                set(handles.step1_3_editstimfile,'String','ti1_ti2.mat');
                set(handles.step1_4_editstimfile,'String','di1_ti1.mat');                
            elseif session ==2
                if study_code==1 %������
                    set(handles.step1_1_editstimfile,'String','T_old_BEHAV.mat');
                    set(handles.step1_2_editstimfile,'String','P_old_BEHAV.mat');
                    set(handles.step1_3_editstimfile,'String','T_old_BEHAV.mat');
                    set(handles.step1_4_editstimfile,'String','P_old_BEHAV.mat'); 
                elseif study_code==2 %������
                    set(handles.step1_1_editstimfile,'String','T_old_BEHAV.mat');
                    set(handles.step1_2_editstimfile,'String','P_old_BEHAV.mat');
                    set(handles.step1_3_editstimfile,'String','T_old_BEHAV.mat');
                    set(handles.step1_4_editstimfile,'String','P_old_BEHAV.mat'); 
                end
%                 set(handles.step1_3_OK,'enable','off');
%                 set(handles.step1_4_OK,'enable','off');
            end
            set(handles.step1_1_order,'String',num2str(STUDY(study_code).participant(par_code).result_struct.experiment(1).session(session).order(1)));
            set(handles.step1_2_order,'String',num2str(STUDY(study_code).participant(par_code).result_struct.experiment(1).session(session).order(2)));
            set(handles.step1_3_order,'String',num2str(STUDY(study_code).participant(par_code).result_struct.experiment(1).session(session).order(3)));
            set(handles.step1_4_order,'String',num2str(STUDY(study_code).participant(par_code).result_struct.experiment(1).session(session).order(4)));
            temp_is_on=zeros(1,4);
            for is_on_step=1:4
                temp_is_on(is_on_step)=(STUDY(study_code).participant(par_code).result_struct.experiment(1).session(session).steps(is_on_step).isfinished==0);
            end
            reflesh_substeps(handles,temp_is_on,1);
        end
    catch    
    end
    
   
    %���ϣ����ָ���finished struct�������Ƿ�򿪵������Ե���ģ�� 
    function reflesh_substeps(handles,is_on,is_data)
        global participant par_code session
        if session == 1
            reflesh_substeps_endpoint=4;
        elseif session == 2
            reflesh_substeps_endpoint=4;
        end
        for step_session=1:reflesh_substeps_endpoint
            if is_on(step_session)
                %==================��Ԥʵ���Ԥʵ�顿==================================================
                eval(['set(handles.step1_',num2str(step_session),'_editstimfile,''enable'',''off'');']);
                %=======================����on�ĳ���off��==============================================
                eval(['set(handles.step1_',num2str(step_session),'_OK,''enable'',''on'');']);
                eval(['set(handles.step1_',num2str(step_session),'_cleardata,''enable'',''off'');']);
            else
                eval(['set(handles.step1_',num2str(step_session),'_editstimfile,''enable'',''off'');']);
                eval(['set(handles.step1_',num2str(step_session),'_OK,''enable'',''off'');']);
                if is_data
                    eval(['set(handles.step1_',num2str(step_session),'_cleardata,''enable'',''on'');']);
                else
                    eval(['set(handles.step1_',num2str(step_session),'_cleardata,''enable'',''off'');']);
                end
            end
        end


% --- Executes on button press in par_info_OK.
function par_info_OK_Callback(hObject, eventdata, handles)
% �������뱻����Ϣʱ��OK�������ڴ������Ըո�����ı�����Ϣ
% ֻ��һ������������ť�ᱻ���ã���ʷ��¼û�������ŵı���
global par_code STUDY study_code

    %ͬ�����Ǽ��ر��Եı�źͱ��ԵĽ����¼
    STUDY(study_code).participant(par_code).par_name=get(handles.par_name,'String'); %��ʱ���汻������
    STUDY(study_code).participant(par_code).par_age=str2double(get(handles.par_age,'String')); %��ʱ���汻������
    
    is_girl=get(handles.radiobutton_girl,'Value');
    is_boy=get(handles.radiobutton_boy,'Value');
    if is_girl && ~is_boy
        STUDY(study_code).participant(par_code).par_gender=1;
    elseif is_boy && ~is_girl
        STUDY(study_code).participant(par_code).par_gender=2;
    end
    %���ϣ����汻���Ա���Ϣ
    
    is_exp=get(handles.radiobutton_exp,'Value');
    is_ctr=get(handles.radiobutton_ctr,'Value');
    if is_exp && ~is_ctr
        STUDY(study_code).participant(par_code).par_group=1;
    elseif is_ctr && ~is_exp
        STUDY(study_code).participant(par_code).par_group=2;
    end
    %���ϣ����汻�������Ϣ
    
    for session_temp=1:2
        if session_temp==1
            STUDY(study_code).participant(par_code).result_struct.experiment(1).session(session_temp).order=Shuffle([1 2 3 4]);
        elseif session_temp==2
            STUDY(study_code).participant(par_code).result_struct.experiment(1).session(session_temp).order=select_latin_square({'T_old_BEHAV','P_old_BEHAV','T_old_noise_BEHAV','P_old_noise_BEHAV'},par_code,'Latin');
            %Shuffle([1 2 3 4]);%[Shuffle([1 2]),0,0];
            %left_right_hand=input('Please input participant''s response hand code (����ʳָ(1)������ָ(2)ѡ��һ����b):');
        end
        STUDY(study_code).participant(par_code).result_struct.experiment(1).session(session_temp).type=[];
        STUDY(study_code).participant(par_code).result_struct.experiment(1).session(session_temp).steps(1).isfinished=0;
        STUDY(study_code).participant(par_code).result_struct.experiment(1).session(session_temp).steps(2).isfinished=0;
        STUDY(study_code).participant(par_code).result_struct.experiment(1).session(session_temp).steps(3).isfinished=0;
        STUDY(study_code).participant(par_code).result_struct.experiment(1).session(session_temp).steps(4).isfinished=0;
    end
    STUDY(study_code).participant(par_code).result_struct.step2=[];
    STUDY(study_code).participant(par_code).result_struct.step3=[];
    STUDY(study_code).participant(par_code).result_struct.step4=[];
    STUDY(study_code).participant(par_code).result_struct.step5=[];
    STUDY(study_code).participant(par_code).beizhu=[];
    
    %���ϣ����±��Ե�������ָʾ���й����������ȡ�����Ѿ�����˵����񣬲�����ʱ���浽������У�zero_to_empty�����Լ���ĺ�������������棩
  
 
    save DATA STUDY 
    % ����������ı�����Ϣ
    
    load_history_data(handles);
    %���ϣ�����ָʾ�������ģ��
    
    set(handles.par_name,'Enable','off');
    set(handles.par_age,'Enable','off');
    set(handles.radiobutton_girl,'Enable','off');
    set(handles.radiobutton_boy,'Enable','off');
    set(handles.radiobutton_exp,'Enable','off');
    set(handles.radiobutton_ctr,'Enable','off');
    set(handles.par_info_OK,'Enable','off');
    %����ȷ�ϼ��󣬱�����Ϣ�������޸ģ���Ҫ�޸ģ���Ҫ��MATLAB�������ļ��ֹ��ģ�
    

% hObject    handle to par_info_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function [returned_value]=zero_to_empty(value)
%����get������ָʾ���е�1��0��ֵʱ��0ת��Ϊ��ֵ�����������±���ʱ��������������mark��
    if value==0
        returned_value=[];
    else
        returned_value=value;
    end


% --- Executes on button press in step1_cleardata.
% function step1_cleardata_Callback(hObject, eventdata, handles)
% % hObject    handle to step1_cleardata (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% cleardata(0,0,0,handles,1)


function yes_clear_step(~,~,to_be_clear_experiment,to_be_clear_session,to_be_clear_step,handles,clear_all)
    %���Ǳ���Ҫ������ݵİ�ť�����ĺ���
    global fclear STUDY study_code par_code session
    if ~clear_all
        %������Ҫ�����������
        STUDY(study_code).participant(par_code).result_struct.experiment(to_be_clear_experiment).session(to_be_clear_session).steps(to_be_clear_step).isfinished=0; %�������Ŀ�Ľ��
    else
        %������step���������ݣ�
        STUDY(study_code).participant(par_code).result_struct.experiment(to_be_clear_experiment).session(session).type=[];
        STUDY(study_code).participant(par_code).result_struct.experiment(to_be_clear_experiment).session(session).steps(1).isfinished=0;
        STUDY(study_code).participant(par_code).result_struct.experiment(to_be_clear_experiment).session(session).steps(2).isfinished=0;
        STUDY(study_code).participant(par_code).result_struct.experiment(to_be_clear_experiment).session(session).steps(3).isfinished=0;
        STUDY(study_code).participant(par_code).result_struct.experiment(to_be_clear_experiment).session(session).steps(4).isfinished=0;
        
    end
    save DATA STUDY ; %����������
    load_history_data(handles); %���¼���һ�α�����Ϣ
    close(fclear); %�ص���������
    
function no_clear_step(~,~)
    %�����������ѡ��������ݵİ�ť�����ĺ���
    global fclear
    close(fclear);



function step1_1_editstimfile_Callback(hObject, eventdata, handles)
% hObject    handle to step1_1_editstimfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of step1_1_editstimfile as text
%        str2double(get(hObject,'String')) returns contents of step1_1_editstimfile as a double



function step1_2_editstimfile_Callback(hObject, eventdata, handles)
% hObject    handle to step1_2_editstimfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of step1_2_editstimfile as text
%        str2double(get(hObject,'String')) returns contents of step1_2_editstimfile as a double


% --- Executes during object creation, after setting all properties.
function step1_2_editstimfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step1_2_editstimfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function step1_3_editstimfile_Callback(hObject, eventdata, handles)
% hObject    handle to step1_3_editstimfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of step1_3_editstimfile as text
%        str2double(get(hObject,'String')) returns contents of step1_3_editstimfile as a double


% --- Executes during object creation, after setting all properties.
function step1_3_editstimfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step1_3_editstimfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function step1_4_editstimfile_Callback(hObject, eventdata, handles)
% hObject    handle to step1_4_editstimfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of step1_4_editstimfile as text
%        str2double(get(hObject,'String')) returns contents of step1_4_editstimfile as a double


% --- Executes during object creation, after setting all properties.
function step1_4_editstimfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step1_4_editstimfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%function run after "OK" keys in step1 are pressed��
function step1_OK_pressed(handles)
global stimfilename stimfile
% stimfilename������Ĵ̼��ļ����֣�stimfile���Ǵ���̼��ı���

% ���stimfile��ÿ��session�ж���һ��
try
    %�����ܲ��ܼ������stimfile
    stimfile=load(stimfilename);
    stimfile=stimfile.stim_continuum;%���������֮ǰ��һ���������ɵģ���ʽ�Ҷ������ˣ�ֻ�ܵ��þ�OK��
catch
    disp('��Ч����!');%�ļ������ڣ����򲻻ᱬը
end
% Zjudge_test��Mjudge_test��ÿ��session�в�һ��

global randomorder stimsteplength measure_type interact_type STUDY par_code session step to_test_substep study_code staircase_stoprunstage staircase_stoprunchange
%��������������
%randomorder �����ר�Ÿ����㶨�̼������õ�������У���˴̼���1-21����˳���Ų��ģ���randomorder��������������ŵ�Ҫ��
%Zjudge_text ����ǵ�һ���жϰ�ť���������Ҫô��/di1/,Ҫô��/һ��/
%Mjudge_text ����ǵڶ����жϰ�ť���������Ҫô��/ti1/,Ҫô��/����/
%stimteplength ����������̼����еĳ��ȣ�һ��Ҳ���ǵ���stimfile�ĳ��ȣ�����������ñȽ϶಻һһչ��

%�����ʹ�ú㶨�̼�����ÿ���̼������Գ���5�Σ�����˳�����
%randomorder=Shuffle(repmat(1:size(stimfile,2),1,3));
%[20190428:����ͬ���̼��ظ�����]
randomorder=[];
const_reptimes=3;
for const_rep=1:const_reptimes
    randomorder=[randomorder,Shuffle(1:size(stimfile,2))];
end

%��������ָ�ظ����Σ��������Ѿ���bug�ˣ���Ϊ���3��������template��������õģ���������Ҫ�����ֶ����ˡ�o(�i�n�i)o
%���ڽ��е��ǽ��ݷ���step1_measure_type=2��
stimsteplength=size(stimfile,2);
%�������д̼�������=stimfile�ĳ���

step=1;
measure_type(1)=STUDY(study_code).type.experiment(1).session(session).measure_type;
interact_type(1)=STUDY(study_code).type.experiment(1).session(session).interact_type;
staircase_stoprunstage(1)=STUDY(study_code).type.experiment(1).session(1).staircase_para.staircase_stoprunstage;
staircase_stoprunchange(1)=STUDY(study_code).type.experiment(1).session(1).staircase_para.staircase_stoprunchange;


load_history_data(handles); 

output=lbsCP_parScreen();
% output������������ɣ�{[],[]}����ϸ�����ݣ����ұߵ�[]�Ǳ��Ե���ֵ
%��������������������������������staircaseģʽ������constant stimuli��������Ҫд��һ��if������=��=��

%varargout{1}.threshold_boundaries=threshold_boundaries;

if isempty(output.threshold_boundaries{1}) && isempty(output.threshold_boundaries{2})
    STUDY(study_code).participant(par_code).result_struct.experiment(1).session(session).steps(to_test_substep).isfinished=0;
else
    STUDY(study_code).participant(par_code).result_struct.experiment(1).session(session).steps(to_test_substep).isfinished=1;
end


STUDY(study_code).participant(par_code).result_struct.experiment(1).session(session).steps(to_test_substep).rawdata=output.rawdata;
STUDY(study_code).participant(par_code).result_struct.experiment(1).session(session).steps(to_test_substep).half_threshold=output.half_threshold;
STUDY(study_code).participant(par_code).result_struct.experiment(1).session(session).steps(to_test_substep).threshold_boundaries=output.threshold_boundaries;

save DATA STUDY
save(['result_datamat\DATA_',strrep(strrep(strrep(datestr(now),':','_'),' ','_'),'-','_')],'STUDY');
load_history_data(handles); 



% --- Executes on button press in step1_1_OK.
function step1_1_OK_Callback(hObject, eventdata, handles)

% hObject    handle to step1_1_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stimfilename
% stimfilename������Ĵ̼��ļ����֣�stimfile���Ǵ���̼��ı���
stimfilename = get(handles.step1_1_editstimfile,'String');%���������get�ļ�����һ���������Ͳ��������ˡ�

global Zjudge_text Mjudge_text to_test_substep session addnoise sub_test_count
sub_test_count=sub_test_count+1;
to_test_substep=1;
addnoise=0;

%��������������
%Zjudge_text ����ǵ�һ���жϰ�ť���������Ҫô��/di1/,Ҫô��/һ��/
%Mjudge_text ����ǵڶ����жϰ�ť���������Ҫô��/ti1/,Ҫô��/����/

%���ߵ���������Ӧ���ֱ���ʲô����

if session == 1
    Zjudge_text='d��(��)';
    Mjudge_text='d��(��)';
elseif session == 2
    Zjudge_text='��(��/ſ)';
    Mjudge_text='��(��/��)';   
end

step1_OK_pressed(handles);

function cleardata(to_be_clear_experiment,to_be_clear_session,to_be_clear_step,handles,clear_all)
   global  fclear 
    fclear=figure('position',[100,100,200,100]);
    %����һ���������ڣ�Ҫ��������˼�����У���֤�����󰴣�
    uicontrol('Style','text','String','ȷ������������һ��ǰ�����ݲ���ɾ����','Position',[0,-25,200,100]);
    uicontrol('Style','pushbutton','String','�ǵ���Ҫ����','Position',[0,0,100,50],'Callback',{@yes_clear_step,to_be_clear_experiment,to_be_clear_session,to_be_clear_step,handles,clear_all});
    uicontrol('Style','pushbutton','String','���һ���ȵ�','Position',[100,0,100,50],'Callback',{@no_clear_step});


% --- Executes on button press in step1_1_cleardata.
function step1_1_cleardata_Callback(hObject, eventdata, handles)
% ����Ǵ���������������ݰ�ť����������˼���ǣ����������һ�β��Ի��ˣ���������ˣ����ǻ���Ҫ������һ�飬��ô�Ͱ�һ�������ť�ﵽ
% �ָ��������õĹ�Ч��
% hObject    handle to step1_1_cleardata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global session
   cleardata(1,session,1,handles,0);

% --- Executes on button press in step1_2_OK.
function step1_2_OK_Callback(hObject, eventdata, handles)
% hObject    handle to step1_2_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stimfilename
stimfilename = get(handles.step1_2_editstimfile,'String');%���������get�ļ�����һ���������Ͳ��������ˡ�

global Zjudge_text Mjudge_text to_test_substep session addnoise sub_test_count
sub_test_count=sub_test_count+1;
to_test_substep=2;
addnoise=0;

if session == 1
    Zjudge_text='d��(��)';
    Mjudge_text='t��(��)';
elseif session ==2
    Zjudge_text='b(��/��)';
    Mjudge_text='p(ſ/��)';  
end
step1_OK_pressed(handles);


% --- Executes on button press in step1_2_cleardata.
function step1_2_cleardata_Callback(hObject, eventdata, handles)
% hObject    handle to step1_2_cleardata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global session
cleardata(1,session,2,handles,0);

% --- Executes on button press in step1_3_OK.
function step1_3_OK_Callback(hObject, eventdata, handles)
% hObject    handle to step1_3_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stimfilename to_test_substep addnoise sub_test_count
sub_test_count = sub_test_count + 1;
to_test_substep=3;
addnoise=0;%[20190531�ĳ���0]

stimfilename = get(handles.step1_3_editstimfile,'String');%���������get�ļ�����һ���������Ͳ��������ˡ�

global Zjudge_text Mjudge_text session 
if session == 1
    Zjudge_text='t��(��)';
    Mjudge_text='t��(��)';
elseif session == 2
    Zjudge_text='��';
    Mjudge_text='��';   
end

step1_OK_pressed(handles);

% --- Executes on button press in step1_3_cleardata.
function step1_3_cleardata_Callback(hObject, eventdata, handles)
% hObject    handle to step1_3_cleardata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global session
cleardata(1,session,3,handles,0);

% --- Executes on button press in step1_4_OK.
function step1_4_OK_Callback(hObject, eventdata, handles)
% hObject    handle to step1_4_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stimfilename to_test_substep session addnoise sub_test_count
sub_test_count = sub_test_count + 1;
to_test_substep=4;
addnoise=0;%[20190531��Ϊ0]

stimfilename = get(handles.step1_4_editstimfile,'String');%���������get�ļ�����һ���������Ͳ��������ˡ�

global Zjudge_text Mjudge_text
if session == 1
    Zjudge_text='d��(��)';
    Mjudge_text='t��(��)';
elseif session ==2
    Zjudge_text='b';
    Mjudge_text='p';  
end
step1_OK_pressed(handles);

% --- Executes on button press in step1_4_cleardata.
function step1_4_cleardata_Callback(hObject, eventdata, handles)
% hObject    handle to step1_4_cleardata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global session
cleardata(1,session,4,handles,0);


function beizhu_edit_Callback(hObject, eventdata, handles)
% hObject    handle to beizhu_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of beizhu_edit as text
%        str2double(get(hObject,'String')) returns contents of beizhu_edit as a double


% --- Executes during object creation, after setting all properties.
function beizhu_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beizhu_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in beizhu_save.
function beizhu_save_Callback(hObject, eventdata, handles)
global STUDY study_code par_code
% hObject    handle to beizhu_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
STUDY(study_code).participant(par_code).beizhu=get(handles.beizhu_edit,'String');
save DATA STUDY


% --- Executes on button press in step1_session1.
function step1_session1_Callback(hObject, eventdata, handles)
% hObject    handle to step1_session1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of step1_session1
global session
if ~isempty(session)
    session=1;
end
enable_test_module(handles)

function step1_session2_Callback(hObject, eventdata, handles)
% hObject    handle to step1_session1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of step1_session1
global session
if ~isempty(session)
    session=2;
end
enable_test_module(handles)



function stat_cho_par_Callback(hObject, eventdata, handles)
% hObject    handle to stat_cho_par (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stat_cho_par as text
%        str2double(get(hObject,'String')) returns contents of stat_cho_par as a double


% --- Executes during object creation, after setting all properties.
function stat_cho_par_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stat_cho_par (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stat_cho_PMF.
function stat_cho_PMF_Callback(hObject, eventdata, handles)
% hObject    handle to stat_cho_PMF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stat_cho_PMF


% --- Executes on button press in stat_cho_GD.
function stat_cho_GD_Callback(hObject, eventdata, handles)
% hObject    handle to stat_cho_GD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stat_cho_GD


% --- Executes on button press in stat_OK.
function stat_OK_Callback(hObject, eventdata, handles)
% hObject    handle to stat_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  stat_par_info_struct
stat_chos_step_var=get(handles.stat_chos_step,'value');
stat_chos_item_var=get(handles.stat_chos_item,'String');
[stat_group_data,stat_text_show]=load_group_stat(1,1,stat_chos_step_var,stat_chos_item_var,stat_par_info_struct,handles);
plot_stat_results(1,30,stat_group_data.exp.rawdata,stat_group_data.exp.codelist,stat_group_data.exp.namelist,stat_group_data.ctr.rawdata,stat_group_data.ctr.codelist,stat_group_data.ctr.namelist)
plot_stat_results(2,30,stat_group_data.exp.rawdata,stat_group_data.exp.codelist,stat_group_data.exp.namelist,stat_group_data.ctr.rawdata,stat_group_data.ctr.codelist,stat_group_data.ctr.namelist)

lbsCP_finishedtable(stat_text_show)

function plot_stat_results(direction,xcut,exp_raw,exp_code,exp_name,ctr_raw,ctr_code,ctr_name)
    figure;
    hold on
    for par=1:size(exp_raw,1)
    temp_exp=plot(xcut:size(exp_raw{par,direction},1),exp_raw{par,direction}(xcut:end,2),'r');
    text(size(exp_raw{par,direction},1),exp_raw{par,direction}(end,2),[num2str(exp_code(par)),' ',exp_name{par}],'Color',[1 0 0]);
    end
    for par=1:size(ctr_raw,1)
    temp_ctr=plot(xcut:size(ctr_raw{par,direction},1),ctr_raw{par,direction}(xcut:end,2),'b');
    text(size(ctr_raw{par,direction},1),ctr_raw{par,direction}(end,2),[num2str(ctr_code(par)),' ',ctr_name{par}],'Color', [0 0 1]);
    end    
    hold off
    try
    legend([temp_exp temp_ctr],'ʵ����','������');
    catch
    end
    xlabel('trials');
    ylabel('steps');
    title('��������ͼ');
        


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over step1_session1.
function step1_session1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to step1_session1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% Hint: get(hObject,'Value') returns toggle state of stat_cho_step1_1

function [group_data,text_show]=load_group_stat(experiment,session,step,item,stat_par_info_struct,handles)
    
        global STUDY study_code

%         %=======================���ڴ������������=====================================
%         for par_code_i_test=2:7
%             if mod(par_code_i_test,2)==0
%                 %�������10~15��
%                 score_test=unifrnd(10,15);
%             else
%                 %ʵ�����10~25��
%                 score_test=unifrnd(20,25);
%             end
%             STUDY(study_code).participant(par_code_i_test).result_struct.experiment(1).session(1).steps(1).isfinished=1;
%             STUDY(study_code).participant(par_code_i_test).result_struct.experiment(1).session(1).steps(1).rawdata={[],[]};
%             STUDY(study_code).participant(par_code_i_test).result_struct.experiment(1).session(1).steps(1).half_threshold=score_test;
%         end
%         %=============================================================================

        measure_type=STUDY(study_code).type.experiment(experiment).session(session).measure_type;
        if measure_type==2 % ���ݷ������ܻ������������ߣ���ʵ�ǿ��Եģ�����ʱû��Ϥ������ף�
        elseif measure_type==1 %�㶨�̼��������Ի�������������
            group_data.PMF_raw.exp=[];
            group_data.PMF_raw.ctr=[];
        end
        
        group_data.exp.rawdata=[];
        group_data.exp.this_threshold=[];
        group_data.exp.codelist=[];
        group_data.exp.namelist=[];
        
        group_data.ctr.rawdata=[];
        group_data.ctr.this_threshold=[];
        group_data.ctr.codelist=[];
        group_data.ctr.namelist=[];
        
        for par_i=1:size(stat_par_info_struct,2)
             this_step_data=stat_par_info_struct(par_i).result_struct.experiment(experiment).session(session).steps(step);
             if ~isequal(this_step_data.isfinished,0)
                 this_rawdata=this_step_data.rawdata;
                 
                 lower_bounds = cell2mat(this_step_data.threshold_boundaries{1,1});
                 upper_bounds = cell2mat(this_step_data.threshold_boundaries{1,2});
                 lower_bounds_2 = lower_bounds(~isnan(lower_bounds));
                 upper_bounds_2 = upper_bounds(~isnan(upper_bounds));
                 lower_bound = lower_bounds_2(end);
                 upper_bound = upper_bounds_2(end);
                 
                 if isequal(item,'lower')
                    this_threshold=lower_bound;
                 elseif isequal(item,'upper')
                    this_threshold=upper_bound;
                 elseif isequal(item,'width')
                    this_threshold=upper_bound - lower_bound;
                 end
                 
                 this_name=stat_par_info_struct(par_i).par_name;
                 if stat_par_info_struct(par_i).par_group==1 %ʵ����
                     group_data.exp.rawdata=[group_data.exp.rawdata;this_rawdata];
                     group_data.exp.this_threshold=[group_data.exp.this_threshold,this_threshold];
                     group_data.exp.codelist=[group_data.exp.codelist,par_i];
                     group_data.exp.namelist=[group_data.exp.namelist,{this_name}];
                 elseif stat_par_info_struct(par_i).par_group==2 %������
                     group_data.ctr.rawdata=[group_data.ctr.rawdata;this_rawdata];
                     group_data.ctr.this_threshold=[group_data.ctr.this_threshold,this_threshold];
                     group_data.ctr.codelist=[group_data.ctr.codelist,par_i];
                     group_data.ctr.namelist=[group_data.ctr.namelist,{this_name}];
                 end
             end
        end
        
        text_show=[{'���'},{'���'},{'����'},{'��ֵ'},{'>3SD?'}];
        
        %��������ʵ����Ͷ���������ݱ��Լ���ֵ����׼���
        for text_group=1:2
            if text_group==1
                text_datastruct=group_data.exp;
                text_par_temp_group={'EXP'};
            else
                text_datastruct=group_data.ctr;
                text_par_temp_group={'CTR'};

            end
                
            if ~isempty(text_datastruct.codelist)

                text_mean_exp=mean(text_datastruct.this_threshold);
                text_std_exp=std(text_datastruct.this_threshold);

                for par_exp_i=1:length(text_datastruct.codelist)
                    text_par_temp_code={text_datastruct.codelist(par_exp_i)};
                    text_par_temp_name=text_datastruct.namelist(par_exp_i);
                    text_par_temp_score={text_datastruct.this_threshold(par_exp_i)};
                    text_par_temp_score_isout={double(abs(text_datastruct.this_threshold(par_exp_i)-text_mean_exp)>3*text_std_exp)};
                    text_par_temp=[text_par_temp_group,text_par_temp_code,text_par_temp_name,text_par_temp_score,text_par_temp_score_isout];
                    text_show=[text_show;text_par_temp];
                    clear text_par_temp_code text_par_temp_name text_par_temp_score text_par_temp
                end

                text_par_temp_mean=[{'��ֵ'},{' '},{' '},{text_mean_exp},{' '}];
                text_par_temp_std=[{'��׼��'},{' '},{' '},{text_std_exp},{' '}];

                text_cutline=[{' '},{' '},{' '},{' '},{' '}];
                text_show=[text_show;text_par_temp_mean;text_par_temp_std;text_cutline];
                clear text_par_temp_mean text_par_temp_std text_cutline
            end
            
        end
        
        %�������ͳ�Ƽ���
        if ~isempty(group_data.exp.codelist) && ~isempty(group_data.ctr.codelist)
            data_ttest_exp=group_data.exp.this_threshold;
            data_ttest_ctr=group_data.ctr.this_threshold;
            h_exp = kstest(data_ttest_exp);
            h_ctr = kstest(data_ttest_ctr);
            if (h_exp==1 || h_ctr==1) && (length(data_ttest_exp)<30 || length(data_ttest_ctr)<30 )
                [data_ttest_p,data_ttest_h,data_ttest_stat_a]=ranksum(data_ttest_exp,data_ttest_ctr);
                data_ttest_stat=num2str(data_ttest_stat_a.ranksum);
                stat_Tag='RankSum��';
                test_Tag='�Ⱥͼ���';
            else
                [data_ttest_p,data_ttest_h,~,data_ttest_stat_a]=ttest2(data_ttest_exp,data_ttest_ctr);
                data_ttest_stat=[num2str(data_ttest_stat_a.tstat),'(',num2str(data_ttest_stat_a.df),')'];
                stat_Tag='T(df)��';
                test_Tag='T����';
            end
            if data_ttest_h==1
                sig_Tag='��������';
            else
                sig_Tag='������';
            end
            text_temp_stat=[{'ͳ�Ƽ��飺'},{test_Tag},{' '},{stat_Tag},{data_ttest_stat}];
            text_temp_p=[{sig_Tag},{' '},{' '},{'P(0.05)��'},{data_ttest_p}];
            text_show=[text_show;text_temp_stat;text_temp_p];
        end


% --- Executes on selection change in stat_chos_step.
function stat_chos_step_Callback(hObject, eventdata, handles)
% hObject    handle to stat_chos_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns stat_chos_step contents as cell array
%        contents{get(hObject,'Value')} returns selected item from stat_chos_step


% --- Executes during object creation, after setting all properties.
function stat_chos_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stat_chos_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stat_select_par.
function stat_select_par_Callback(hObject, eventdata, handles)
% hObject    handle to stat_select_par (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global STUDY stat_par_info_struct

stat_selected_study=get(handles.stat_cho_study,'String');
if isequal(stat_selected_study,'0')
    stat_selected_study='1:size(STUDY,2)';
end

stat_selected_par=get(handles.stat_cho_par,'String');
if isequal(stat_selected_par,'0')
    stat_selected_par='1:end';
end

eval(['stat_selected_study=',stat_selected_study,';']);
stat_par_info_struct=[];
for study_i=1:length(stat_selected_study)
    eval(['stat_par_info_struct=[stat_par_info_struct,STUDY([',num2str(stat_selected_study(study_i)),']).participant([',stat_selected_par,'])];']);
end

set(handles.stat_chos_step,'enable','on');
set(handles.stat_chos_item,'enable','on');
set(handles.stat_OK,'enable','on');



function show_method_template_filename_Callback(hObject, eventdata, handles)
% hObject    handle to show_method_template_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of show_method_template_filename as text
%        str2double(get(hObject,'String')) returns contents of show_method_template_filename as a double


% --- Executes during object creation, after setting all properties.
function show_method_template_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to show_method_template_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function show_method_exp1_ses1_Callback(hObject, eventdata, handles)
% hObject    handle to show_method_exp1_ses1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of show_method_exp1_ses1 as text
%        str2double(get(hObject,'String')) returns contents of show_method_exp1_ses1 as a double


% --- Executes during object creation, after setting all properties.
function show_method_exp1_ses1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to show_method_exp1_ses1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function show_interact_exp1_ses1_Callback(hObject, eventdata, handles)
% hObject    handle to show_interact_exp1_ses1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of show_interact_exp1_ses1 as text
%        str2double(get(hObject,'String')) returns contents of show_interact_exp1_ses1 as a double


% --- Executes during object creation, after setting all properties.
function show_interact_exp1_ses1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to show_interact_exp1_ses1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function show_method_exp1_ses2_Callback(hObject, eventdata, handles)
% hObject    handle to show_method_exp1_ses2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of show_method_exp1_ses2 as text
%        str2double(get(hObject,'String')) returns contents of show_method_exp1_ses2 as a double


% --- Executes during object creation, after setting all properties.
function show_method_exp1_ses2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to show_method_exp1_ses2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function show_interact_exp1_ses2_Callback(hObject, eventdata, handles)
% hObject    handle to show_interact_exp1_ses2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of show_interact_exp1_ses2 as text
%        str2double(get(hObject,'String')) returns contents of show_interact_exp1_ses2 as a double


% --- Executes during object creation, after setting all properties.
function show_interact_exp1_ses2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to show_interact_exp1_ses2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in show_method_template_edit.
function show_method_template_edit_Callback(hObject, eventdata, handles)
% hObject    handle to show_method_template_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global template_filename template STUDY study_code study_name

if  ~isempty(STUDY(study_code).participant)
    msgbox('�����Ѿ��ڽ����ˣ����޷�����ʵ�鷽����');
else    
    [template_filename,template] = lbsCP_choosingMethod();
    STUDY(study_code).type.templatename=template_filename;
    save DATA STUDY
    
    set(handles.show_study,'String',study_name)
        
    set(handles.step1_session1,'enable','on');
    set(handles.step1_session2,'enable','on');
    set(handles.par_info_code,'enable','on');
    set(handles.par_info_reload,'enable','on');
end

refresh_show_method(handles);




% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function show_study_Callback(hObject, eventdata, handles)
% hObject    handle to show_study (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of show_study as text
%        str2double(get(hObject,'String')) returns contents of show_study as a double


% --- Executes during object creation, after setting all properties.
function show_study_CreateFcn(hObject, eventdata, handles)
% hObject    handle to show_study (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function train_stimfile_Callback(hObject, eventdata, handles)
% hObject    handle to train_stimfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of train_stimfile as text
%        str2double(get(hObject,'String')) returns contents of train_stimfile as a double


% --- Executes during object creation, after setting all properties.
function train_stimfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to train_stimfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function train_stimTag_Callback(hObject, eventdata, handles)
% hObject    handle to train_stimTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of train_stimTag as text
%        str2double(get(hObject,'String')) returns contents of train_stimTag as a double


% --- Executes during object creation, after setting all properties.
function train_stimTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to train_stimTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in train_start.
function train_start_Callback(hObject, eventdata, handles)
% hObject    handle to train_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[stim_for_train,stim_for_train_Tag]=get_train_stim_Tag(handles);
lbsCP_familiarwithstim_learn(stim_for_train,stim_for_train_Tag);

function [stim_for_train,stim_for_train_Tag]=get_train_stim_Tag(handles)
    stim_for_train_filename=get(handles.train_stimfile,'String');
    stim_for_train_Tag_filename=get(handles.train_stimTag,'String');
    stim_for_train_temp=load(stim_for_train_filename);
    stim_for_train_Tag_temp=load(stim_for_train_Tag_filename);
    stim_for_train=stim_for_train_temp.stim_for_train;
    stim_for_train_Tag=stim_for_train_Tag_temp.stim_for_train_Tag;   

% --- Executes on button press in pratice_start.
function pratice_start_Callback(hObject, eventdata, handles)
% hObject    handle to pratice_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[stim_for_train,stim_for_train_Tag]=get_train_stim_Tag(handles);
lbsCP_familiarwithstim_practice(stim_for_train,stim_for_train_Tag);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);



function stat_chos_item_Callback(hObject, eventdata, handles)
% hObject    handle to stat_chos_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stat_chos_item as text
%        str2double(get(hObject,'String')) returns contents of stat_chos_item as a double


% --- Executes during object creation, after setting all properties.
function stat_chos_item_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stat_chos_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stat_cho_study_Callback(hObject, eventdata, handles)
% hObject    handle to stat_cho_study (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stat_cho_study as text
%        str2double(get(hObject,'String')) returns contents of stat_cho_study as a double


% --- Executes during object creation, after setting all properties.
function stat_cho_study_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stat_cho_study (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stat_plotstaircase.
function stat_plotstaircase_Callback(hObject, eventdata, handles)
% hObject    handle to stat_plotstaircase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
