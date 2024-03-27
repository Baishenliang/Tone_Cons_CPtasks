%��(������)~*����ʶΪ��Ҫ���������ж�ȡ��global����

%20181213������ɢ��ͼ�����濴һ�Σ�������ƽ��ֵȷ��û��������⣡���ǵÿ��������ֵ������ܵ�ƽ���������һ��stepsize���ƽ����������󣡣��ǵø�change
%step size������ʱ�䳤�ȣ�����

function varargout = lbsCP_parScreen(varargin)
%��������ǵ����Լ����ɵģ������
% LBSCP_PARSCREEN MATLAB code for lbsCP_parScreen.fig
%      LBSCP_PARSCREEN, by itself, creates a new LBSCP_PARSCREEN or raises the existing
%      singleton*.
%
%      H = LBSCP_PARSCREEN returns the handle to a new LBSCP_PARSCREEN or the handle to
%      the existing singleton*.
%
%      LBSCP_PARSCREEN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LBSCP_PARSCREEN.M with the given input arguments.
%
%      LBSCP_PARSCREEN('Property','Value',...) creates a new LBSCP_PARSCREEN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before lbsCP_parScreen_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to lbsCP_parScreen_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lbsCP_parScreen

% Last Modified by GUIDE v2.5 29-Nov-2018 20:02:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lbsCP_parScreen_OpeningFcn, ...
                   'gui_OutputFcn',  @lbsCP_parScreen_OutputFcn, ...
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

% --- Executes just before lbsCP_parScreen is made visible.
function lbsCP_parScreen_OpeningFcn(hObject, eventdata, handles, varargin)
%�����Ҫ����һ��ϵ����ȷ�����Ҷ���ͬ
global adjust_k adjust_noise_k

% Zjudge:��Z���жϵ�����
% Mjudge:��M���жϵ�����
global endscreenfig
endscreenfig=figure(1);
set(endscreenfig,'position',[100,100,200,100]);
uicontrol('Style','pushbutton','String','����','Fontsize',50,'BackgroundColor',[0.231 0.443 0.337],'Position',[0,0,200,100],'Callback',{@closeScreen,handles});

% ��guiĬ��ͶӰ���ڶ���Ļ�ķ�����
% step1�� ����figure������һ��ͼ�Σ�
% step2�� ��ͼ���ϵ��ڶ���Ļ����󻯣�
% step3�� ��matlab��������gcf��
% step4�� ��ȡgcf�����ֵ��Position
% step5�� �����Positionֵд���������д�������
 set(handles.figure_Screen,'Position',[1921 -215 1920 1.0056e+03]);
% step6�� ��lbsCP_parScreen.fig��Unit���Ըĳɡ�pixels��

global ISI_lst
ISI_lst=0.4:0.01:0.6;
% ===============================================
% =============ÿ̨���Զ���Ҫ�����Ķ���============
% ================================================
global is_break_keyproc
is_break_keyproc=0;
%���ڰ�����Ӧ�������Ƿ�����ѱ���ֹ��������ֹ����ֵΪ1������ѭ��

global current_db output_latency
current_db=66;
%����У����ǿҪ�������飺�ѵ�ǰ�ķֱ�����¼���������滹����һЩ��ʽͨ������ֱ�������������̼�Ӧ�е�ǿ�ȣ�
output_latency=0.002426304;
%���������������ʱ���ڷ�Ӧʱ�����񵴼�¼��ʮ����Ҫ��
    
global display_instruct staircase_id_dis addnoise measure_type par_code par_name par_age fid onlinefig stimfilename to_test_substep ses2_SNRcode ses2_CONcode ses2_SNR_list ses2_SNR_pos ses2_SNR_pos_list ses2_CON2code ses2_stimcluster ses2_SNR_list_org

if addnoise==1
    stimfilename=['Noise_',stimfilename{1}];
else
    stimfilename=stimfilename{1};
end

global interact_type %��(������)~*�� 
%�������ͣ�1���㶨�̼�����2��one-up-one-down����Ӧ��
onlinefig=figure(2);

%���£���ȡ�̼��ļ��ʹ̼���������
global randomorder %��(������)~*��
global stimfile Di_stimcluster %��(������)~*��

if measure_type(1)==1
    write_method='Constant Stimuli';
    set(onlinefig,'position',[660 240 600 600]);
    ses2_SNRcode = stimfile(2,:); %ʵ��̼��������������tone�����е�tone step��
    ses2_SNR_list = cell2mat(ses2_SNRcode);
    ses2_SNR_pos_list=cell2mat(ses2_SNRcode);
    if staircase_id_dis==3
        ses2_SNR_list_org = ses2_SNR_list;
    end
    
    ses2_SNR_list = unique(ses2_SNR_list);
    ses2_SNR_pos = 1:length(ses2_SNR_list);
    %ses2_SNR_pos_list = repmat(ses2_SNR_pos,1,length(unique(cell2mat(stimfile(4,:))))); 
    ses2_CONcode = stimfile(3,:);
    ses2_CON2code = stimfile(4,:);%ʵ��̼�����ά�ȵ���������tone�����е�phon step��
    

    if staircase_id_dis==3
        ses2_stimcluster = Di_stimcluster;
    end
    
elseif measure_type(1)==2
    write_method='Staircase';
    set(onlinefig,'position',[60 0 1200 800]);
    ses2_SNRcode = [];
    ses2_CONcode = [];
end

if interact_type(1)==1
    write_interact='Button';
elseif interact_type(1)==2
    write_interact='Keyboard';
end

%�����Ǽ��̱��루�����ڼ��̷�Ӧ��
global zKey mKey par_keyboard press_l press_r ses2_cond resp_hand

if interact_type(1)==2

    [~,~,allinfos]=GetKeyboardIndices;
    for i=1:size(allinfos,2)
        %if (strcmp(allinfos{1,i}.product,'slave keyboard'))
        par_keyboard=allinfos{1,i}.index;
        %end
    end

    PsychDefaultSetup(2);
    
    if staircase_id_dis==1
        % staircase��
        zKey = KbName(',<');
        mKey = KbName('.>');  
    else
        if mod(par_code,2)==0
            % ż��������������
            zKey = KbName(',<');
            mKey = KbName('.>');
        elseif  mod(par_code,2)==1
            % ��������������
            zKey = KbName('.>');
            mKey = KbName(',<'); 
        end
    end
    if resp_hand==1 %���������ַ�Ӧ
        press_l='��������ָ����<����';
        press_r='������ʳָ����>����';
    elseif resp_hand==2 %���������ַ�Ӧ
        press_l='������ʳָ����<����';
        press_r='��������ָ����>����';
    end
end

%�����Ǳ���ʵ����ˮ��txt�ı������Ǻ���Ҫ�ģ���Ϊ��ǰ�Թ�ʵ�����ը�ˣ������Ի������Ѿ������ˡ���һ�����������������ÿ��trial����һ�ε���ˮ���Բ顣
fid = fopen(['./results/No_',num2str(par_code),'_',par_name,'_log.txt'],'a');
fprintf(fid,'%s\t%s\t%s\t%s\t%s\n','PAR_INFO','Name:',par_name,'Age:',num2str(par_age));
fprintf(fid,'%s\t%s\t%s\t%s\t%s\n','CONDITIONS','Step',num2str(to_test_substep),'Stimfile',ses2_cond);
fprintf(fid,'%s\t%s\t%s\t%s\t%s\n','PARAMETERS','Method',write_method,'Interactive',write_interact);
fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\n','Time','Trial','Direction','Stimuli','Response','Reactin Time');


%���£���ȡ�����ð�ť��ʾ������
global Zjudge_text %��(������)~*��
global Mjudge_text %��(������)~*��

global cue_disp is_def_range

if staircase_id_dis==1
    % staircaseԤʵ���ĸ�������˳��
    % ��ƽ��������
    % di1_di2  ��-�� 
    % di2_ti2  ��-��
    % ti1_ti2  ��-��
    % di1_ti1  ��-��

    instruct=cell(4,1);
    % staircase��������������ƽ��
    inst_begin='��ʽ�׶η�Ϊ�ĸ����֡�����һ���֣�';
    inst='����Ҫ�ж���������������';
    inst_ch=[Zjudge_text,'����',Mjudge_text];
    inst_if='�������';
    press_l='������ʳָ����z����';
    press_r='������ʳָ����m����';
    press_OK='����Ҫ�����ж�׼ȷ����������Ե����ȷ��������ʼ�˽׶�';

    instruct{1,1}=[inst_begin,inst,inst_ch,'��',inst_if,Zjudge_text,press_l,'��',inst_if,Mjudge_text,press_r,'��',press_OK,'��'];
    instruct{2,1}=[inst_begin,inst,inst_ch,'��',inst_if,Zjudge_text,press_l,'��',inst_if,Mjudge_text,press_r,'��',press_OK,'��'];
    instruct{3,1}=[inst_begin,inst,inst_ch,'��',inst_if,Zjudge_text,press_l,'��',inst_if,Mjudge_text,press_r,'��',press_OK,'��'];
    instruct{4,1}=[inst_begin,inst,inst_ch,'��',inst_if,Zjudge_text,press_l,'��',inst_if,Mjudge_text,press_r,'��',press_OK,'��'];


    inst_di1di2_cue={Zjudge_text,Mjudge_text}; %[�ĵ����������]
    inst_di2ti2_cue={Zjudge_text,Mjudge_text};
    inst_ti1ti2_cue={Zjudge_text,Mjudge_text};
    inst_di1ti1_cue={Zjudge_text,Mjudge_text};

    % inst_tone_ch_inv_cue={inst_tone_ch_inv(1:2),inst_tone_ch_inv(5:6)};
    % inst_phon_ch_inv_cue={inst_phon_ch_inv(1:3),inst_phon_ch_inv(6:8)};

    cue_disp=cell(4,1);
    % staircase��������������ƽ��
    cue_disp{1,1}=bsliang_behav_cue_d(inst_di1di2_cue);
    cue_disp{2,1}=bsliang_behav_cue_d(inst_di2ti2_cue);
    cue_disp{3,1}=bsliang_behav_cue_d(inst_ti1ti2_cue);
    cue_disp{4,1}=bsliang_behav_cue_d(inst_di1ti1_cue);
    % cue_disp{1,2}=bsliang_behav_cue_d(inst_tone_ch_inv_cue);
    % cue_disp{2,2}=bsliang_behav_cue_d(inst_phon_ch_inv_cue);
    % cue_disp{3,2}=bsliang_behav_cue_d(inst_tone_ch_inv_cue);
    % cue_disp{4,2}=bsliang_behav_cue_d(inst_phon_ch_inv_cue);


    %set(handles.screen_Intro,'String',instruct{to_test_substep,mod(par_code,2)+1});
    if display_instruct
        set(handles.screen_Intro,'String',instruct{bsliang_mod(to_test_substep,4),1});
    else
        set(handles.screen_Intro,'String','������Ϣһ�¡���Ϣ�ú󰴡�ȷ����������');
    end

    %Identification
elseif staircase_id_dis==2
    
    instruct=cell(4,2);
    % ��һ�У����֣� �ڶ��У�����
    %inst_begin=['���ڽ�����ԣ��������ǵ�',num2str(sub_test_count),'���֡�����һ���֣�'];
    inst_begin='���ڽ�����ԡ�����һ���֣�';
    inst_toneC='����Ҫ�ж������������ڵ�������';
    inst_phonC='����Ҫ�ж������������ڵ���ĸ��';
    inst_toneN='����Ҫ�ж������������ڵ�������';
    inst_phonN='����Ҫ�ж������������ڵ���ĸ��';
    inst_tone_ch=[Zjudge_text,'����',Mjudge_text];
    inst_phon_ch=[Zjudge_text,'����',Mjudge_text];
    inst_tone_ch_inv=[Mjudge_text,'����',Zjudge_text];
    inst_phon_ch_inv=[Mjudge_text,'����',Zjudge_text];
    inst_tone_1=['�������',Zjudge_text];
    inst_tone_2=['�������',Mjudge_text];
    inst_phon_b=['�������',Zjudge_text];
    inst_phon_p=['�������',Mjudge_text];
    %press_OK='����Ҫ��֤����ȷ����ͬʱ��Ѹ�١���Ӧ����������Ե����ȷ��������ʼ�˽׶�';
    if is_def_range
        press_OK='�뾡����֤��Ӧ����ȷ������5���ڷ�Ӧ����(�����ٶ�)����������Ե����ȷ��������ʼ�˽׶�';
    else
        press_OK='������֤����ȷ����ͬʱ��Ѹ�١���Ӧ����������Ե����ȷ��������ʼ�˽׶�';
    end
    instruct{1,1}=[inst_begin,inst_toneC,inst_tone_ch,'��',inst_tone_1,press_l,'��',inst_tone_2,press_r,'��',press_OK,'��'];
    instruct{2,1}=[inst_begin,inst_phonC,inst_phon_ch,'��',inst_phon_b,press_l,'��',inst_phon_p,press_r,'��',press_OK,'��'];
    instruct{3,1}=[inst_begin,inst_toneN,inst_tone_ch,'��',inst_tone_1,press_l,'��',inst_tone_2,press_r,'��',press_OK,'��'];
    instruct{4,1}=[inst_begin,inst_phonN,inst_phon_ch,'��',inst_phon_b,press_l,'��',inst_phon_p,press_r,'��',press_OK,'��'];
    instruct{1,2}=[inst_begin,inst_toneC,inst_tone_ch_inv,'��',inst_tone_2,press_l,'��',inst_tone_1,press_r,'��',press_OK,'��'];
    instruct{2,2}=[inst_begin,inst_phonC,inst_phon_ch_inv,'��',inst_phon_p,press_l,'��',inst_phon_b,press_r,'��',press_OK,'��'];
    instruct{3,2}=[inst_begin,inst_toneN,inst_tone_ch_inv,'��',inst_tone_2,press_l,'��',inst_tone_1,press_r,'��',press_OK,'��'];
    instruct{4,2}=[inst_begin,inst_phonN,inst_phon_ch_inv,'��',inst_phon_p,press_l,'��',inst_phon_b,press_r,'��',press_OK,'��'];

    inst_tone_ch_cue={inst_tone_ch(1:4),inst_tone_ch(7:10)};
    inst_phon_ch_cue={inst_phon_ch(1:4),inst_phon_ch(7:10)};
    inst_tone_ch_inv_cue={inst_tone_ch_inv(1:4),inst_tone_ch_inv(7:10)};
    inst_phon_ch_inv_cue={inst_phon_ch_inv(1:4),inst_phon_ch_inv(7:10)};

    cue_disp=cell(4,2);
    cue_disp{1,1}=bsliang_behav_cue_d(inst_tone_ch_cue);
    cue_disp{2,1}=bsliang_behav_cue_d(inst_phon_ch_cue);
    cue_disp{3,1}=bsliang_behav_cue_d(inst_tone_ch_cue);
    cue_disp{4,1}=bsliang_behav_cue_d(inst_phon_ch_cue);
    cue_disp{1,2}=bsliang_behav_cue_d(inst_tone_ch_inv_cue);
    cue_disp{2,2}=bsliang_behav_cue_d(inst_phon_ch_inv_cue);
    cue_disp{3,2}=bsliang_behav_cue_d(inst_tone_ch_inv_cue);
    cue_disp{4,2}=bsliang_behav_cue_d(inst_phon_ch_inv_cue);


    set(handles.screen_Intro,'String',instruct{bsliang_mod(to_test_substep,4),mod(par_code,2)+1});

elseif staircase_id_dis==3
    %Discrimination
    
    instruct=cell(4,2);
    % ��һ�У����֣� �ڶ��У�����
    %inst_begin=['���ڽ�����ԣ��������ǵ�',num2str(sub_test_count),'���֡�����һ���֣�'];
    inst_begin=['���ڽ�����ԡ�����һ���֣�'];
    inst_toneC='����Ҫ�ж����������������ڵġ�������';
    inst_phonC='����Ҫ�ж����������������ڵġ���ĸ��';
    inst_toneN='����Ҫ�ж����������������ڵġ�������'; %�������������¡�
    inst_phonN='����Ҫ�ж����������������ڵġ���ĸ��'; %�������������¡�
    inst_tone_ch='һ�»��ǲ�һ��';
    inst_phon_ch='һ�»��ǲ�һ��';
    inst_tone_ch_inv='��һ�»���һ��';
    inst_phon_ch_inv='��һ�»���һ��';
    inst_tone_1='���һ��';
    inst_tone_2='�����һ��';
    inst_phon_b='���һ��';
    inst_phon_p='�����һ��';
    press_OK='����Ҫ���ǳ���ϸ�����桿������֤����ȷ����ͬʱ��Ѹ�١���Ӧ����������Ե����ȷ��������ʼ�˽׶�';

    instruct{1,1}=[inst_begin,inst_toneC,inst_tone_ch,'��',inst_tone_1,press_l,'��',inst_tone_2,press_r,'��',press_OK,'��'];
    instruct{2,1}=[inst_begin,inst_phonC,inst_phon_ch,'��',inst_phon_b,press_l,'��',inst_phon_p,press_r,'��',press_OK,'��'];
    instruct{3,1}=[inst_begin,inst_toneN,inst_tone_ch,'��',inst_tone_1,press_l,'��',inst_tone_2,press_r,'��',press_OK,'��'];
    instruct{4,1}=[inst_begin,inst_phonN,inst_phon_ch,'��',inst_phon_b,press_l,'��',inst_phon_p,press_r,'��',press_OK,'��'];
    instruct{1,2}=[inst_begin,inst_toneC,inst_tone_ch_inv,'��',inst_tone_2,press_l,'��',inst_tone_1,press_r,'��',press_OK,'��'];
    instruct{2,2}=[inst_begin,inst_phonC,inst_phon_ch_inv,'��',inst_phon_p,press_l,'��',inst_phon_b,press_r,'��',press_OK,'��'];
    instruct{3,2}=[inst_begin,inst_toneN,inst_tone_ch_inv,'��',inst_tone_2,press_l,'��',inst_tone_1,press_r,'��',press_OK,'��'];
    instruct{4,2}=[inst_begin,inst_phonN,inst_phon_ch_inv,'��',inst_phon_p,press_l,'��',inst_phon_b,press_r,'��',press_OK,'��'];

    inst_tone_ch_cue={inst_tone_ch(1:2),inst_tone_ch(5:7)};
    inst_phon_ch_cue={inst_phon_ch(1:2),inst_phon_ch(5:7)};
    inst_tone_ch_inv_cue={inst_tone_ch_inv(1:3),inst_tone_ch_inv(6:7)};
    inst_phon_ch_inv_cue={inst_phon_ch_inv(1:3),inst_phon_ch_inv(6:7)};

    cue_disp=cell(4,2);
    cue_disp{1,1}=bsliang_behav_cue_d(inst_tone_ch_cue);
    cue_disp{2,1}=bsliang_behav_cue_d(inst_phon_ch_cue);
    cue_disp{3,1}=bsliang_behav_cue_d(inst_tone_ch_cue);
    cue_disp{4,1}=bsliang_behav_cue_d(inst_phon_ch_cue);
    cue_disp{1,2}=bsliang_behav_cue_d(inst_tone_ch_inv_cue);
    cue_disp{2,2}=bsliang_behav_cue_d(inst_phon_ch_inv_cue);
    cue_disp{3,2}=bsliang_behav_cue_d(inst_tone_ch_inv_cue);
    cue_disp{4,2}=bsliang_behav_cue_d(inst_phon_ch_inv_cue);


    set(handles.screen_Intro,'String',instruct{bsliang_mod(to_test_substep,4),mod(par_code,2)+1});
end

set(handles.screen_Syllable1,'String',Zjudge_text);
set(handles.screen_Syllable2,'String',Mjudge_text);

global trialcount %�����Ѿ�������trials��
trialcount=0;

%����ļ���������ʵ������кܹؼ��ı�������Ȼ���еı������ܹؼ���
%currentstep��ָ��ǰ���trial����Ҫ�����ŵ��������е���һ��step
%currentjudge��ָ��ǰ���trial���Ե��жϣ�����жϻ���Ϊresponse�����������У������ڽ��ݷ��У��⻹���ж���һ��trialӦ�ó���ʲô�̼����о�
%judgegroup��staircaseר�ã���¼�����жϵ�����
%UpDownTrialgroupMark��staircaseר�ã����ڼ�¼ÿ��trial����up�飨���������̧����������down�飨���������Ų���������������׼��
%counttingruns��staircaseר�ã����ڼ�¼ÿ��direction�߹��˶��ٹ�run�Լ�ÿ��runƽ��steps��
%stepsize��staircaseר�ã�����ָʾ��һ�α任step��size�����Ϊ1step���Ϊ�����տ�ʼ�Ƽ�5steps
%lastmeanvalue��staircaseר�ã����ı�step��λ��Ҫ�����ϼ���run�ľ�ֵʱ�������lastmeanvalue
%rt���Ƿ�Ӧʱ��
global gbstepsize currentstep currentjudge rt judgegroup UpDownTrialgroupMark counttingruns stepsize lastmeanvalue w_subj_cond
%��ʼ��step��judge
if measure_type(1)==1 %���ѡȡ�˺㶨�̼���
    %�㶨�̼���
    currentstep=randomorder(1); %��һ��trialѡȡ����randomorder�ĵ�һ����
    currentjudge=0; %�տ�ʼcurrentjudgeĬ��Ϊ0
    judgegroup=[];
    UpDownTrialgroupMark=[];
    counttingruns=[];
    stepsize=[];
    lastmeanvalue=[];
elseif measure_type(1)==2 %���ѡȡ�˽��ݷ�
    %���ݷ�
    disp(stimfilename);
    if isequal(stimfilename,[w_subj_cond{1},'.mat']) || isequal(stimfilename,[w_subj_cond{3},'.mat'])
        currentstep=[1,size(stimfile,2)]; %�����ʼ����ΪSyllable1,Syllable2
        gbstepsize{1}=[6 3 2 1];
        gbstepsize{2}=[6 3 2 1];
    elseif isequal(stimfilename,[w_subj_cond{4},'.mat']) || isequal(stimfilename,[w_subj_cond{2},'.mat'])
        currentstep=[1,size(stimfile,2)];
        gbstepsize{1}=[6 3 2 1];
        gbstepsize{2}=[6 3 2 1];
    end
    currentjudge=[0,0];
    judgegroup{1}=3;
    judgegroup{2}=3;
    % UpDownTrialgroupMark{direction}{up_or_down}
    
    UpDownTrialgroupMark=cell(1,2); %������direction
    UpDownTrialgroupMark{1}=cell(1,2);
    UpDownTrialgroupMark{2}=cell(1,2);%ÿ��direction��up��down������
    
    counttingruns=cell(1,2); %������direction
    
    stepsize=[5,5]; %������direction
    
    lastmeanvalue=[1,size(stimfile,2)];  %������direction
    
end

rt=0; %��Ӧʱ��ʼֵ

global memory_buffer staircase_stopruns_list staircase_stopruns_changenum staircase_stop_here
%���仺�棬������ʱ���汻�Եķ�Ӧ
if measure_type(1)==1 %����Ǻ㶨�̼�����ֻ��Ҫһ��3��N�е��б�
    %[20190321��,buffer��������3�ĳ���4]
    memory_buffer=zeros(size(randomorder,2),4);
    %��һ�м�¼���ڵ�step���ڶ��м�¼���Ե��жϣ������м�¼��Ӧʱ��Ĭ��Ϊ0��
elseif measure_type(1)==2
    %����ǽ�������Ӧ������Ҫһ��2��Ԫ���cell����������direction����ÿ��cell����һ��2��N�е��б�
    memory_buffer=cell(1,2);
    %ÿ��cell����һ��direction
end

staircase_stopruns_list=cell(1,2);
%���Ǹ��ж�staircase�Ƿ���ֹ�õ��б��Ӵﵽĳһstepsize
%group��ʼ�������˶��ٸ�runs��ÿ��run��up_or_down��ʲô
staircase_stopruns_changenum{1} = 0;
staircase_stopruns_changenum{2} = 0;
%���Ǹ��ж�staircase�Ƿ���ֹ�õ�,���������Ǹ��б���up_or_downת���Ĵ���
staircase_stop_here=0;
%�������Ϊ1ʱ���Զ��������ݲ���������

global half_threshold threshold_boundaries
%��������ı���
half_threshold=[];
threshold_boundaries=cell(1,2); %����������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��20190109���Ӹ��㶨�̼����ģ���ʱ��һ����ֵӦ�ñ�Ϊÿ��SNR�ϵİٷֱ�%%%%%%%%%%%%%%%%%

%[20190416����]
global noise_bg fs_noise_bg noise_filename
[noise_bg,fs_noise_bg]=audioread(noise_filename);

global soundBuffer param
% ����psychportaudio��������buffer�����Կ��ٵ�ȡ
InitializePsychSound;
deviceID=setDeviceID('subject');
param = PsychPortAudio('Open',deviceID,1+8,2,44100,2);          % ���豸����Щ��������ô��OK��
% soundBuffer=cell(1,size(stimfile,2)+1); %���Ǵ��滺���˵������ļ���buffer,[20190416��]���һ��������
soundBuffer=cell(1,size(stimfile,2)); %���Ǵ��滺���˵������ļ���buffer
% ��һ������slaveID���ڶ�������buffer
for soundID=1:size(stimfile,2)
   soundBuffer{1,soundID}=PsychPortAudio('OpenSlave',param,1,2);
   %soundBuffer{2,soundID}=PsychPortAudio('CreateBuffer', soundBuffer{1,soundID},[stimfile{1,soundID}';stimfile{1,soundID}']);
   signal_temp=stimfile{1,soundID};
   noise_temp=noise_bg/adjust_noise_k;
   if addnoise
       SOUND_tmp=bsliang_appendBGnoise(signal_temp,noise_temp,44100);
   else
       SOUND_tmp=signal_temp;
   end
   PsychPortAudio('FillBuffer',soundBuffer{1,soundID}, [adjust_k(1)*SOUND_tmp';adjust_k(2)*SOUND_tmp']);
end
% soundBuffer{1,end}=PsychPortAudio('OpenSlave',param,1,2);
% PsychPortAudio('FillBuffer',soundBuffer{1,end}, [adjust_k(1)*noise_bg'/adjust_noise_k;adjust_k(2)*noise_bg'/adjust_noise_k]);

% BSLiang 20201025 ������online��TMS�Ĳ��֣�������߰ε�Ҳû���⣬����Ҳ����block�� 
global ioObj address
ioObj = io64;
address = hex2dec('3FF8');          %standard LPT1 output port address
status = io64(ioObj);
io64(ioObj,address,0);

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to lbsCP_parScreen (see VARARGIN)

% Choose default command line output for lbsCP_parScreen
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes lbsCP_parScreen wait for user response (see UIRESUME)
uiwait(handles.figure_Screen);


% --- Outputs from this function are returned to the command line.
function varargout = lbsCP_parScreen_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global memory_buffer endscreenfig onlinefig half_threshold par_code par_name threshold_boundaries

% Get default command line output from handles structure
varargout{1}.rawdata=memory_buffer;
varargout{1}.half_threshold=half_threshold;
varargout{1}.threshold_boundaries=threshold_boundaries;
delete(endscreenfig);
set(handles.playbutton,'visible','off');
set(handles.screen_Syllable1,'visible','off');
set(handles.screen_Syllable2,'visible','off');
set(handles.screen_Intro,'String','���ڱ����У����Ժ�O(��_��)O��������Ϣһ�¡�');
global ses2_cond
saveas(figure(2),['./result_plots/No_',num2str(par_code),'_',par_name,'_',ses2_cond,'_',strrep(strrep(strrep(datestr(now),':','_'),' ','_'),'-','_'),'.png']);
clearvars -except varargout onlinefig handles
delete(onlinefig);
delete(handles.figure_Screen);


% --- Executes on button press in startbutton.
function startbutton_Callback(hObject, eventdata, handles)
%���ǰ��˺��ġ���ʼ����ť�������ֵĹ���

% hObject    handle to startbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global interact_type soundBuffer cue_disp to_test_substep par_code staircase_id_dis

set(handles.startbutton,'enable','off');
% set(handles.screen_Intro,'String',cue_disp{to_test_substep,mod(par_code,2)+1});
if staircase_id_dis == 1
    set(handles.screen_Intro,'String',cue_disp{bsliang_mod(to_test_substep,4),1});
else
    set(handles.screen_Intro,'String',cue_disp{bsliang_mod(to_test_substep,4),mod(par_code,2)+1});
end

%���£��ص�������Ӧ��ť��Ҫ�����������˲ſ�����
set(handles.screen_Syllable1,'enable','off');
set(handles.screen_Syllable2,'enable','off');

%global noise_bg fs_noise_bg
%sound(noise_bg,fs_noise_bg)

global param addnoise
%����PPA
PsychPortAudio('Start',param,0,0);

% if addnoise==1
% PsychPortAudio('Start',soundBuffer{1,end},0,0); %[20190416,�ظ����ű�������]
% end

if interact_type(1)==1
    %���������ʽ�Ǳ��԰���Ļ�ϵİ�ť    
    set(handles.playbutton,'Visible','on');
    set(handles.playbutton,'enable','on');
    set(handles.screen_Syllable1,'Visible','on');
    set(handles.screen_Syllable2,'Visible','on');
else
    %���������ʽ�Ǳ����ü��̰���
    key_press_exp_proc(handles)
end

% set(handles.screen_Intro,'String','+');


function key_press_exp_proc(handles)
%����������ģ�������ѡ�����ñ��԰���ʱ����ʵ�����̵�ѭ���ĺ���
    global  is_break_keyproc fid param ISI_lst %trialcount
    for keypress_step=1:10000%forѭ�����������ǳ�����Ҫ�˹������������簴��������������Ҫ�ǿ��ǵ����ݷ���̫ȷ��������Ҫ�����ٸ�trial����OK
        if is_break_keyproc==1%������һ��trial֮ǰ�����һ���Ƿ��Ѿ������˽���������ʵ����򣨶��ں㶨�̼������ģʽ���Ѿ���ֹ��
            save_data(handles);%���������
            %���£��ص����а�ť
            set(handles.playbutton,'enable','off');
            set(handles.screen_Syllable1,'enable','off');
            set(handles.screen_Syllable2,'enable','off');
            %���£��ص�PPA
            PsychPortAudio('Stop',param);
            PsychPortAudio('Close',param);
            fclose(fid);
            break;
        end
     
        %pause(0.4+rand(1,1)*(0.6-0.4));
        %%��ͣ,ע������ԭȪ�ͽ���ͩ�汾�ĵȴ����ҵ��°汾��10msһ��step��
        pause(ISI_lst(randi(length(ISI_lst),1,1))); % �°�ĵȴ��������ģ�400~600ms����10msΪһ��step�����ѡ��ISI_lst���ڳ���һ��ʼ�Ͷ����˵ġ�
        %trialcount = trialcount + 1; %��trialcount��һ [20190709]
        play_sound_key(handles);  %���������ĺ�����ר�����ڰ�����Ӧ��
    end

% for soundID=1:size(stimfile,2)
%    PsychPortAudio('DeleteBuffer',soundBuffer{2,soundID});
% end


% --- Executes on button press in endbutton.
function endbutton_Callback(hObject, eventdata, handles)
% hObject    handle to endbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ��������������������ʱ����ĺ�����
endTest(handles); %�����������

%��Ȼ�����ˣ��͹ص���Щ��ť��
set(handles.playbutton,'enable','off');
set(handles.screen_Syllable1,'enable','off');
set(handles.screen_Syllable2,'enable','off');

function endTest(handles)
    %�������Եĺ���
    global param fid is_break_keyproc interact_type soundBuffer addnoise
    is_break_keyproc=1;
    if interact_type(1)==1
        save_data(handles);
%         if addnoise==1
%             PsychPortAudio('Stop',soundBuffer{1,end});%[20190416,�������ű�������]
%         end
        PsychPortAudio('Stop',param);
        PsychPortAudio('Close',param);
        fclose(fid);
    end

function save_data(handles)
    uiresume(handles.figure_Screen);
%��������


% --- Executes on button press in playbutton.
%���¡�������������ťʱ���¼�
function playbutton_Callback(hObject, eventdata, handles)
% hObject    handle to playbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.playbutton,'enable','off');%��������֮ǰ�������Ϲص����������İ�ť�����ⱻ���ظ�����
play_sound_button();%��������
set(handles.screen_Syllable1,'enable','on');%������������Ҫ��Ӧ�İ�ť
set(handles.screen_Syllable2,'enable','on');

function play_sound_button()
global direction trialcount measure_type
global ioObj address
%�¼���һ��direction������˵���������ר��Ϊ���ݷ���Ƶģ����ݷ�������direction���������ºʹ���������������
if measure_type(1)==1
    %�㶨�̼�����direction����1
    direction=1;
elseif measure_type(1)==2
    %���ݷ��£�ÿ��trial��ʼʱ������������»����ϣ�
    direction=Randi(2); % Randomly select one direction
end
%ÿ����һ��trial��trialcount�ͼ�һ
trialcount=trialcount+1;
disp('================================================================');
disp(['This is the No,',num2str(trialcount),' trial of the experiment']);
disp('================================================================');
global soundBuffer currentstep
%�ȴ�һ����֮�󣬾Ϳ���ʼ���ţ�������������
pause(1);
io64(ioObj,address,1); 
PsychPortAudio('Start',soundBuffer{1,currentstep(direction)},1,0);
pause(0.5);
io64(ioObj,address,0);  
PsychPortAudio('Stop',soundBuffer{1,currentstep(direction)});

function play_sound_key(handles)
%ϸ�ĵ���϶��ᷢ�֣���������������������������ĺ�����һ����play_sound_button����һ����play_sound_key��
%ǰ����ͨ����Ļ��ť��������������������ͨ�����̰�����������������������������ǿ��Լ�¼���̷�Ӧ���������ź�����
global direction measure_type rt is_break_keyproc trialcount staircase_id_dis
global ioObj address 
%���£�Ҳ���Ǹ��ݲ���������ѡ��direction���㶨ֻ��һ�����򣬽�����������
if measure_type(1)==1
    direction=1;
elseif measure_type(1)==2
    direction=Randi(2); % Randomly select one direction
end
global soundBuffer currentstep par_keyboard zKey mKey %output_latency
io64(ioObj,address,1);
PsychPortAudio('Start',soundBuffer{1,currentstep(direction)},1,0);%��ʼ��������
%handles.figure_Screen
tStart = GetSecs;
if staircase_id_dis==3
    pause(0.369+0.5); %[20190709]
end
while 1
    %����һ��while����������ʼ����֮�����Ͽ�ʼ�����̣�ֱ�����԰���ָ���ļ�������ѭ�������while������
    [~,~,keyCode] = KbCheck(par_keyboard);
    timer = GetSecs-tStart; %���ǿ�ʼ�㷴Ӧ��ʱ
    if keyCode(zKey)
        tEnd = GetSecs;
        rt = tEnd - tStart;%-output_latency;
        trialcount = trialcount + 1; %[20190709]
        par_response(0,handles);
        break;
    elseif keyCode(mKey)
        tEnd = GetSecs;
        rt = tEnd - tStart;%-output_latency;
        trialcount = trialcount + 1; %[20190709]
        par_response(1,handles);
        break;
    elseif is_break_keyproc==1
        break;
    elseif timer>(5-(0.369+0.5)) %[20190709]
        tEnd = GetSecs;
        rt = tEnd - tStart;%-output_latency;
        %par_response(3,handles);
        %����û�з�Ӧ��ֱ������
        break;
    end
end
io64(ioObj,address,0);
PsychPortAudio('Stop',soundBuffer{1,currentstep(direction)});


% --- Executes on button press in screen_Syllable1.
% ѡ�ˡ�����1������ߣ�ʱ�������¼� ����Ӧ��Ϊ-��
function screen_Syllable1_Callback(hObject, eventdata, handles)
% hObject    handle to screen_Syllable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%һ�������˰�ť�����������İ�ť�ͻᱻ������
set(handles.playbutton,'enable','on');
%���԰����İ�ť���°����ˣ������Ҳ��
set(handles.screen_Syllable1,'enable','off');
set(handles.screen_Syllable2,'enable','off');
par_response(0,handles);

% --- Executes on button press in screen_Syllable2.
% ѡ�ˡ�����2�����ұߣ�ʱ�������¼�����Ӧ��Ϊ+��
function screen_Syllable2_Callback(hObject, eventdata, handles)
% hObject    handle to screen_Syllable2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%�������Ǹ���ť��Ӧһ�����Ҳ�������
set(handles.playbutton,'enable','on');
set(handles.screen_Syllable1,'enable','off');
set(handles.screen_Syllable2,'enable','off');
par_response(1,handles);

function par_response(resp,handles)
    %par_response���������������ȡ����ĺ����������trial����Ϣ��ʵ��̼������Է�Ӧ����Ӧʱ������ͼ���ж���һ��stepӦ�ó���ʲô����
    global currentjudge direction judgegroup staircase_stop_here measure_type
    if measure_type(1)==1
        currentjudge=resp;%����currentjudge
    elseif measure_type(1)==2    
        currentjudge(direction)=resp;%����currentjudge
    end
    if measure_type(1)==2
        %���ݷ�
        judgegroup{direction}=[judgegroup{direction},resp];
    end
    MemoryAndPlot_Memory()
    SCnextstepchange=SCnextstepjudge(4,2,handles);
    MemoryAndPlot_Plot(handles);%������Ϣ���Լ���ͼ
    if staircase_stop_here==1
        endTest(handles);
    end
    JudgeNextStep(handles,SCnextstepchange);%�ж���һ��trial
    
    % ��ģ��һ������������ı仯���������ڸպ��ܵ���4��run�����һ�������ĸ�runȫ�ǡ�++++�����������һ�������ʼ�����run��
    % ��ʼֵ:
    % stepsize=10,stepcode=1,counttingruns��δ�������ĸ�runs,lastmeanvalueӦ���ǵڶ���run�ľ�ֵ;
    % ��һ���� MemoryAndPlot_Memory()�����ؼ��䣬��ʱmemory_buffer�Ѿ����������trial�ġ�+��
    % �ڶ����� SCnextstepjudge��countingruns�Ѿ������˵��ĸ�run               ��connttingruns+��
    %          ע���ڴ�ʱ�����Ĳ���no_runs�Ѿ����4�ˡ�
    % �������� MemoryAndPlot_Plot(handles)���ı�lastmeanvalue                ��lastmeanvalue+��
    % ���Ĳ��� JudgeNextStep(handles,SCnextstepchange)�� ���е���ʱ����stepsize=5��stepcode=2����һ���׶δ���һ���׶εľ�ֵ��ʼ��
    % ����ˣ����ĸ�run��countingruns���¼������Ȼ�����ڵ�һ��stepcode��
    
function MemoryAndPlot_Memory()
    global memory_buffer staircase_id_dis measure_type currentstep currentjudge direction trialcount ses2_CON2code rt ses2_SNR_pos_list ses2_CONcode ses2_SNR_list_org
    
    if measure_type(1)==1  %�������ݺ���ͼҪ�ֺ㶨�̼���
        %�㶨�̼���
        if isequal(ses2_CONcode(1,currentstep),{1})
            %��ȷ�İ���Ӧ���ǰ����
            if currentjudge == 0
                %���԰������������
                SNR_correct = 1;
            elseif currentjudge == 1
                %���԰����Ҽ�������
                SNR_correct = 0;
            end
        elseif isequal(ses2_CONcode(1,currentstep),{2})
            %��ȷ�İ���Ӧ���ǰ��Ҽ�
            if currentjudge == 0
                %���԰������������
                %���������ж����棬������������൱���жϳ���������˵��Ǹ��㣬��˼�Ϊ0��
                SNR_correct = 0;
            elseif currentjudge == 1
                %���԰����Ҽ�������
                %���������ж����棬�����Ҽ������൱���жϳ��������Ҷ˵��Ǹ��㣬��˼�Ϊ1.
                SNR_correct = 1;
            end
        end
        if (staircase_id_dis == 1) || (staircase_id_dis == 2)
            Const_thisCOND=ses2_SNR_pos_list(1,currentstep);
        elseif staircase_id_dis == 3
            Const_thisCOND=ses2_SNR_list_org(1,currentstep);
        end
        Const_otherCOND=ses2_CON2code{1,currentstep};
        memory_buffer(trialcount,:)=[Const_thisCOND,SNR_correct,rt,Const_otherCOND];%��~���ڰ����trial����Ϣ������
    if staircase_id_dis == 3
        correct_rate=sum(memory_buffer(1:trialcount,2))/trialcount;
        disp(['��ȷ�� = ',num2str(correct_rate*100),'%']);
    end
        %[20190120��������ն���ʦ�����������͸ĸ�judge������ȷ�жϵ��������ˣ�ֻ�д̼�����������жϱ���һ�²��ж�Ϊ��ȷ��]
    elseif measure_type(1)==2
        %���ݷ�
        memory_buffer{direction}=[memory_buffer{direction};trialcount,currentstep(direction),currentjudge(direction),rt];
    end

function MemoryAndPlot_Plot(handles)
    % type=1,�㶨�̼���; type=2,one-down-one-up����Ӧ��
    %��adaptive_paraֻ��type=2ʱ��Ҫ���Ŀǰֻ����directionһ������)
    global stimsteplength %��(������)~*��ʵ��̼��Ĳ���
    global memory_buffer staircase_id_dis ses2_stimcluster measure_type currentstep currentjudge direction trialcount fid rt half_threshold  ses2_SNR_pos
    
    inputstruct.x_axis1=[];
    inputstruct.y_axis1=[];
    inputstruct.x_axis2=[];
    inputstruct.y_axis2=[];
    inputstruct.meanvalue1=[];
    inputstruct.scatter_points_positive_1=[];
    inputstruct.scatter_points_negative_1=[];
    inputstruct.meanvalue2=[];
    inputstruct.scatter_points_positive_2=[];
    inputstruct.scatter_points_negative_2=[];

    %�����������£�
    %memory_buffer�����䴢�棬ǰ�潲��
    %measure_type(1)���������ͣ��ҷ���˵����Ҫô�Ǻ㶨�̼���Ҫô�ǽ��ݷ�
    %currentstep����ǰ��step��Ҳ˵����
    %currentjudge���������˵�������
    %direction�� ����
    %trialcount�������Ҳ���˵�ˡ���
    %fid�����Ǵ���txt�ļ��ĵط�������������trials��¼��
    if measure_type(1)==1  %�������ݺ���ͼҪ�ֺ㶨�̼���
        %�㶨�̼���
        %���£���ͼ�õ����ݾ���
             
        if staircase_id_dis == 2
            this_constant_socre=zeros(length(ses2_SNR_pos),2);
            this_constant_steps=ses2_SNR_pos;
            this_constant_score(:,1)=this_constant_steps';%������ĵ�һ�и�ֵ��ÿ��stepһ��
            for step_type=ses2_SNR_pos %����ÿ��step��ƽ���������Ҵ浽��ͼ�õ����ݾ�����
                if ~isempty(memory_buffer(memory_buffer(:,1)==step_type,2))
                    step_score=mean(memory_buffer(memory_buffer(:,1)==step_type,2));
                else
                    step_score=0;
                end
                %�����Ǹ�if����˼�ǣ�����Ѿ�����ĳЩsteps��trials����ô�������ֵ�����û��������ô���trial��ֵ�ȼ�Ϊ0.
                this_constant_score(step_type,2)=step_score;
            end
        elseif staircase_id_dis == 3
            this_constant_socre=zeros(size(ses2_stimcluster,1),2);
            this_constant_steps=1:size(ses2_stimcluster,1);
            this_constant_score(:,1)=this_constant_steps';%������ĵ�һ�и�ֵ��ÿ��stepһ��
            for step_type=1:size(ses2_stimcluster,1) %����ÿ��step��ƽ���������Ҵ浽��ͼ�õ����ݾ�����
                mmbf=memory_buffer(:,1);
                mmbc=ses2_stimcluster(step_type,:);
                if ~isempty(memory_buffer(logical((mmbf==mmbc(1))+(mmbf==mmbc(2))+(mmbf==mmbc(3))+(mmbf==mmbc(4))),2))
                    %20190512:��鵽����
                    step_score_diff=mean(memory_buffer(logical((mmbf==mmbc(1))+(mmbf==mmbc(2))),2));
                    step_score_same=mean(memory_buffer(logical((mmbf==mmbc(3))+(mmbf==mmbc(4))),2));
                    step_score=step_score_diff*0.5+step_score_same*0.5;
                else
                    step_score=0;
                end
                %�����Ǹ�if����˼�ǣ�����Ѿ�����ĳЩsteps��trials����ô�������ֵ�����û��������ô���trial��ֵ�ȼ�Ϊ0.
                this_constant_score(step_type,2)=step_score;
            end
        end
        
        %���£�������ͼ�Ļ�����ʵ�������������ᣬ��ô��Ҫ����x���y��ֱ����������ݣ���OK��
        inputstruct.x_axis1=this_constant_score(:,1);
        inputstruct.y_axis1=this_constant_score(:,2);
        inputstruct.x_axis2=[];
        inputstruct.y_axis2=[];
        inputstruct.meanvalue1=[];
        inputstruct.scatter_points_positive_1=[];
        inputstruct.scatter_points_negative_1=[];        
        inputstruct.meanvalue2=[];
        inputstruct.scatter_points_positive_2=[];
        inputstruct.scatter_points_negative_2=[];
    
        half_threshold=this_constant_score; %�����������������������20190109������������������������
        
        onlineplot(handles,inputstruct);
        %��ͼ
    elseif measure_type(1)==2
        %���ݷ�
        if ~isempty(memory_buffer{1})
            inputstruct.x_axis1=memory_buffer{1}(:,1);
            inputstruct.y_axis1=memory_buffer{1}(:,2);
            [meanvalue,scatter_points_positive,scatter_points_negative]=calculate_threshold(1:size(inputstruct.x_axis1,1),inputstruct.y_axis1,1);
            inputstruct.meanvalue1=meanvalue;
            inputstruct.scatter_points_positive_1=scatter_points_positive;
            inputstruct.scatter_points_negative_1=scatter_points_negative;
            clear meanvalue scatter_points_positive scatter_points_negative
        else
            inputstruct.x_axis1=[];
            inputstruct.y_axis1=[];
        end
        %����������if����һ�ִ�����ԣ���Ϊ������direction���滹û�����ݣ���ͼ����ᱨ��
        if ~isempty(memory_buffer{2})
            inputstruct.x_axis2=memory_buffer{2}(:,1);
            inputstruct.y_axis2=memory_buffer{2}(:,2);
            [meanvalue,scatter_points_positive,scatter_points_negative]=calculate_threshold(1:size(inputstruct.x_axis2,1),inputstruct.y_axis2,2);
            inputstruct.meanvalue2=meanvalue;
            inputstruct.scatter_points_positive_2=scatter_points_positive;
            inputstruct.scatter_points_negative_2=scatter_points_negative;
            clear meanvalue scatter_points_positive scatter_points_negative
        else
            inputstruct.x_axis2=[];
            inputstruct.y_axis2=[];
        end
        
        
        onlineplot(handles,inputstruct);
    end
    %�������������д���ݼ�¼�Ĵ�����
    fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\n',num2str(datestr(now)),num2str(trialcount),num2str(direction),num2str(currentstep(direction)),num2str(currentjudge(direction)),num2str(rt));
    
    
function JudgeNextStep(handles,SCnextstepchange)
    
    %���������ʲô���أ������֮���Ǿ�����һ��trialҪ����ʲô�ĺ�����
    % type=1,�㶨�̼���; type=2,one-down-one-up����Ӧ��
    %��adaptive_paraֻ��type=2ʱ��Ҫ���Ŀǰֻ����directionһ������)
    global gbstepsize currentstep param measure_type trialcount stimsteplength randomorder fid is_break_keyproc interact_type stimfile stepsize stepcode direction counttingruns lastmeanvalue
    
    
    if measure_type(1)==1 
        disp(trialcount);
        %�㶨�̼���
        if trialcount<=size(randomorder,2)-1
            %ֻҪ��ǰ��trialcount������randomorder�Ĵ�С��ȥ1
            currentstep=randomorder(trialcount+1);
            %��ô��һ��step����randomorder�ĵ�trialcount+1������
        else
            %����Ѿ�����randomorder-1����ô����ֹʵ���
            set(handles.playbutton,'enable','off');
            is_break_keyproc=1;%����ǰ����̵Ļ���ֱ�ӾͿ�����������������Ϊ1�������ᵽ��ʵ������forѭ���ͻ��Լ�break������
            if interact_type(1)==1
                %����ǵ���Ļ��ť����ôֱ�Ӵ����ﱣ�����ݣ��˳�ʵ�顣
                save_data(handles);
                PsychPortAudio('Stop',param);
                PsychPortAudio('Close',param);
                set(handles.playbutton,'enable','off');
                fclose(fid);
            end
        end
    elseif measure_type(1)==2
        
        %counttingruns{direction}=[stepsize(direction),up_or_down,mean(memory_buffer{direction}((end-(length(judgegroup{direction})-1)+1):end,2),1)]

        no_runs=size(counttingruns{direction},1);
        %�������trial�����ķ��������
        
        cuttingruns{1}=[3,7,15,21]; %[20190718]
        cuttingruns{2}=[3,7,15,21]; %[20190718]
        stepsizeafter{1}=gbstepsize{1};
        stepsizeafter{2}=gbstepsize{2};


        if no_runs <= cuttingruns{direction}(1)
            stepsize(direction)=stepsizeafter{direction}(1);
            stepcode(direction)=1;
        elseif no_runs > cuttingruns{direction}(1) && no_runs <= cuttingruns{direction}(2)
            stepsize(direction)=stepsizeafter{direction}(2);
            stepcode(direction)=2;
        elseif no_runs > cuttingruns{direction}(2) && no_runs <= cuttingruns{direction}(3)
            stepsize(direction)=stepsizeafter{direction}(3);
            stepcode(direction)=3;
        elseif no_runs > cuttingruns{direction}(3) && no_runs <= cuttingruns{direction}(4)
            stepsize(direction)=stepsizeafter{direction}(4);
            stepcode(direction)=4;        
        end

        if size(counttingruns{direction},1)>=3
            stepsize(direction)
        end
        
        %����Ӧ���������ݱ�����direct��������һ�����ж���������һ��
        if no_runs == cuttingruns{direction}(1)+1 || no_runs == cuttingruns{direction}(2)+1 || no_runs == cuttingruns{direction}(3)+1
            disp('watch out')
            disp(lastmeanvalue(direction))
            % [20190610�ܿ���������������⣬��������޸Ĺ���]
            currentstep(direction)=round(lastmeanvalue(direction));
        else
            if SCnextstepchange==1 %�̼�������2�ƶ�һ��
    %             disp(currentstep(direction));
    %             disp(stimsteplength-1);
                if currentstep(direction)<=stimsteplength-stepsize(direction)
                    currentstep(direction)=currentstep(direction)+stepsize(direction);
    %                 disp(currentstep(direction));
                end
            elseif SCnextstepchange==0 %�̼�������1�ƶ�һ��
                if currentstep(direction)>=stepsize(direction)+1
                    currentstep(direction)=currentstep(direction)-stepsize(direction);
                end
            end
        end
    end
    
function SCnextstepchange=SCnextstepjudge(max_run_size,this_run,handles)
% For X84.1 and X15.9, max_run_size=4
% For other thresholds, the values of max_run_size are easy to discover
% based on Levitt (1971).
% For up staircase, boundary_side=1; do staircase, boundary_side=2
% this_run: the step of a recursive function 
    global direction judgegroup measure_type trialcount
    
    if measure_type(1)==1
        %�㶨�̼���
        SCnextstepchange=[];
    elseif measure_type(1)==2
        %���ݷ�
        if direction==1 %up
            skip_value=1; % '+' to skip
            end_value=0; % '-' to end
            skip_nextchange=0;
            end_nextchange=1;
            skip_grouptype=2;
            end_grouptype=1;
        elseif direction==2 %down
            skip_value=0; % '-' to skip
            end_value=1; % '+' to end
            skip_nextchange=1;
            end_nextchange=0;
            skip_grouptype=1;
            end_grouptype=2;
        end
            if this_run < (max_run_size + 1)
                % For X84.1 and X15.9, this run < 5
                if judgegroup{direction}(this_run)==skip_value
                    %disp(['Run:',num2str(this_run),'; Condition: meet skip value;']);
                    %���������������硰+������ֱ�����һ��run�����Կ�չskip������judgegroup
                    SCnextstepchange=skip_nextchange; 
                    if trialcount > 2
                        SC_showingupdowngroup(skip_grouptype,handles);
                    end
                    judgegroup{direction}=3;
                elseif this_run < length(judgegroup{direction})
                    %disp(['Run:',num2str(this_run),'; Condition: not met, go on recursive;']);
                    %û�����run��������벻��judgegroup���һ�����룬�����ݹ�
                    SCnextstepchange=SCnextstepjudge(max_run_size,this_run+1,handles);
                elseif this_run == length(judgegroup{direction})
                    %disp(['Run:',num2str(this_run),'; Condition: not met, got group final, no change level;']);
                    %û�����run�������Ŀ�Ѿ���judgegroup���һ�����룬���Ϊ�գ�����չskip
                    SCnextstepchange=[];
                elseif this_run > length(judgegroup{direction})
                    %���صĴ��ڣ���������²��ᷢ����һ�������ˣ��ֲ��Ĵ�ʩ�ǲ���չskip������judgegroupΪ3�ӳ����Ĳ���
                    %�����ϣ���ʱ����һ����bug��run���ᱻ����һ��run
                    disp('BUGGGGG!!!');
                    SCnextstepchange=[];
                    judgegroup{direction}(1:5)=[];
                    judgegroup{direction}=[3,judgegroup{direction}];
                end
            elseif this_run == (max_run_size + 1)
                %disp(['Run:',num2str(this_run),'; Condition: reached the end of the group;']);
                    %�Ѿ���������size
                if judgegroup{direction}(this_run)==skip_value
                    %disp(['Run:',num2str(this_run),'; Condition: FINAL: meet skip value;']);
                    SCnextstepchange=skip_nextchange; 
                    SC_showingupdowngroup(skip_grouptype,handles);
                    judgegroup{direction}=3;
                elseif judgegroup{direction}(this_run)==end_value
                    %disp(['Run:',num2str(this_run),'; Condition: FINAL: not met skip value, change level;']);
                    SCnextstepchange=end_nextchange; 
                    SC_showingupdowngroup(end_grouptype,handles);
                    judgegroup{direction}=3;
                end
            end
    end

    
function SC_showingupdowngroup(up_or_down,handles)
    %up:1 down:2
    global memory_buffer direction judgegroup UpDownTrialgroupMark counttingruns stepsize stepcode
        xmin=size(memory_buffer{direction},1)-(length(judgegroup{direction})-1)+1;
        xmax=size(memory_buffer{direction},1)+0.5;
        UpDownTrialgroupMark{direction}{up_or_down}{size(UpDownTrialgroupMark{direction}{up_or_down},2)+1}=[xmin xmax xmax xmin];
        countting_before_end(up_or_down,handles)
        %memory_buffer{direction}=[memory_buffer{direction};trialcount,currentstep(direction),currentjudge(direction),rt];
        counttingruns{direction}=[counttingruns{direction};stepsize(direction),up_or_down,mean(memory_buffer{direction}((end-(length(judgegroup{direction})-1)+1):end,2),1),stepcode(direction)];
        %disp(['The mean value of current group: ',num2str(counttingruns{direction}(end,3))]);
        % counttingruns�����У��ֱ���stepsize�����run��up(1)����down(2)run�����run�ľ�ֵ�����step�ı���
        
function countting_before_end(up_or_down,handles)
    global stepcode direction staircase_stoprunstage staircase_stoprunchange staircase_stopruns_list fclose staircase_stopruns_changenum staircase_stop_here

    %���������һ�б���ʲô��������ά�ȵģ��ǿ϶��Ǳ��Ե�һ���������ˣ��������Ϳ����ˡ���ʱ��ĳ����ˡ�
    if stepcode(direction) >= staircase_stoprunstage
        staircase_stopruns_list{direction} = [staircase_stopruns_list{direction},up_or_down];
    end
    
    staircase_stopruns_changenum{direction}=0;
    
    for staircase_stopruns_code = 2:length(staircase_stopruns_list{direction})
        if staircase_stopruns_list{direction}(staircase_stopruns_code) ~= staircase_stopruns_list{direction}(staircase_stopruns_code-1)
            staircase_stopruns_changenum{direction} = staircase_stopruns_changenum{direction}+1;
        end
    end
    
    if (staircase_stopruns_changenum{1} >= staircase_stoprunchange) && (staircase_stopruns_changenum{2} >= staircase_stoprunchange)
        staircase_stop_here=1;
        %��Ȼ�����ˣ��͹ص���Щ��ť
        set(handles.playbutton,'enable','off');
        set(handles.screen_Syllable1,'enable','off');
        set(handles.screen_Syllable2,'enable','off');
        try
        close(fclose); %�ص���������
        catch
        end
    end
        
        
function SC_plottingupdowngroup(direction)
    global UpDownTrialgroupMark stimfile
    %for up, plot green
    hold on
    try
        for num_updown=1:size(UpDownTrialgroupMark{direction}{1},2)
            fill(UpDownTrialgroupMark{direction}{1}{num_updown},[0 0 size(stimfile,2)+1 size(stimfile,2)+1],'g','edgecolor','none','facealpha',0.15);
        end
    catch
    end
    try
    %for down, plot red
        for num_updown=1:size(UpDownTrialgroupMark{direction}{2},2)
            fill(UpDownTrialgroupMark{direction}{2}{num_updown},[0 0 size(stimfile,2)+1 size(stimfile,2)+1],'r','edgecolor','none','facealpha',0.15);
        end
    catch
    end
    hold off
    
            
function onlineplot(handles,inputstruct)
    global Di_xaxis staircase_id_dis measure_type onlinefig stimfile ses2_SNR_list to_test_substep Zjudge_text Mjudge_text
    clf(onlinefig)
    figure(2)
    x_axis1=inputstruct.x_axis1;
    y_axis1=inputstruct.y_axis1;
    x_axis2=inputstruct.x_axis2;
    y_axis2=inputstruct.y_axis2;
    meanvalue1=inputstruct.meanvalue1;
    %disp('onlineplot: meanvalue1 ');
    %meanvalue1
    scatter_points_positive_1=inputstruct.scatter_points_positive_1;
    scatter_points_negative_1=inputstruct.scatter_points_negative_1;
    meanvalue2=inputstruct.meanvalue2;
    %disp('onlineplot: meanvalue2 ');
    %meanvalue2
    scatter_points_positive_2=inputstruct.scatter_points_positive_2;
    scatter_points_negative_2=inputstruct.scatter_points_negative_2;
    %��ͼ��
    if measure_type(1)==2 %���ݷ�
        subplot(2,3,[1 4])
    end
    
    if staircase_id_dis==1 || 2
        if length(x_axis1)<10
            plot(zeros(1,length(ses2_SNR_list)),'linewidth',0.0001, 'color','k');
            %����������⡣
        else
            plot(zeros(1,length(x_axis1)),'linewidth',0.0001, 'color','k');
        end
    elseif staircase_id_dis==3
    %     if length(x_axis1)<10
    %         plot(zeros(1,length(ses2_SNR_list)),'linewidth',0.0001, 'color','k');
    %         %����������⡣
    %     else
            plot(zeros(1,length(x_axis1)),'linewidth',0.0001, 'color','k');
    %     end
    end
        
    if measure_type(1)==1 %�㶨�̼���
        xlabel('step');
        if staircase_id_dis == 2
            ylabel('�жϰٷ���');
        elseif staircase_id_dis==3
            ylabel('d''');
        end
        ylim([0 1]);
        if staircase_id_dis==2 || 3
            xlim([0 length(x_axis1)+1]);
            set(gca,'XTick',0:1:length(x_axis1)+1) 
        end
        if bsliang_mod(to_test_substep,4)==1 || bsliang_mod(to_test_substep,4)==3
            const_xTick_lab={Zjudge_text,Mjudge_text};
        elseif bsliang_mod(to_test_substep,4)==2 || bsliang_mod(to_test_substep,4)==4
            const_xTick_lab={Zjudge_text,Mjudge_text};
        end
        
        if staircase_id_dis==2
            xtick=cell(1,length(ses2_SNR_list)+2); %ses2_SNR_list=1:5
            for xtick_i=2:(size(xtick,2)-1)
                xtick{1,xtick_i}=['step',num2str(ses2_SNR_list(1,xtick_i-1))];
            end
            xtick{1,1}=const_xTick_lab{1};
            xtick{1,end}=const_xTick_lab{2};
        elseif staircase_id_dis==3
            %         xtick=cell(1,length(ses2_SNR_list));
            %         for xtick_i=1:(size(xtick,2)-1)
            %             xtick{1,xtick_i}=num2str(ses2_SNR_list(1,xtick_i));
            %         end
                    xtick=Di_xaxis;
                    xtick{1}=const_xTick_lab{1};
                    xtick{end}=const_xTick_lab{2};
            %         xtick{1,1}=[const_xTick_lab{1},xtick{1,1}];
            %         xtick{1,end}=[const_xTick_lab{2},xtick{1,end}];
        end
        
        %xtick{1,end}='nn';
        set(gca,'XTickLabel',xtick);
    elseif measure_type(1)==2 %���ݷ�
        ylim([0 size(stimfile,2)+1]);
        xlabel('�Դ�(trials)');
        ylabel('����Ӧ����');
    end
    
    hold on

    if ~isempty(x_axis1)
        plot(x_axis1,y_axis1,'k');
    end
    
    if ~isempty(x_axis2)
        plot(x_axis2,y_axis2,'k');
    end
    
    plot_meanvalue(meanvalue1);
    plot_meanvalue(meanvalue2);
    
    hold off
    
    if measure_type(1)==2
        subplot(2,3,[2 3])
        
        SC_plottingupdowngroup(1);
        hold on
        plot(1:length(y_axis1),y_axis1,'k');
        
        plot_staircase(scatter_points_positive_1,scatter_points_negative_1);
        
        hold off
        xlim([0 length(y_axis1)+1]);
        ylim([0 size(stimfile,2)+1]);
        xlabel('trials');
        ylabel('����Ӧ����');
        title('������1��ʼ������');
        
        subplot(2,3,[5 6])
        
        SC_plottingupdowngroup(2);
        hold on
        plot(1:length(y_axis2),y_axis2,'k');

        plot_staircase(scatter_points_positive_2,scatter_points_negative_2);
        hold off
        xlim([0 length(y_axis2)+1]);
        ylim([0 size(stimfile,2)+1]);
        xlabel('trials');
        ylabel('����Ӧ����');
        title('������2��ʼ������'); 
        
    end
    
    uicontrol(handles.playbutton);
        
function [meanvalue,scatter_points_positive,scatter_points_negative]=calculate_threshold(data_x,data_y,direction)
    %memory_buffer{direction}=[memory_buffer{direction};trialcount,currentstep(direction),currentjudge(direction),rt];
    global memory_buffer counttingruns stepcode lastmeanvalue threshold_boundaries
    
    scatter_points_positive=[];
    scatter_points_negative=[];
    if size(memory_buffer{direction},1)>1
        meanvalue=cell(1,stepcode(direction));
    else
        meanvalue=[];
    end
    
    %disp('Initial meanvalue:');
    %meanvalue
    
    try
    %memory_buffer{direction}: trialcount,currentstep(direction),currentjudge(direction),rt;
        for memory_trial=1:size(memory_buffer{direction},1)
            if memory_buffer{direction}(memory_trial,3)==0
                scatter_points_negative=[scatter_points_negative;memory_trial,memory_buffer{direction}(memory_trial,2)]; %x,y
            elseif memory_buffer{direction}(memory_trial,3)==1
                scatter_points_positive=[scatter_points_positive;memory_trial,memory_buffer{direction}(memory_trial,2)]; %x,y
            end  
        end
    catch
    end
    
    
    %counttingruns{direction}=[counttingruns{direction};stepsize(direction),up_or_down,mean(memory_buffer{direction}((end-(length(judgegroup{direction})-1)+1):end,2),1)];
    if size(memory_buffer{direction},1)>1
        for stepcode_i=1:stepcode(direction)
            try
                selected_counting_index=counttingruns{direction}(:,4)==stepcode_i;
                selected_even_index=zeros(length(selected_counting_index),1);
                selected_even_index(2:2:end)=1;
                selected_even_index=logical(selected_even_index);
                selected_counting_index=selected_counting_index.*selected_even_index;
                selected_counting_index=logical(selected_counting_index);
                meanvalue{stepcode_i}=mean(counttingruns{direction}(selected_counting_index,3),1);
                %disp(['Now start to calculate meanvalue of step size group ',num2str(stepcode_i),' in total ',num2str(stepcode(direction)),' groups']);
                %meanvalue{stepcode_i}
            catch
            end
        end
    end
    
    try
        if ~isempty(meanvalue{stepcode(direction)}) && ~isnan(meanvalue{stepcode(direction)})
            lastmeanvalue(direction)=meanvalue{stepcode(direction)};
        end
    catch
    end
    
    threshold_boundaries{1,direction}=meanvalue;
    
 
function plot_meanvalue(meanvalue)
    global trialcount
    % stepsize_steprange{direction,stepcode(direction)}
    for stepcode_i=1:4
        try
            if ~isempty(meanvalue{stepcode_i})
                plot([1 trialcount],[meanvalue{stepcode_i} meanvalue{stepcode_i}],'g');
                text((1 + trialcount)/2,meanvalue{stepcode_i}+0.5,['Stage: ',num2str(stepcode_i),'; Mean: ',num2str(meanvalue{stepcode_i})]);
            end
        catch %errorinfo
            %errorinfo
        end
    end

    
function plot_staircase(scatter_points_positive,scatter_points_negative)

    if ~isempty(scatter_points_positive)
        text(scatter_points_positive(:,1),scatter_points_positive(:,2),'+','FontSize',10);
    end
    if ~isempty(scatter_points_negative)
        text(scatter_points_negative(:,1),scatter_points_negative(:,2),'-','FontSize',10);
    end

function closeScreen(~,~,handles)
   global  fclose 
    fclose=figure('position',[100,100,200,100]);
    %����һ���������ڣ�Ҫ��������˼�����У���֤�����󰴣�
    uicontrol('Style','text','String','�����Ҫ������=��=��','Position',[0,-25,200,100]);
    uicontrol('Style','pushbutton','String','�ǵ���Ҫ����','Position',[0,0,100,50],'Callback',{@yes_close_step,handles});
    uicontrol('Style','pushbutton','String','���һ���ȵ�','Position',[100,0,100,50],'Callback',{@no_close_step});

function yes_close_step(~,~,handles)
    %���Ǳ���Ҫ������ݵİ�ť�����ĺ���
    global fclose 
    endTest(handles); %�����������
    %��Ȼ�����ˣ��͹ص���Щ��ť��
    set(handles.playbutton,'enable','off');
    set(handles.screen_Syllable1,'enable','off');
    set(handles.screen_Syllable2,'enable','off');
    close(fclose); %�ص���������
    
function no_close_step(~,~)
    %�����������ѡ��������ݵİ�ť�����ĺ���
    global fclose
    close(fclose);
