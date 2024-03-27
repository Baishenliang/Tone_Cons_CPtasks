%【(￣▽￣)~*】标识为需要从主程序中读取的global变量

%20181213起来把散点图的认真看一次！！！求平均值确定没搞错！！另外！！记得看最后求阈值算的是总的平均还是最后一个stepsize组的平均！！！最后！！记得搞change
%step size，试验时间长度！！！

function varargout = lbsCP_parScreen(varargin)
%这个函数是电脑自己生成的，别管了
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
%左耳需要乘以一个系数来确保和右耳相同
global adjust_k adjust_noise_k

% Zjudge:按Z键判断的音节
% Mjudge:按M键判断的音节
global endscreenfig
endscreenfig=figure(1);
set(endscreenfig,'position',[100,100,200,100]);
uicontrol('Style','pushbutton','String','结束','Fontsize',50,'BackgroundColor',[0.231 0.443 0.337],'Position',[0,0,200,100],'Callback',{@closeScreen,handles});

% 将gui默认投影到第二屏幕的方法：
% step1： 输入figure，创建一个图形；
% step2： 将图形拖到第二屏幕，最大化；
% step3： 在matlab界面运行gcf；
% step4： 读取gcf的输出值：Position
% step5： 将这个Position值写到下面这行代码里面
 set(handles.figure_Screen,'Position',[1921 -215 1920 1.0056e+03]);
% step6： 将lbsCP_parScreen.fig的Unit属性改成“pixels”

global ISI_lst
ISI_lst=0.4:0.01:0.6;
% ===============================================
% =============每台电脑都需要调整的东西============
% ================================================
global is_break_keyproc
is_break_keyproc=0;
%用于按键反应程序检测是否测验已被终止，若被终止，该值为1，跳出循环

global current_db output_latency
current_db=66;
%这是校正声强要做的事情：把当前的分贝数记录下来（后面还会有一些公式通过这个分贝数计算出声音刺激应有的强度）
output_latency=0.002426304;
%这是声音输出的延时，在反应时和神经振荡记录上十分重要！
    
global display_instruct staircase_id_dis addnoise measure_type par_code par_name par_age fid onlinefig stimfilename to_test_substep ses2_SNRcode ses2_CONcode ses2_SNR_list ses2_SNR_pos ses2_SNR_pos_list ses2_CON2code ses2_stimcluster ses2_SNR_list_org

if addnoise==1
    stimfilename=['Noise_',stimfilename{1}];
else
    stimfilename=stimfilename{1};
end

global interact_type %【(￣▽￣)~*】 
%测验类型：1：恒定刺激法；2：one-up-one-down自适应法
onlinefig=figure(2);

%以下：读取刺激文件和刺激呈现序列
global randomorder %【(￣▽￣)~*】
global stimfile Di_stimcluster %【(￣▽￣)~*】

if measure_type(1)==1
    write_method='Constant Stimuli';
    set(onlinefig,'position',[660 240 600 600]);
    ses2_SNRcode = stimfile(2,:); %实验刺激本身的条件（如tone任务中的tone step）
    ses2_SNR_list = cell2mat(ses2_SNRcode);
    ses2_SNR_pos_list=cell2mat(ses2_SNRcode);
    if staircase_id_dis==3
        ses2_SNR_list_org = ses2_SNR_list;
    end
    
    ses2_SNR_list = unique(ses2_SNR_list);
    ses2_SNR_pos = 1:length(ses2_SNR_list);
    %ses2_SNR_pos_list = repmat(ses2_SNR_pos,1,length(unique(cell2mat(stimfile(4,:))))); 
    ses2_CONcode = stimfile(3,:);
    ses2_CON2code = stimfile(4,:);%实验刺激正交维度的条件（如tone任务中的phon step）
    

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

%下面是键盘编码（仅用于键盘反应）
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
        % staircase法
        zKey = KbName(',<');
        mKey = KbName('.>');  
    else
        if mod(par_code,2)==0
            % 偶数（不反过来）
            zKey = KbName(',<');
            mKey = KbName('.>');
        elseif  mod(par_code,2)==1
            % 奇数（反过来）
            zKey = KbName('.>');
            mKey = KbName(',<'); 
        end
    end
    if resp_hand==1 %被试用左手反应
        press_l='用左手中指按“<”键';
        press_r='用左手食指按“>”键';
    elseif resp_hand==2 %被试用右手反应
        press_l='用右手食指按“<”键';
        press_r='用右手中指按“>”键';
    end
end

%以下是保存实验流水成txt文本（这是很重要的，因为以前试过实验程序炸了，但被试基本上已经做完了。万一出现这种情况，还有每个trial保存一次的流水可以查。
fid = fopen(['./results/No_',num2str(par_code),'_',par_name,'_log.txt'],'a');
fprintf(fid,'%s\t%s\t%s\t%s\t%s\n','PAR_INFO','Name:',par_name,'Age:',num2str(par_age));
fprintf(fid,'%s\t%s\t%s\t%s\t%s\n','CONDITIONS','Step',num2str(to_test_substep),'Stimfile',ses2_cond);
fprintf(fid,'%s\t%s\t%s\t%s\t%s\n','PARAMETERS','Method',write_method,'Interactive',write_interact);
fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\n','Time','Trial','Direction','Stimuli','Response','Reactin Time');


%以下：读取并设置按钮显示的文字
global Zjudge_text %【(￣▽￣)~*】
global Mjudge_text %【(￣▽￣)~*】

global cue_disp is_def_range

if staircase_id_dis==1
    % staircase预实验四个条件的顺序
    % 不平衡左右手
    % di1_di2  低-敌 
    % di2_ti2  敌-提
    % ti1_ti2  踢-提
    % di1_ti1  低-踢

    instruct=cell(4,1);
    % staircase不再设置左右手平衡
    inst_begin='正式阶段分为四个部分。在这一部分，';
    inst='你需要判断你听到的音节是';
    inst_ch=[Zjudge_text,'还是',Mjudge_text];
    inst_if='如果听到';
    press_l='用左手食指按“z”键';
    press_r='用右手食指按“m”键';
    press_OK='您需要尽量判断准确。现在你可以点击“确定”键开始此阶段';

    instruct{1,1}=[inst_begin,inst,inst_ch,'。',inst_if,Zjudge_text,press_l,'，',inst_if,Mjudge_text,press_r,'。',press_OK,'。'];
    instruct{2,1}=[inst_begin,inst,inst_ch,'。',inst_if,Zjudge_text,press_l,'，',inst_if,Mjudge_text,press_r,'。',press_OK,'。'];
    instruct{3,1}=[inst_begin,inst,inst_ch,'。',inst_if,Zjudge_text,press_l,'，',inst_if,Mjudge_text,press_r,'。',press_OK,'。'];
    instruct{4,1}=[inst_begin,inst,inst_ch,'。',inst_if,Zjudge_text,press_l,'，',inst_if,Mjudge_text,press_r,'。',press_OK,'。'];


    inst_di1di2_cue={Zjudge_text,Mjudge_text}; %[改到这里！！！！]
    inst_di2ti2_cue={Zjudge_text,Mjudge_text};
    inst_ti1ti2_cue={Zjudge_text,Mjudge_text};
    inst_di1ti1_cue={Zjudge_text,Mjudge_text};

    % inst_tone_ch_inv_cue={inst_tone_ch_inv(1:2),inst_tone_ch_inv(5:6)};
    % inst_phon_ch_inv_cue={inst_phon_ch_inv(1:3),inst_phon_ch_inv(6:8)};

    cue_disp=cell(4,1);
    % staircase不再设置左右手平衡
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
        set(handles.screen_Intro,'String','请您休息一下。休息好后按【确定】继续。');
    end

    %Identification
elseif staircase_id_dis==2
    
    instruct=cell(4,2);
    % 第一列：左手； 第二列：右手
    %inst_begin=['现在进入测试，接下来是第',num2str(sub_test_count),'部分。在这一部分，'];
    inst_begin='现在进入测试。在这一部分，';
    inst_toneC='你需要判断你听到的音节的声调是';
    inst_phonC='你需要判断你听到的音节的声母是';
    inst_toneN='你需要判断你听到的音节的声调是';
    inst_phonN='你需要判断你听到的音节的声母是';
    inst_tone_ch=[Zjudge_text,'还是',Mjudge_text];
    inst_phon_ch=[Zjudge_text,'还是',Mjudge_text];
    inst_tone_ch_inv=[Mjudge_text,'还是',Zjudge_text];
    inst_phon_ch_inv=[Mjudge_text,'还是',Zjudge_text];
    inst_tone_1=['如果听到',Zjudge_text];
    inst_tone_2=['如果听到',Mjudge_text];
    inst_phon_b=['如果听到',Zjudge_text];
    inst_phon_p=['如果听到',Mjudge_text];
    %press_OK='您需要保证【正确】的同时【迅速】反应。现在你可以点击“确定”键开始此阶段';
    if is_def_range
        press_OK='请尽量保证反应【正确】，在5秒内反应即可(不记速度)。现在你可以点击“确定”键开始此阶段';
    else
        press_OK='请您保证【正确】的同时【迅速】反应。现在你可以点击“确定”键开始此阶段';
    end
    instruct{1,1}=[inst_begin,inst_toneC,inst_tone_ch,'。',inst_tone_1,press_l,'，',inst_tone_2,press_r,'。',press_OK,'。'];
    instruct{2,1}=[inst_begin,inst_phonC,inst_phon_ch,'。',inst_phon_b,press_l,'，',inst_phon_p,press_r,'。',press_OK,'。'];
    instruct{3,1}=[inst_begin,inst_toneN,inst_tone_ch,'。',inst_tone_1,press_l,'，',inst_tone_2,press_r,'。',press_OK,'。'];
    instruct{4,1}=[inst_begin,inst_phonN,inst_phon_ch,'。',inst_phon_b,press_l,'，',inst_phon_p,press_r,'。',press_OK,'。'];
    instruct{1,2}=[inst_begin,inst_toneC,inst_tone_ch_inv,'。',inst_tone_2,press_l,'，',inst_tone_1,press_r,'。',press_OK,'。'];
    instruct{2,2}=[inst_begin,inst_phonC,inst_phon_ch_inv,'。',inst_phon_p,press_l,'，',inst_phon_b,press_r,'。',press_OK,'。'];
    instruct{3,2}=[inst_begin,inst_toneN,inst_tone_ch_inv,'。',inst_tone_2,press_l,'，',inst_tone_1,press_r,'。',press_OK,'。'];
    instruct{4,2}=[inst_begin,inst_phonN,inst_phon_ch_inv,'。',inst_phon_p,press_l,'，',inst_phon_b,press_r,'。',press_OK,'。'];

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
    % 第一列：左手； 第二列：右手
    %inst_begin=['现在进入测试，接下来是第',num2str(sub_test_count),'部分。在这一部分，'];
    inst_begin=['现在进入测试。在这一部分，'];
    inst_toneC='你需要判断你听到的两个音节的【声调】';
    inst_phonC='你需要判断你听到的两个音节的【声母】';
    inst_toneN='你需要判断你听到的两个音节的【声调】'; %“在噪音环境下”
    inst_phonN='你需要判断你听到的两个音节的【声母】'; %“在噪音环境下”
    inst_tone_ch='一致还是不一致';
    inst_phon_ch='一致还是不一致';
    inst_tone_ch_inv='不一致还是一致';
    inst_phon_ch_inv='不一致还是一致';
    inst_tone_1='如果一致';
    inst_tone_2='如果不一致';
    inst_phon_b='如果一致';
    inst_phon_p='如果不一致';
    press_OK='您需要【非常仔细地听辨】，并保证【正确】的同时【迅速】反应。现在你可以点击“确定”键开始此阶段';

    instruct{1,1}=[inst_begin,inst_toneC,inst_tone_ch,'。',inst_tone_1,press_l,'，',inst_tone_2,press_r,'。',press_OK,'。'];
    instruct{2,1}=[inst_begin,inst_phonC,inst_phon_ch,'。',inst_phon_b,press_l,'，',inst_phon_p,press_r,'。',press_OK,'。'];
    instruct{3,1}=[inst_begin,inst_toneN,inst_tone_ch,'。',inst_tone_1,press_l,'，',inst_tone_2,press_r,'。',press_OK,'。'];
    instruct{4,1}=[inst_begin,inst_phonN,inst_phon_ch,'。',inst_phon_b,press_l,'，',inst_phon_p,press_r,'。',press_OK,'。'];
    instruct{1,2}=[inst_begin,inst_toneC,inst_tone_ch_inv,'。',inst_tone_2,press_l,'，',inst_tone_1,press_r,'。',press_OK,'。'];
    instruct{2,2}=[inst_begin,inst_phonC,inst_phon_ch_inv,'。',inst_phon_p,press_l,'，',inst_phon_b,press_r,'。',press_OK,'。'];
    instruct{3,2}=[inst_begin,inst_toneN,inst_tone_ch_inv,'。',inst_tone_2,press_l,'，',inst_tone_1,press_r,'。',press_OK,'。'];
    instruct{4,2}=[inst_begin,inst_phonN,inst_phon_ch_inv,'。',inst_phon_p,press_l,'，',inst_phon_b,press_r,'。',press_OK,'。'];

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

global trialcount %计算已经经历的trials数
trialcount=0;

%下面的几个变量是实验程序中很关键的变量（虽然所有的变量都很关键）
%currentstep是指当前这个trial（将要）播放的是序列中的哪一个step
%currentjudge是指当前这个trial被试的判断，这个判断会作为response储存在数据中，而且在阶梯法中，这还是判断下一个trial应该呈现什么刺激的判据
%judgegroup是staircase专用：记录被试判断的序列
%UpDownTrialgroupMark是staircase专用：用于记录每个trial属于up组（组过后往上抬）还是属于down组（组过后往下挪），给背景填充做准备
%counttingruns是staircase专用：用于记录每个direction走过了多少过run以及每个run平均steps数
%stepsize是staircase专用，用来指示下一次变换step的size，最短为1step，最长为……刚开始推荐5steps
%lastmeanvalue是staircase专用，当改变step的位置要依靠上几个run的均值时，用这个lastmeanvalue
%rt就是反应时啦
global gbstepsize currentstep currentjudge rt judgegroup UpDownTrialgroupMark counttingruns stepsize lastmeanvalue w_subj_cond
%初始化step和judge
if measure_type(1)==1 %如果选取了恒定刺激法
    %恒定刺激法
    currentstep=randomorder(1); %第一个trial选取的是randomorder的第一个数
    currentjudge=0; %刚开始currentjudge默认为0
    judgegroup=[];
    UpDownTrialgroupMark=[];
    counttingruns=[];
    stepsize=[];
    lastmeanvalue=[];
elseif measure_type(1)==2 %如果选取了阶梯法
    %阶梯法
    disp(stimfilename);
    if isequal(stimfilename,[w_subj_cond{1},'.mat']) || isequal(stimfilename,[w_subj_cond{3},'.mat'])
        currentstep=[1,size(stimfile,2)]; %定义初始声音为Syllable1,Syllable2
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
    
    UpDownTrialgroupMark=cell(1,2); %有两个direction
    UpDownTrialgroupMark{1}=cell(1,2);
    UpDownTrialgroupMark{2}=cell(1,2);%每个direction有up和down两个组
    
    counttingruns=cell(1,2); %有两个direction
    
    stepsize=[5,5]; %有两个direction
    
    lastmeanvalue=[1,size(stimfile,2)];  %有两个direction
    
end

rt=0; %反应时初始值

global memory_buffer staircase_stopruns_list staircase_stopruns_changenum staircase_stop_here
%记忆缓存，用于暂时储存被试的反应
if measure_type(1)==1 %如果是恒定刺激法，只需要一个3列N行的列表
    %[20190321改,buffer的行数从3改成了4]
    memory_buffer=zeros(size(randomorder,2),4);
    %第一列记录音节的step；第二列记录被试的判断；第三列记录反应时（默认为0）
elseif measure_type(1)==2
    %如果是阶梯自适应法，需要一个2单元格的cell（代表两个direction），每个cell里面一个2列N行的列表
    memory_buffer=cell(1,2);
    %每个cell代表一个direction
end

staircase_stopruns_list=cell(1,2);
%这是给判断staircase是否终止用的列表，从达到某一stepsize
%group开始数经历了多少个runs，每个run的up_or_down是什么
staircase_stopruns_changenum{1} = 0;
staircase_stopruns_changenum{2} = 0;
%这是给判断staircase是否终止用的,计算上面那个列表里up_or_down转换的次数
staircase_stop_here=0;
%当这个变为1时，自动保存数据并结束程序

global half_threshold threshold_boundaries
%用于输出的变量
half_threshold=[];
threshold_boundaries=cell(1,2); %有两个方向
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%【20190109】加个恒定刺激法的，这时候一半阈值应该变为每个SNR上的百分比%%%%%%%%%%%%%%%%%

%[20190416增加]
global noise_bg fs_noise_bg noise_filename
[noise_bg,fs_noise_bg]=audioread(noise_filename);

global soundBuffer param
% 采用psychportaudio建立声音buffer，可以快速调取
InitializePsychSound;
deviceID=setDeviceID('subject');
param = PsychPortAudio('Open',deviceID,1+8,2,44100,2);          % 主设备（这些参数就这么用OK）
% soundBuffer=cell(1,size(stimfile,2)+1); %这是储存缓冲了的声音文件的buffer,[20190416改]最后一个是噪声
soundBuffer=cell(1,size(stimfile,2)); %这是储存缓冲了的声音文件的buffer
% 第一行输入slaveID，第二行输入buffer
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

% BSLiang 20201025 增加了online打TMS的部分，这个把线拔掉也没问题，但是也可以block掉 
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
set(handles.screen_Intro,'String','正在保存中，请稍后O(∩_∩)O，可以休息一下。');
global ses2_cond
saveas(figure(2),['./result_plots/No_',num2str(par_code),'_',par_name,'_',ses2_cond,'_',strrep(strrep(strrep(datestr(now),':','_'),' ','_'),'-','_'),'.png']);
clearvars -except varargout onlinefig handles
delete(onlinefig);
delete(handles.figure_Screen);


% --- Executes on button press in startbutton.
function startbutton_Callback(hObject, eventdata, handles)
%这是按了红红的【开始】按钮后程序出现的过程

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

%以下，关掉两个反应按钮（要等声音播放了才开启）
set(handles.screen_Syllable1,'enable','off');
set(handles.screen_Syllable2,'enable','off');

%global noise_bg fs_noise_bg
%sound(noise_bg,fs_noise_bg)

global param addnoise
%开启PPA
PsychPortAudio('Start',param,0,0);

% if addnoise==1
% PsychPortAudio('Start',soundBuffer{1,end},0,0); %[20190416,重复播放背景噪音]
% end

if interact_type(1)==1
    %如果交互方式是被试按屏幕上的按钮    
    set(handles.playbutton,'Visible','on');
    set(handles.playbutton,'enable','on');
    set(handles.screen_Syllable1,'Visible','on');
    set(handles.screen_Syllable2,'Visible','on');
else
    %如果交互方式是被试用键盘按键
    key_press_exp_proc(handles)
end

% set(handles.screen_Intro,'String','+');


function key_press_exp_proc(handles)
%这就是著名的，当主试选择了让被试按键时开启实验流程的循环的函数
    global  is_break_keyproc fid param ISI_lst %trialcount
    for keypress_step=1:10000%for循环步数调到非常大，需要人工结束掉（比如按结束键），这主要是考虑到阶梯法不太确定被试需要做多少个trial才能OK
        if is_break_keyproc==1%在运行一个trial之前，检查一下是否已经按下了结束键或者实验程序（对于恒定刺激法这个模式）已经终止了
            save_data(handles);%保存好数据
            %以下：关掉所有按钮
            set(handles.playbutton,'enable','off');
            set(handles.screen_Syllable1,'enable','off');
            set(handles.screen_Syllable2,'enable','off');
            %以下：关掉PPA
            PsychPortAudio('Stop',param);
            PsychPortAudio('Close',param);
            fclose(fid);
            break;
        end
     
        %pause(0.4+rand(1,1)*(0.6-0.4));
        %%暂停,注意这是原泉和姜欣桐版本的等待，我的新版本是10ms一个step的
        pause(ISI_lst(randi(length(ISI_lst),1,1))); % 新版的等待是这样的：400~600ms，以10ms为一个step，随机选。ISI_lst是在程序一开始就定义了的。
        %trialcount = trialcount + 1; %将trialcount加一 [20190709]
        play_sound_key(handles);  %播放声音的函数（专门用于按键反应）
    end

% for soundID=1:size(stimfile,2)
%    PsychPortAudio('DeleteBuffer',soundBuffer{2,soundID});
% end


% --- Executes on button press in endbutton.
function endbutton_Callback(hObject, eventdata, handles)
% hObject    handle to endbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 这是主试主动按结束键时激活的函数，
endTest(handles); %结束这个测试

%既然结束了，就关掉这些按钮吧
set(handles.playbutton,'enable','off');
set(handles.screen_Syllable1,'enable','off');
set(handles.screen_Syllable2,'enable','off');

function endTest(handles)
    %结束测试的函数
    global param fid is_break_keyproc interact_type soundBuffer addnoise
    is_break_keyproc=1;
    if interact_type(1)==1
        save_data(handles);
%         if addnoise==1
%             PsychPortAudio('Stop',soundBuffer{1,end});%[20190416,结束播放背景噪音]
%         end
        PsychPortAudio('Stop',param);
        PsychPortAudio('Close',param);
        fclose(fid);
    end

function save_data(handles)
    uiresume(handles.figure_Screen);
%保存数据


% --- Executes on button press in playbutton.
%按下【播放声音】按钮时的事件
function playbutton_Callback(hObject, eventdata, handles)
% hObject    handle to playbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.playbutton,'enable','off');%播放声音之前，先马上关掉播放声音的按钮，以免被试重复按键
play_sound_button();%播放声音
set(handles.screen_Syllable1,'enable','on');%激活两个被试要反应的按钮
set(handles.screen_Syllable2,'enable','on');

function play_sound_button()
global direction trialcount measure_type
global ioObj address
%新加了一个direction变量，说白了这个是专门为阶梯法设计的：阶梯法有两个direction，从上至下和从下至上两个方向
if measure_type(1)==1
    %恒定刺激法下direction总是1
    direction=1;
elseif measure_type(1)==2
    %阶梯法下，每个trial开始时方向随机（上下或下上）
    direction=Randi(2); % Randomly select one direction
end
%每进入一个trial，trialcount就加一
trialcount=trialcount+1;
disp('================================================================');
disp(['This is the No,',num2str(trialcount),' trial of the experiment']);
disp('================================================================');
global soundBuffer currentstep
%等待一秒钟之后，就开！始！放！声！音！啦！
pause(1);
io64(ioObj,address,1); 
PsychPortAudio('Start',soundBuffer{1,currentstep(direction)},1,0);
pause(0.5);
io64(ioObj,address,0);  
PsychPortAudio('Stop',soundBuffer{1,currentstep(direction)});

function play_sound_key(handles)
%细心的你肯定会发现，我们这个程序有两个播放声音的函数，一个是play_sound_button，另一个是play_sound_key，
%前者是通过屏幕按钮按键播放声音，后者是通过键盘按键播放声音。比如下面这个，就是可以记录键盘反应的声音播放函数。
global direction measure_type rt is_break_keyproc trialcount staircase_id_dis
global ioObj address 
%以下：也就是根据测量方法来选择direction（恒定只有一个方向，阶梯两个方向）
if measure_type(1)==1
    direction=1;
elseif measure_type(1)==2
    direction=Randi(2); % Randomly select one direction
end
global soundBuffer currentstep par_keyboard zKey mKey %output_latency
io64(ioObj,address,1);
PsychPortAudio('Start',soundBuffer{1,currentstep(direction)},1,0);%开始播放声音
%handles.figure_Screen
tStart = GetSecs;
if staircase_id_dis==3
    pause(0.369+0.5); %[20190709]
end
while 1
    %这是一个while，在声音开始播放之后马上开始检测键盘，直到被试按了指定的键，跳出循环，这个while结束。
    [~,~,keyCode] = KbCheck(par_keyboard);
    timer = GetSecs-tStart; %这是开始算反应限时
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
        %被试没有反应，直接跳过
        break;
    end
end
io64(ioObj,address,0);
PsychPortAudio('Stop',soundBuffer{1,currentstep(direction)});


% --- Executes on button press in screen_Syllable1.
% 选了【音节1】（左边）时触发的事件 （反应记为-）
function screen_Syllable1_Callback(hObject, eventdata, handles)
% hObject    handle to screen_Syllable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%一旦按下了按钮，播放声音的按钮就会被激活啦
set(handles.playbutton,'enable','on');
%所以按键的按钮重新按不了，下面的也是
set(handles.screen_Syllable1,'enable','off');
set(handles.screen_Syllable2,'enable','off');
par_response(0,handles);

% --- Executes on button press in screen_Syllable2.
% 选了【音节2】（右边）时触发的事件（反应记为+）
function screen_Syllable2_Callback(hObject, eventdata, handles)
% hObject    handle to screen_Syllable2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%跟上面那个按钮反应一样，我不啰嗦了
set(handles.playbutton,'enable','on');
set(handles.screen_Syllable1,'enable','off');
set(handles.screen_Syllable2,'enable','off');
par_response(1,handles);

function par_response(resp,handles)
    %par_response这个函数是用来调取后面的函数，储存该trial的信息（实验刺激、被试反应、反应时）、作图，判断下一个step应该呈现什么东西
    global currentjudge direction judgegroup staircase_stop_here measure_type
    if measure_type(1)==1
        currentjudge=resp;%储存currentjudge
    elseif measure_type(1)==2    
        currentjudge(direction)=resp;%储存currentjudge
    end
    if measure_type(1)==2
        %阶梯法
        judgegroup{direction}=[judgegroup{direction},resp];
    end
    MemoryAndPlot_Memory()
    SCnextstepchange=SCnextstepjudge(4,2,handles);
    MemoryAndPlot_Plot(handles);%储存信息，以及作图
    if staircase_stop_here==1
        endTest(handles);
    end
    JudgeNextStep(handles,SCnextstepchange);%判断下一个trial
    
    % 来模拟一下这里面参数的变化，假设现在刚好跑到第4个run的最后一个，第四个run全是“++++”，所以最后一个跑完后开始第五个run。
    % 初始值:
    % stepsize=10,stepcode=1,counttingruns并未包含第四个runs,lastmeanvalue应该是第二个run的均值;
    % 第一步： MemoryAndPlot_Memory()：加载记忆，此时memory_buffer已经包含了这个trial的“+”
    % 第二步： SCnextstepjudge：countingruns已经包含了第四个run               【connttingruns+】
    %          注意在此时，第四步的no_runs已经变成4了。
    % 第三步： MemoryAndPlot_Plot(handles)：改变lastmeanvalue                【lastmeanvalue+】
    % 第四步： JudgeNextStep(handles,SCnextstepchange)， 运行到此时，【stepsize=5，stepcode=2，下一个阶段从上一个阶段的均值开始】
    % 【因此，第四个run在countingruns里记录到的依然是属于第一个stepcode】
    
function MemoryAndPlot_Memory()
    global memory_buffer staircase_id_dis measure_type currentstep currentjudge direction trialcount ses2_CON2code rt ses2_SNR_pos_list ses2_CONcode ses2_SNR_list_org
    
    if measure_type(1)==1  %储存数据和作图要分恒定刺激法
        %恒定刺激法
        if isequal(ses2_CONcode(1,currentstep),{1})
            %正确的按键应该是按左键
            if currentjudge == 0
                %所以按了左键，对了
                SNR_correct = 1;
            elseif currentjudge == 1
                %所以按了右键，错了
                SNR_correct = 0;
            end
        elseif isequal(ses2_CONcode(1,currentstep),{2})
            %正确的按键应该是按右键
            if currentjudge == 0
                %所以按了左键，错了
                %在连续体判断里面，按了左键，就相当于判断成连续体左端的那个点，因此记为0；
                SNR_correct = 0;
            elseif currentjudge == 1
                %所以按了右键，对了
                %在连续体判断里面，按了右键，就相当于判断成连续体右端的那个点，因此记为1.
                SNR_correct = 1;
            end
        end
        if (staircase_id_dis == 1) || (staircase_id_dis == 2)
            Const_thisCOND=ses2_SNR_pos_list(1,currentstep);
        elseif staircase_id_dis == 3
            Const_thisCOND=ses2_SNR_list_org(1,currentstep);
        end
        Const_otherCOND=ses2_CON2code{1,currentstep};
        memory_buffer(trialcount,:)=[Const_thisCOND,SNR_correct,rt,Const_otherCOND];%呼~终于把这个trial的信息缓存了
    if staircase_id_dis == 3
        correct_rate=sum(memory_buffer(1:trialcount,2))/trialcount;
        disp(['正确率 = ',num2str(correct_rate*100),'%']);
    end
        %[20190120：如果按照杜老师今天所述，就改改judge或者正确判断的条件好了：只有刺激编码跟按键判断编码一致才判断为正确。]
    elseif measure_type(1)==2
        %阶梯法
        memory_buffer{direction}=[memory_buffer{direction};trialcount,currentstep(direction),currentjudge(direction),rt];
    end

function MemoryAndPlot_Plot(handles)
    % type=1,恒定刺激法; type=2,one-down-one-up自适应法
    %（adaptive_para只在type=2时需要填，在目前只包含direction一个参数)
    global stimsteplength %【(￣▽￣)~*】实验刺激的步长
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

    %等我慢慢讲下：
    %memory_buffer：记忆储存，前面讲过
    %measure_type(1)：测量类型，我反复说啦，要么是恒定刺激法要么是阶梯法
    %currentstep：当前的step，也说过了
    %currentjudge：“我早就说过了嘛！”
    %direction： 方向
    %trialcount：算了我不想说了……
    %fid：就是储存txt文件的地方，这是拿来做trials记录的
    if measure_type(1)==1  %储存数据和作图要分恒定刺激法
        %恒定刺激法
        %以下：作图用的数据矩阵
             
        if staircase_id_dis == 2
            this_constant_socre=zeros(length(ses2_SNR_pos),2);
            this_constant_steps=ses2_SNR_pos;
            this_constant_score(:,1)=this_constant_steps';%给矩阵的第一列赋值：每个step一行
            for step_type=ses2_SNR_pos %计算每个step的平均数，并且存到作图用的数据矩阵中
                if ~isempty(memory_buffer(memory_buffer(:,1)==step_type,2))
                    step_score=mean(memory_buffer(memory_buffer(:,1)==step_type,2));
                else
                    step_score=0;
                end
                %上面那个if的意思是，如果已经做了某些steps的trials，那么就求出均值，如果没做过，那么这个trial的值先记为0.
                this_constant_score(step_type,2)=step_score;
            end
        elseif staircase_id_dis == 3
            this_constant_socre=zeros(size(ses2_stimcluster,1),2);
            this_constant_steps=1:size(ses2_stimcluster,1);
            this_constant_score(:,1)=this_constant_steps';%给矩阵的第一列赋值：每个step一行
            for step_type=1:size(ses2_stimcluster,1) %计算每个step的平均数，并且存到作图用的数据矩阵中
                mmbf=memory_buffer(:,1);
                mmbc=ses2_stimcluster(step_type,:);
                if ~isempty(memory_buffer(logical((mmbf==mmbc(1))+(mmbf==mmbc(2))+(mmbf==mmbc(3))+(mmbf==mmbc(4))),2))
                    %20190512:检查到这里
                    step_score_diff=mean(memory_buffer(logical((mmbf==mmbc(1))+(mmbf==mmbc(2))),2));
                    step_score_same=mean(memory_buffer(logical((mmbf==mmbc(3))+(mmbf==mmbc(4))),2));
                    step_score=step_score_diff*0.5+step_score_same*0.5;
                else
                    step_score=0;
                end
                %上面那个if的意思是，如果已经做了某些steps的trials，那么就求出均值，如果没做过，那么这个trial的值先记为0.
                this_constant_score(step_type,2)=step_score;
            end
        end
        
        %以下：我们作图的话，其实最多可以做两个轴，那么需要输入x轴和y轴分别是上面数据，就OK了
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
    
        half_threshold=this_constant_score; %这个【【【【【【【【【【20190109】】】】】】】】】】】】
        
        onlineplot(handles,inputstruct);
        %作图
    elseif measure_type(1)==2
        %阶梯法
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
        %上下这两个if，是一种处理策略，因为如果这个direction上面还没有数据，作图程序会报错
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
    %下面就是著名的写备份记录的代码了
    fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\n',num2str(datestr(now)),num2str(trialcount),num2str(direction),num2str(currentstep(direction)),num2str(currentjudge(direction)),num2str(rt));
    
    
function JudgeNextStep(handles,SCnextstepchange)
    
    %这个函数有什么用呢？简而言之就是决定下一个trial要播放什么的函数。
    % type=1,恒定刺激法; type=2,one-down-one-up自适应法
    %（adaptive_para只在type=2时需要填，在目前只包含direction一个参数)
    global gbstepsize currentstep param measure_type trialcount stimsteplength randomorder fid is_break_keyproc interact_type stimfile stepsize stepcode direction counttingruns lastmeanvalue
    
    
    if measure_type(1)==1 
        disp(trialcount);
        %恒定刺激法
        if trialcount<=size(randomorder,2)-1
            %只要当前的trialcount不大于randomorder的大小减去1
            currentstep=randomorder(trialcount+1);
            %那么下一个step就是randomorder的第trialcount+1个数字
        else
            %如果已经大于randomorder-1，那么就终止实验吧
            set(handles.playbutton,'enable','off');
            is_break_keyproc=1;%如果是按键盘的话，直接就看这个，读到这个变量为1，上面提到的实验流程for循环就会自己break出来。
            if interact_type(1)==1
                %如果是点屏幕按钮，那么直接从这里保存数据，退出实验。
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
        %这是这个trial做完后的分组情况。
        
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
        
        %自适应函数，根据被试在direct方向中这一步的判断来决定下一步
        if no_runs == cuttingruns{direction}(1)+1 || no_runs == cuttingruns{direction}(2)+1 || no_runs == cuttingruns{direction}(3)+1
            disp('watch out')
            disp(lastmeanvalue(direction))
            % [20190610很可能是这个出了问题，明天回来修改哈。]
            currentstep(direction)=round(lastmeanvalue(direction));
        else
            if SCnextstepchange==1 %刺激往音节2移动一步
    %             disp(currentstep(direction));
    %             disp(stimsteplength-1);
                if currentstep(direction)<=stimsteplength-stepsize(direction)
                    currentstep(direction)=currentstep(direction)+stepsize(direction);
    %                 disp(currentstep(direction));
                end
            elseif SCnextstepchange==0 %刺激往音节1移动一步
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
        %恒定刺激法
        SCnextstepchange=[];
    elseif measure_type(1)==2
        %阶梯法
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
                    %等于跳出条件（如“+”），直接完成一个run，可以开展skip，重设judgegroup
                    SCnextstepchange=skip_nextchange; 
                    if trialcount > 2
                        SC_showingupdowngroup(skip_grouptype,handles);
                    end
                    judgegroup{direction}=3;
                elseif this_run < length(judgegroup{direction})
                    %disp(['Run:',num2str(this_run),'; Condition: not met, go on recursive;']);
                    %没有完成run，这个数码不是judgegroup最后一个数码，继续递归
                    SCnextstepchange=SCnextstepjudge(max_run_size,this_run+1,handles);
                elseif this_run == length(judgegroup{direction})
                    %disp(['Run:',num2str(this_run),'; Condition: not met, got group final, no change level;']);
                    %没有完成run，这个数目已经是judgegroup最后一个数码，输出为空，不开展skip
                    SCnextstepchange=[];
                elseif this_run > length(judgegroup{direction})
                    %神秘的大于，正常情况下不会发生。一旦发生了，弥补的措施是不开展skip，重设judgegroup为3加超出的部分
                    %理论上，这时候上一个出bug的run不会被算作一个run
                    disp('BUGGGGG!!!');
                    SCnextstepchange=[];
                    judgegroup{direction}(1:5)=[];
                    judgegroup{direction}=[3,judgegroup{direction}];
                end
            elseif this_run == (max_run_size + 1)
                %disp(['Run:',num2str(this_run),'; Condition: reached the end of the group;']);
                    %已经到达最大的size
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
        % counttingruns有四列，分别是stepsize，这个run是up(1)还是down(2)run，这个run的均值，这个step的编码
        
function countting_before_end(up_or_down,handles)
    global stepcode direction staircase_stoprunstage staircase_stoprunchange staircase_stopruns_list fclose staircase_stopruns_changenum staircase_stop_here

    %如果下面这一行报错，什么超出矩阵维度的，那肯定是被试第一个就做错了，重新做就可以了。别花时间改程序了。
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
        %既然结束了，就关掉这些按钮
        set(handles.playbutton,'enable','off');
        set(handles.screen_Syllable1,'enable','off');
        set(handles.screen_Syllable2,'enable','off');
        try
        close(fclose); %关掉弹出窗口
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
    %作图：
    if measure_type(1)==2 %阶梯法
        subplot(2,3,[1 4])
    end
    
    if staircase_id_dis==1 || 2
        if length(x_axis1)<10
            plot(zeros(1,length(ses2_SNR_list)),'linewidth',0.0001, 'color','k');
            %是这个的问题。
        else
            plot(zeros(1,length(x_axis1)),'linewidth',0.0001, 'color','k');
        end
    elseif staircase_id_dis==3
    %     if length(x_axis1)<10
    %         plot(zeros(1,length(ses2_SNR_list)),'linewidth',0.0001, 'color','k');
    %         %是这个的问题。
    %     else
            plot(zeros(1,length(x_axis1)),'linewidth',0.0001, 'color','k');
    %     end
    end
        
    if measure_type(1)==1 %恒定刺激法
        xlabel('step');
        if staircase_id_dis == 2
            ylabel('判断百分率');
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
    elseif measure_type(1)==2 %阶梯法
        ylim([0 size(stimfile,2)+1]);
        xlabel('试次(trials)');
        ylabel('自适应曲线');
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
        ylabel('自适应曲线');
        title('从音节1开始的曲线');
        
        subplot(2,3,[5 6])
        
        SC_plottingupdowngroup(2);
        hold on
        plot(1:length(y_axis2),y_axis2,'k');

        plot_staircase(scatter_points_positive_2,scatter_points_negative_2);
        hold off
        xlim([0 length(y_axis2)+1]);
        ylim([0 size(stimfile,2)+1]);
        xlabel('trials');
        ylabel('自适应曲线');
        title('从音节2开始的曲线'); 
        
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
    %这是一个弹出窗口，要主试再三思而后行（保证不被误按）
    uicontrol('Style','text','String','想好了要关了吗=。=？','Position',[0,-25,200,100]);
    uicontrol('Style','pushbutton','String','是的我要关了','Position',[0,0,100,50],'Callback',{@yes_close_step,handles});
    uicontrol('Style','pushbutton','String','不我还想等等','Position',[100,0,100,50],'Callback',{@no_close_step});

function yes_close_step(~,~,handles)
    %这是被试要清除数据的按钮触发的函数
    global fclose 
    endTest(handles); %结束这个测试
    %既然结束了，就关掉这些按钮吧
    set(handles.playbutton,'enable','off');
    set(handles.screen_Syllable1,'enable','off');
    set(handles.screen_Syllable2,'enable','off');
    close(fclose); %关掉弹出窗口
    
function no_close_step(~,~)
    %这是主试最后选择不清除数据的按钮触发的函数
    global fclose
    close(fclose);
