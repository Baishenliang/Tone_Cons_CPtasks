% 所有的声强，均以HD650的右耳为准，60dB，别的不一致的乘上一个系数。

%load('ba1_pa1.mat');
 %load('ba1_ba2.mat');
 % load('ba2_pa2.mat');
%load('pa1_pa2.mat');

%adjust_k=[0.8748,1]; %HD650
%adjust_k=[0.5323,0.5323]; %脑电耳机

%首先以k为1测出一个声强值XdB
%然后根据公式 k=sqrt(10^(60/10)/10^(X/10))算出adjust_k，根据这个adjust_k再测一次声强，是60就OK了
%dsjust_k的值必须小于1，如果大于1，硬件音量需要调大。

% 2020年10月12日，要求65dB，k=sqrt(10^(65/10)/10^(X/10))

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

%测声强稳定时，可以四个文件都试试，确保每个声音它的声强是一致的

InitializePsychSound;
deviceID=setDeviceID('subject');
param = PsychPortAudio('Open',deviceID,1+8,2,fs,2);          % 主设备（这些参数就这么用OK）
soundBuffer=cell(1,size(stim_continuum,2)+1); %这是储存缓冲了的声音文件的buffer
PsychPortAudio('Start',param,0,0);

% 第一行输入slaveID，第二行输入buffer
for soundID=1:size(stim_continuum,2)
   soundBuffer{1,soundID}=PsychPortAudio('OpenSlave',param,1,2);
   sound_temp=stim_continuum{1,soundID};
   PsychPortAudio('FillBuffer',soundBuffer{1,soundID}, [adjust_k(1)*bsliang_add_envelope(sound_temp(end-9000:end-6000),fs,0.01);adjust_k(2)*bsliang_add_envelope(sound_temp(end-9000:end-6000),fs,0.01)]);
   %PsychPortAudio('FillBuffer',soundBuffer{1,soundID}, [adjust_k*sound_temp';sound_temp']);
end

%加入噪声：

addnoise=0; %是否加入噪声？

[noise_bg,fs_noise_bg]=audioread('input\diti_defrange_bsliang_continune_SSN_YD.wav');
soundBuffer{1,end}=PsychPortAudio('OpenSlave',param,1,2);
PsychPortAudio('FillBuffer',soundBuffer{1,end}, [adjust_k(1)*noise_bg';adjust_k(2)*noise_bg']);

if addnoise==1
PsychPortAudio('Start',soundBuffer{1,end},0,0); %[20190416,重复播放背景噪音]
end

%while 1
for repeat_count=1:2
        %===================
        %对于SNR，可采用乱序，并且慢一些，试试哪一个水平的无法听得清楚了
        stim_shuffle=Shuffle(1:size(stim_continuum,2)); %开启乱序
        %stim_shuffle=1:size(stim_continuum,2); %关闭乱序
        %===================
    for stim_code=1:size(stim_continuum,2)
            %每个刺激重复五次，确保测出每个刺激的声强
            PsychPortAudio('Start',soundBuffer{1,stim_shuffle(stim_code)},1,0);
            pause(3000/fs);
            %pause(0.38);
            PsychPortAudio('Stop',soundBuffer{1,stim_shuffle(stim_code)});
    end
end
%end

if addnoise==1
    PsychPortAudio('Stop',soundBuffer{1,end});%[20190416,结束播放背景噪音]
end

% 测声强结束时，可以直接ctrl+c强制退出播放，然后运行下面两行代码关闭PA
PsychPortAudio('Stop',param)
PsychPortAudio('Close',param)