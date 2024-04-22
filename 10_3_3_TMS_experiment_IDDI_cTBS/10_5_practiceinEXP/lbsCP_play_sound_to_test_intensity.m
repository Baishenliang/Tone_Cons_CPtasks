% ���е���ǿ������HD650���Ҷ�Ϊ׼��60dB����Ĳ�һ�µĳ���һ��ϵ����

%load('ba1_pa1.mat');
 %load('ba1_ba2.mat');
 % load('ba2_pa2.mat');
%load('pa1_pa2.mat');

%adjust_k=[0.8748,1]; %HD650
%adjust_k=[0.5323,0.5323]; %�Ե����

%������kΪ1���һ����ǿֵXdB
%Ȼ����ݹ�ʽ k=sqrt(10^(60/10)/10^(X/10))���adjust_k���������adjust_k�ٲ�һ����ǿ����60��OK��
%dsjust_k��ֵ����С��1���������1��Ӳ��������Ҫ����

% 2020��10��12�գ�Ҫ��65dB��k=sqrt(10^(65/10)/10^(X/10))

adjust_k=[[0.5*0.5957*1.1220 0.5*0.5957*1.1220]]; 

%save diti_adjust_soundint_k adjust_k
save('soundint_k','adjust_k');
fs=44100;
%=========P_old_BEHAV
load('input\diti_defrange_par_EXPdata.mat');
stim_continuum=par_EXPdata.P_old_BEHAV(1,:);
% 
%=========== %P_old_BEHAV
% load('P_old_noise_BEHAV.mat');
% stim_continuum=stim_continuum(1,:);

%===========T_old_BEHAV
% load('di1_di2.mat');
% stim_continuum=stim_continuum(1,:);

%==============T_old_noise_BEHAV
% load('T_old_noise_BEHAV.mat');
% stim_continuum=stim_continuum(1,:);

%============EEGprogram/EEG_old_stim
% load('EEG_old_stim.mat');
% load('EEG_old_stim_noise.mat');
% EEG_old_stim=EEG_old_stim_noise;
% stim_continuum=cell(1,7);
% 
% stim_continuum{1}=EEG_old_stim.P3T3;
% stim_continuum{2}=EEG_old_stim.P1T3;
% stim_continuum{3}=EEG_old_stim.P5T3;
% stim_continuum{4}=EEG_old_stim.P3T1;
% stim_continuum{5}=EEG_old_stim.P3T5;
% stim_continuum{6}=EEG_old_stim.P1T1;
% stim_continuum{7}=EEG_old_stim.P5T5;

%����ǿ�ȶ�ʱ�������ĸ��ļ������ԣ�ȷ��ÿ������������ǿ��һ�µ�

InitializePsychSound;
deviceID=setDeviceID('subject');
param = PsychPortAudio('Open',deviceID,1+8,2,fs,2);          % ���豸����Щ��������ô��OK��
soundBuffer=cell(1,size(stim_continuum,2)+1); %���Ǵ��滺���˵������ļ���buffer
PsychPortAudio('Start',param,0,0);

% ��һ������slaveID���ڶ�������buffer
for soundID=1:size(stim_continuum,2)
   soundBuffer{1,soundID}=PsychPortAudio('OpenSlave',param,1,2);
   sound_temp=stim_continuum{1,soundID};
   PsychPortAudio('FillBuffer',soundBuffer{1,soundID}, [adjust_k(1)*bsliang_add_envelope(sound_temp(end-9000:end-6000),fs,0.01);adjust_k(2)*bsliang_add_envelope(sound_temp(end-9000:end-6000),fs,0.01)]);
   %PsychPortAudio('FillBuffer',soundBuffer{1,soundID}, [adjust_k*sound_temp';sound_temp']);
end

%����������

addnoise=0; %�Ƿ����������

[noise_bg,fs_noise_bg]=audioread('input\diti_defrange_bsliang_continune_SSN_YD.wav');
soundBuffer{1,end}=PsychPortAudio('OpenSlave',param,1,2);
PsychPortAudio('FillBuffer',soundBuffer{1,end}, [adjust_k(1)*noise_bg';adjust_k(2)*noise_bg']);

if addnoise==1
PsychPortAudio('Start',soundBuffer{1,end},0,0); %[20190416,�ظ����ű�������]
end

%while 1
for repeat_count=1:2
        %===================
        %����SNR���ɲ������򣬲�����һЩ��������һ��ˮƽ���޷����������
        stim_shuffle=Shuffle(1:size(stim_continuum,2)); %��������
        %stim_shuffle=1:size(stim_continuum,2); %�ر�����
        %===================
    for stim_code=1:size(stim_continuum,2)
            %ÿ���̼��ظ���Σ�ȷ�����ÿ���̼�����ǿ
            PsychPortAudio('Start',soundBuffer{1,stim_shuffle(stim_code)},1,0);
            pause(3000/fs);
            %pause(0.38);
            PsychPortAudio('Stop',soundBuffer{1,stim_shuffle(stim_code)});
    end
end
%end

if addnoise==1
    PsychPortAudio('Stop',soundBuffer{1,end});%[20190416,�������ű�������]
end

% ����ǿ����ʱ������ֱ��ctrl+cǿ���˳����ţ�Ȼ�������������д���ر�PA
PsychPortAudio('Stop',param)
PsychPortAudio('Close',param)