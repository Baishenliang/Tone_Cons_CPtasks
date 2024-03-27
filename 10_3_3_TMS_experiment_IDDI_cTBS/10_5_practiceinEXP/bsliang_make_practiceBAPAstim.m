cd morph_stimuli

% 给出的为大家比较常见的range，难度跟diti相仿
xs_perc.tone_old=linspace(0.0384,0.6,5);
xs_perc.phon_old=linspace(0.0384,0.6,5);

startmorphingtic=tic;
[par_EXPdata,xs_perc_struct]=bsliang_fivesteps_Main(5,5,xs_perc); 

stopmorphingtoc=toc(startmorphingtic);
disp(['合成个体化矩阵消耗',num2str(stopmorphingtoc/60),'分钟']);

cd ../

%加载def_range调好声强的刺激矩阵
% cd(['..',filesep,'10_3_1_TMS_experiment_defrange_2019']);
load DATA; %这个到时候最好改成2020实验的DATA咯（去拷贝一个吧）
par_EXPdata_org=load(DATA(1).def_range.w_subj_stimsource{1,1});
[noisekk,~]=audioread(DATA(1).Id_Di.noise_filename{1,1});
% cd(['..',filesep,'10_5_practiceinEXP'])
T_old_BEHAV_org=par_EXPdata_org.par_EXPdata.T_old_BEHAV;
clear par_EXPdata_org

T_old_BEHAV=par_EXPdata.T_old_BEHAV;
P_old_BEHAV=par_EXPdata.P_old_BEHAV;
T_old_BEDIS=par_EXPdata.T_old_BEDIS;
P_old_BEDIS=par_EXPdata.P_old_BEDIS;

%计算校正系数
kk = rms(T_old_BEHAV_org{1,1})/rms(T_old_BEHAV{1,1});

for rr=1:size(T_old_BEHAV,2)
    T_old_BEHAV{1,rr}=kk*(T_old_BEHAV{1,rr});
    P_old_BEHAV{1,rr}=kk*(P_old_BEHAV{1,rr});
end
for rr=1:size(T_old_BEDIS,2)
    T_old_BEDIS{1,rr}=kk*(T_old_BEDIS{1,rr});
    P_old_BEDIS{1,rr}=kk*(P_old_BEDIS{1,rr});
end

clear par_EXPdata

par_EXPdata.T_old_BEHAV=T_old_BEHAV;
par_EXPdata.P_old_BEHAV=P_old_BEHAV;
par_EXPdata.T_old_BEDIS=T_old_BEDIS;
par_EXPdata.P_old_BEDIS=P_old_BEDIS; 

% 提取练习所需音节
cd(['morph_stimuli',filesep,'input']);
[raw_ba35,~]=audioread('ba35_repitch_rms_6khlp.wav');
[raw_ba55,~]=audioread('ba55_repitch_rms_6khlp.wav');
[raw_pa35,~]=audioread('pa35_repitch_rms_6khlp.wav');
[raw_pa55,~]=audioread('pa55_repitch_rms_6khlp.wav');
cd ..\..

kk2 = rms(T_old_BEHAV_org{1,1})/rms(raw_ba35);
raw_ba35=kk2*raw_ba35;
raw_ba55=kk2*raw_ba55;
raw_pa35=kk2*raw_pa35;
raw_pa55=kk2*raw_pa55;

stim_for_train = {raw_ba55,raw_ba35,raw_pa55,raw_pa35};
stim_for_train_Tag = {'bā','bá','pā','pá'};

cd input
save stim_for_train stim_for_train
save stim_for_train_Tag stim_for_train_Tag
cd ..

cd ind_stimmat
save 1_par_EXPdata par_EXPdata
save 1_xs_perc_struct xs_perc_struct
save 2_par_EXPdata par_EXPdata
save 2_xs_perc_struct xs_perc_struct
cd ..

% 保存DI_practice文件
for i=1:4
    for j=1:4
        sound=[stim_for_train{1,i};zeros(44100*0.5,1);stim_for_train{1,j}];
        audiowrite(['DI_practice/',stim_for_train_Tag{1,i},'_',stim_for_train_Tag{1,j},'.wav'],sound,44100);
    end
end

signalkk=par_EXPdata.T_old_BEHAV{1,1};
snrkk=10*log10((rms(signalkk)/rms(noisekk))^2);

msgbox(['Adjustment finished!  Intensity correction k = ',num2str(kk),', SNR = ',num2str(snrkk),'dB']);
clear DATA