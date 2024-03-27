function bsliang_noiseSNR_Main()
load('SNRlst.mat');
load('diti_defrange_par_EXPdata.mat');

T_old_BEHAV=par_EXPdata.T_old_BEHAV;
P_old_BEHAV=par_EXPdata.P_old_BEHAV;
T_old_BEDIS=par_EXPdata.T_old_BEDIS;
P_old_BEDIS=par_EXPdata.P_old_BEDIS;

EEG_old_stim=par_EXPdata.EEG_old_stim;
clear par_EXPdata;

rmsc_T=zeros(1,size(T_old_BEHAV,2));
rmsc_P=zeros(1,size(P_old_BEHAV,2));

for r=1:size(T_old_BEHAV,2)
    rmsc_T(1,r)=rms(T_old_BEHAV{1,r});
    rmsc_P(1,r)=rms(P_old_BEHAV{1,r});
end

rmsc_T
rmsc_P

disp('请检查RMS，如果都相等，按任意键开始合成噪音');
pause();

[noisemask_raw,fs]=audioread('diti_defrange_bsliang_continune_SSN_YD.wav');
noisemask_raw=0.999*noisemask_raw/max(abs(noisemask_raw));
RMS_noise=rms(noisemask_raw);

k_T=bsliang_noiseSNR(rmsc_T(1),RMS_noise,SNRlst,noisemask_raw,fs,'T');
k_P=bsliang_noiseSNR(rmsc_P(1),RMS_noise,SNRlst,noisemask_raw,fs,'P');

k_T
k_P

disp('请检查两个声音文件修正系数是否相等，如果是，按任意键开始合成新刺激');
pause();

if (k_T<1) || (k_P<1)
    for rr=1:size(T_old_BEHAV,2)
        T_old_BEHAV{1,rr}=k_T*(T_old_BEHAV{1,rr});
        P_old_BEHAV{1,rr}=k_P*(P_old_BEHAV{1,rr});
    end
    for rr=1:size(T_old_BEDIS,2)
        T_old_BEDIS{1,rr}=k_T*(T_old_BEDIS{1,rr});
        P_old_BEDIS{1,rr}=k_P*(P_old_BEDIS{1,rr});
    end
    EEG_old_stim.P3T3=k_T*EEG_old_stim.P3T3;
    EEG_old_stim.P1T3=k_T*EEG_old_stim.P1T3;
    EEG_old_stim.P5T3=k_T*EEG_old_stim.P5T3;
    EEG_old_stim.P3T1=k_T*EEG_old_stim.P3T1;
    EEG_old_stim.P3T5=k_T*EEG_old_stim.P3T5;
    EEG_old_stim.P1T1=k_T*EEG_old_stim.P1T1;
    EEG_old_stim.P5T5=k_T*EEG_old_stim.P5T5;

    par_EXPdata.T_old_BEHAV=T_old_BEHAV;
    par_EXPdata.P_old_BEHAV=P_old_BEHAV;
    par_EXPdata.T_old_BEDIS=T_old_BEDIS;
    par_EXPdata.P_old_BEDIS=P_old_BEDIS; 
    
    par_EXPdata.EEG_old_stim=EEG_old_stim;
    save diti_defrange_par_EXPdata par_EXPdata
end

[T_m4dB,fs]=audioread('P_m4dB_SSN.wav');
[P_m4dB,~]=audioread('T_m4dB_SSN.wav');

rms(T_m4dB)
rms(P_m4dB)

disp('请检查两个噪声RMS是否一样，如果一样，按任意键开始合成噪声');
pause();

% audiowrite('bsliang_continune_SSN_YD.wav',T_m4dB,fs);
% delete('P_m4dB_SSN.wav');
% delete('T_m4dB_SSN.wav')






