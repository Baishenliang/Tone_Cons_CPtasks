function bsliang_constSNR(subj,name,task,SNRs,steptags)
%% 恒定刺激法测量个体化SNR
% 输入：
% subj: 被试编号
% name: 被试姓名（仅用于保存log txt文件）
% task: 1-声调任务，2-声母任务
% SNRs: SNR等级，默认[2 0 -2 -4 -6],我后来加了个-8

%% 设定实验参数

NOtrials_SNR=22; % 每个SNR block有多少个trials（2的倍数，保证两个音数量一致）
ISI_lst=0.4:0.01:0.6; % inter trial interval,与正式ID实验是一样的
Fs=44100; % 播放声音采样率

SNRsteps=1:length(SNRs);

%% 加载被试专属声音文件
% 由于range过大的被试直接就不要了，而且logistic拟合可以解决range大于ADJUST最大值但是小于自然语音的情况，就更不需要再校正了
% isadaptedrange=input('生成的range是否经过了校正？ 1-是，0-否：');
% if isadaptedrange
%     range_load=input('请输入被试个体化声音文件路径，如subj_par_EXPdata:','s');
% else
%     range_load=['ind_stimmat',filesep,num2str(subj),'_par_EXPdata'];
% end
range_load=['ind_stimmat',filesep,num2str(subj),'_par_EXPdata'];
uiwait(msgbox(['请确认被试的声音文件：',range_load]));
load(range_load);

%% 读取声音文件
if isequal(steptags,'step24')
    % % 实验选取step2和step4（也就是75%的识别率）的是di1-di2，di1-ti1两个维度，非判断维度为清晰

    di12_stepA=par_EXPdata.T_old_BEHAV{1,2};
    di12_stepB=par_EXPdata.T_old_BEHAV{1,4};
    dti1_stepA=par_EXPdata.P_old_BEHAV{1,2};
    dti1_stepB=par_EXPdata.P_old_BEHAV{1,4};
    
elseif isequal(steptags,'step15')

    % 实验选取step1和step5（也就是100%的识别率）的是di1-di2，di1-ti1两个维度，非判断维度为清晰

    di12_stepA=par_EXPdata.T_old_BEHAV{1,1};
    di12_stepB=par_EXPdata.T_old_BEHAV{1,5};
    dti1_stepA=par_EXPdata.P_old_BEHAV{1,1};
    dti1_stepB=par_EXPdata.P_old_BEHAV{1,5};
end

if task==1 % 声调判断
    % 声调判断
    taskTag='TONE';
    sounds={di12_stepA,di12_stepB};
    soundTags={'di1','di2'};
    if mod(subj,2)==0
        % 偶数（不反过来）
        uiwait(msgbox('声调判断，<一声，>二声'));
    elseif  mod(subj,2)==1
        % 奇数（反过来）
        uiwait(msgbox('声调判断，<二声，>一声'));
    end
elseif task==2 % 声母判断
    % 声母判断
    taskTag='PHON';
    sounds={dti1_stepA,dti1_stepB};
    soundTags={'di1','ti1'};
    if mod(subj,2)==0
        % 偶数（不反过来）
        uiwait(msgbox('声母判断，<d，>t'));
    elseif  mod(subj,2)==1
        % 奇数（反过来）
        uiwait(msgbox('声母判断，<t，>d'));
    end
    
end

%% 加载噪声文件并调整
% 由于实际测得P_m4dB_SSN和T_m4dB_SSN的rms是一样的，这里仅读取T_m4dB_SSN
[noise,~]=audioread(['input',filesep,'T_m4dB_SSN.wav']);
noises=cell(1,length(SNRs));
SNRs_chk=nan(1,length(SNRs));
for SNRstep=SNRsteps
    noises{1,SNRstep}=bsliang_adjustnoiseSNR(di12_stepA,noise,SNRs(SNRstep));
    SNRs_chk(1,SNRstep)=10*log10((rms(di12_stepA)/rms(noises{1,SNRstep}))^2);
end

%% 定义反应键
[~,~,allinfos]=GetKeyboardIndices;
for i=1:size(allinfos,2)
    %if (strcmp(allinfos{1,i}.product,'slave keyboard'))
    par_keyboard=allinfos{1,i}.index;
    %end
end
PsychDefaultSetup(2);
if mod(subj,2)==0
    % 偶数（不反过来）
    lKey = KbName(',<');
    rKey = KbName('.>'); 
elseif  mod(subj,2)==1
    % 奇数（反过来）
    rKey = KbName(',<');
    lKey = KbName('.>'); 
end
        


%% 设定trials序列
SNRtrials=sort(repmat(SNRsteps,1,NOtrials_SNR));
SIGNALtrials=repmat([ones(1,NOtrials_SNR/2),2*ones(1,NOtrials_SNR/2)],1,length(SNRsteps));
TRIALS_raw=[SNRtrials;SIGNALtrials;zeros(2,length(SNRtrials))];
TRIALS=TRIALS_raw(:,randperm(size(TRIALS_raw,2)));
% 20210313：
TRIALsounds=cell(1,length(SNRtrials));

%% 实验blocks
fid = fopen(['.',filesep,'results',filesep,'No_',num2str(subj),'_',name,'_constSNR_log.txt'],'a');
fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\n','TIME','BLOCK','SNR','SIGNAL','SIGNAL_STEP','RESP','RT');

%% 初始化声音
load soundint_k %声强文件

InitializePsychSound;
deviceID=setDeviceID('subject');
param = PsychPortAudio('Open',deviceID,1+8,2,Fs,2);% 主设备（这些参数就这么用OK）

for trial=1:size(TRIALS,2)
    SNR_ind=TRIALS(1,trial);
    SIGNAL_ind=TRIALS(2,trial);
    TRIALsounds{1,trial}=PsychPortAudio('OpenSlave',param,1,2);
    TRIALsound=bsliang_appendBGnoise(sounds{1,SIGNAL_ind},noises{1,SNR_ind},Fs);
    PsychPortAudio('FillBuffer',TRIALsounds{1,trial},[adjust_k(1)*TRIALsound';adjust_k(2)*TRIALsound']);
end

%% 实验环节    
PsychPortAudio('Start',param,0,0);

for trial=1:size(TRIALS,2)
    SNR_ind=TRIALS(1,trial);
    SIGNAL_ind=TRIALS(2,trial);
    
    % play sound
    PsychPortAudio('Start',TRIALsounds{1,trial},1,0);
    tStart = GetSecs;
    while 1
        %这是一个while，在声音开始播放之后马上开始检测键盘，直到被试按了指定的键，跳出循环，这个while结束。
        [~,~,keyCode] = KbCheck(par_keyboard);
        timer = GetSecs-tStart; %这是开始算反应限时
        if keyCode(lKey)
            tEnd = GetSecs;
            rt = tEnd - tStart;
            resp = 1;
            break
        elseif keyCode(rKey)
            tEnd = GetSecs;
            rt = tEnd - tStart;
            resp = 2;
            break
        elseif timer>(5-0.369)
            tEnd = GetSecs;
            rt = tEnd - tStart;
            resp = 0;
            %被试没有反应，直接跳过
            break
        end
    end
    PsychPortAudio('Stop',TRIALsounds{1,trial});

    % 结果记录
    TRIALS(3,trial)=resp;
    TRIALS(4,trial)=rt;
    fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\n',num2str(datestr(now)),taskTag,num2str(SNRs(SNR_ind)),soundTags{SIGNAL_ind},num2str(SIGNAL_ind),num2str(resp),num2str(rt));
    disp([taskTag,' TRIAL ',num2str(trial),' SNR ',num2str(SNRs(SNR_ind)),' SIGNAL ',soundTags{SIGNAL_ind}]);

    WaitSecs(ISI_lst(randi(length(ISI_lst),1,1))); 
    % 新版的等待是这样的：400~600ms，以10ms为一个step，随机选。
    % ISI_lst是在程序一开始就定义了的。
    % 与Identification正式实验是一样的
    % stop noise
end

PsychPortAudio('Stop',param);
PsychPortAudio('Close',param);
save(['.',filesep,'results',filesep,'No_',num2str(subj),'_constSNR_',taskTag],'TRIALS');
save(['.',filesep,'results',filesep,'No_',num2str(subj),'_constSNR_',taskTag,'_SNRs'],'SNRs');

fclose(fid);