function bsliang_constSNR(subj,name,task,SNRs,steptags)
%% �㶨�̼����������廯SNR
% ���룺
% subj: ���Ա��
% name: ���������������ڱ���log txt�ļ���
% task: 1-��������2-��ĸ����
% SNRs: SNR�ȼ���Ĭ��[2 0 -2 -4 -6],�Һ������˸�-8

%% �趨ʵ�����

NOtrials_SNR=24; % ÿ��SNR block�ж��ٸ�trials��2�ı�������֤����������һ�£�
ISI_lst=0.4:0.01:0.6; % inter trial interval,����ʽIDʵ����һ����
Fs=44100; % ��������������

SNRsteps=1:length(SNRs);

%% ���ر���ר�������ļ�
isadaptedrange=input('���ɵ�range�Ƿ񾭹���У���� 1-�ǣ�0-��');
if isadaptedrange
    range_load=input('�����뱻�Ը��廯�����ļ�·������subj_par_EXPdata:','s');
else
    range_load=['ind_stimmat',filesep,num2str(subj),'_par_EXPdata'];
end
uiwait(msgbox(['��ȷ�ϱ��Ե������ļ���',range_load]));
load(range_load);

%% ��ȡ�����ļ�
if isequal(steptags,'step24')
    % % ʵ��ѡȡstep2��step4��Ҳ����75%��ʶ���ʣ�����di1-di2��di1-ti1����ά�ȣ����ж�ά��Ϊ����

    di12_stepA=par_EXPdata.T_old_BEHAV{1,2};
    di12_stepB=par_EXPdata.T_old_BEHAV{1,4};
    dti1_stepA=par_EXPdata.P_old_BEHAV{1,2};
    dti1_stepB=par_EXPdata.P_old_BEHAV{1,4};
    
elseif isequal(steptags,'step15')

    % ʵ��ѡȡstep1��step5��Ҳ����100%��ʶ���ʣ�����di1-di2��di1-ti1����ά�ȣ����ж�ά��Ϊ����

    di12_stepA=par_EXPdata.T_old_BEHAV{1,1};
    di12_stepB=par_EXPdata.T_old_BEHAV{1,5};
    dti1_stepA=par_EXPdata.P_old_BEHAV{1,1};
    dti1_stepB=par_EXPdata.P_old_BEHAV{1,5};
end

if task==1 % �����ж�
    % �����ж�
    taskTag='TONE';
    sounds={di12_stepA,di12_stepB};
    soundTags={'di1','di2'};
    uiwait(msgbox('�����жϣ�<һ����>����'));
elseif task==2 % ��ĸ�ж�
    % ��ĸ�ж�
    taskTag='PHON';
    sounds={dti1_stepA,dti1_stepB};
    soundTags={'di1','ti1'};
    uiwait(msgbox('��ĸ�жϣ�<d��>t'));
end

%% ���������ļ�������
% ����ʵ�ʲ��P_m4dB_SSN��T_m4dB_SSN��rms��һ���ģ��������ȡT_m4dB_SSN
[noise,~]=audioread(['input',filesep,'T_m4dB_SSN.wav']);
noises=cell(1,length(SNRs));
SNRs_chk=nan(1,length(SNRs));
for SNRstep=SNRsteps
    noises{1,SNRstep}=bsliang_adjustnoiseSNR(di12_stepA,noise,SNRs(SNRstep));
    SNRs_chk(1,SNRstep)=10*log10((rms(di12_stepA)/rms(noises{1,SNRstep}))^2);
end

%% ���巴Ӧ��
[~,~,allinfos]=GetKeyboardIndices;
for i=1:size(allinfos,2)
    %if (strcmp(allinfos{1,i}.product,'slave keyboard'))
    par_keyboard=allinfos{1,i}.index;
    %end
end
PsychDefaultSetup(2);
lKey = KbName(',<');
rKey = KbName('.>'); 

%% �趨trials����
SNRtrials=sort(repmat(SNRsteps,1,NOtrials_SNR));
SIGNALtrials=repmat([ones(1,NOtrials_SNR/2),2*ones(1,NOtrials_SNR/2)],1,length(SNRsteps));
TRIALS_raw=[SNRtrials;SIGNALtrials;zeros(2,length(SNRtrials))];
TRIALS=TRIALS_raw(:,randperm(size(TRIALS_raw,2)));

%% ʵ��blocks
fid = fopen(['.',filesep,'results',filesep,'No_',num2str(subj),'_',name,'_constSNR_log.txt'],'a');
fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\n','TIME','BLOCK','SNR','SIGNAL','SIGNAL_STEP','RESP','RT');

%% ��ʼ������
load soundint_k %��ǿ�ļ�

InitializePsychSound;
deviceID=setDeviceID('subject');
param = PsychPortAudio('Open',deviceID,1+8,2,Fs,2);% ���豸����Щ��������ô��OK��
soundBuffer=cell(1,2); %���Ǵ��滺���˵������ļ���buffer
noiseBuffer=cell(1,length(SNRs)); %���Ǵ��滺���˵������ļ���buffer

for soundID=1:2
   soundBuffer{1,soundID}=PsychPortAudio('OpenSlave',param,1,2);
   PsychPortAudio('FillBuffer',soundBuffer{1,soundID}, [adjust_k(1)*sounds{1,soundID}';adjust_k(2)*sounds{1,soundID}']);
end

for noiseID=1:length(SNRs)
   noiseBuffer{1,noiseID}=PsychPortAudio('OpenSlave',param,1,2);
   PsychPortAudio('FillBuffer',noiseBuffer{1,noiseID}, [adjust_k(1)*noises{1,noiseID}';adjust_k(2)*noises{1,noiseID}']);
end

%% ʵ�黷��    
PsychPortAudio('Start',param,0,0);

for trial=1:size(TRIALS,2)
    SNR_ind=TRIALS(1,trial);
    SIGNAL_ind=TRIALS(2,trial);

    % play noise
    PsychPortAudio('Start',noiseBuffer{1,SNR_ind},1,0);
    WaitSecs(0.3); % wait 0.3s for noise adaptation

    % play sound
    PsychPortAudio('Start',soundBuffer{1,SIGNAL_ind},1,0);
    tStart = GetSecs;
    while 1
        %����һ��while����������ʼ����֮�����Ͽ�ʼ�����̣�ֱ�����԰���ָ���ļ�������ѭ�������while������
        [~,~,keyCode] = KbCheck(par_keyboard);
        timer = GetSecs-tStart; %���ǿ�ʼ�㷴Ӧ��ʱ
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
            %����û�з�Ӧ��ֱ������
            break
        end
    end
    PsychPortAudio('Stop',soundBuffer{1,SIGNAL_ind});

    % �����¼
    TRIALS(3,trial)=resp;
    TRIALS(4,trial)=rt;
    fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\n',num2str(datestr(now)),taskTag,num2str(SNRs(SNR_ind)),soundTags{SIGNAL_ind},num2str(SIGNAL_ind),num2str(resp),num2str(rt));
    disp([taskTag,' TRIAL ',num2str(trial),' SNR ',num2str(SNRs(SNR_ind)),' SIGNAL ',soundTags{SIGNAL_ind}]);

    WaitSecs(ISI_lst(randi(length(ISI_lst),1,1))); 
    % �°�ĵȴ��������ģ�400~600ms����10msΪһ��step�����ѡ��
    % ISI_lst���ڳ���һ��ʼ�Ͷ����˵ġ�
    % ��Identification��ʽʵ����һ����
    % stop noise
    PsychPortAudio('Stop',noiseBuffer{1,SNR_ind});
end

PsychPortAudio('Stop',param);
PsychPortAudio('Close',param);
save(['.',filesep,'results',filesep,'No_',num2str(subj),'_constSNR_',taskTag],'TRIALS');
save(['.',filesep,'results',filesep,'No_',num2str(subj),'_constSNR_',taskTag,'_SNRs'],'SNRs');

fclose(fid);