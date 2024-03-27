function bsliang_adjust_ADJUSTresults()
%该函数用来校正第一次实验进行ADJUST后结果不太理想的；

% 注意xs_perc_struct里面pone_old是原始的range，tone_old是原始range的一般
T_start_perc=0.038364471017264;
P_start_perc=0.038461538461539;
T_stop_perc=0.961538461538462*2; % BSLiang 20201024,因为有些被试确实能分清自然一二声但是rang太大
P_stop_perc=0.961538461538462;

matrix_steps=5; %合成的连续体有多少个steps，一般是5个

% 第一次校正（20201024）：
%            P：95 116
%            T：98 115 116

% 去年做实验的被试迁移（20201024）：
% 3 5 6 9 10 14 17 23 33 44 45 47 50 55 56 58 59 61 63 66 70 75

%将这些被试的range开头变为step2
% for subj=[1 2 3 5 6 7 8 9 10 11 12 13 14 15]
%     cd ind_stimmat
%     
%     load([num2str(subj),'_xs_perc_struct.mat']);
%     tone_old=xs_perc_struct.xs_perc.tone_old;
%     phon_old=xs_perc_struct.xs_perc.phon_old;
%     xs_perc_struct.xs_perc.tone_old=linspace(T_start_perc,tone_old(end),matrix_steps);
%     xs_perc_struct.xs_perc.phon_old=linspace(P_start_perc,phon_old(end),matrix_steps);
%     save([num2str(subj),'_xs_perc_struct.mat'],'xs_perc_struct');
%     
%     cd ..\
%     cd morph_stimuli
%     [par_EXPdata,~]=bsliang_fivesteps_Main(matrix_steps,matrix_steps,xs_perc_struct.xs_perc); 
%     
%     cd ..\
%     par_EXPdata=noise_adjust(par_EXPdata,subj);
%     cd ind_stimmat
%     save([num2str(subj),'_par_EXPdata.mat'],'par_EXPdata');
%     cd ..\
% end

%增大phon range
for subj=[95 116]
    cd ind_stimmat
    
    load([num2str(subj),'_xs_perc_struct.mat']);
    
    % BSLiang 20201024 move original files to ind_stimmat_raw
    movefile([num2str(subj),'_xs_perc_struct.mat'],'..\ind_stimmat_raw');
    movefile([num2str(subj),'_par_EXPdata.mat'],'..\ind_stimmat_raw');
    
    phon_old=xs_perc_struct.xs_perc.phon_old;
    xs_perc_struct.xs_perc.phon_old=linspace(phon_old(1),P_stop_perc,matrix_steps);
    save([num2str(subj),'_xs_perc_struct.mat'],'xs_perc_struct');
    
    cd ..\
    cd morph_stimuli
    [par_EXPdata,~]=bsliang_fivesteps_Main(matrix_steps,matrix_steps,xs_perc_struct.xs_perc); 
    
    cd ..\
    par_EXPdata=noise_adjust(par_EXPdata,subj);
    cd ind_stimmat
    save([num2str(subj),'_par_EXPdata.mat'],'par_EXPdata');
    cd ..\
end

%增大tone range
for subj=[98 115 116];
    cd ind_stimmat
    
    load([num2str(subj),'_xs_perc_struct.mat']);
    
    % BSLiang 20201024 move original files to ind_stimmat_raw
    movefile([num2str(subj),'_xs_perc_struct.mat'],'..\ind_stimmat_raw');
    movefile([num2str(subj),'_par_EXPdata.mat'],'..\ind_stimmat_raw');
    
    tone_old=xs_perc_struct.xs_perc.tone_old;
    xs_perc_struct.xs_perc.tone_old=linspace(tone_old(1),T_stop_perc,matrix_steps);
    save([num2str(subj),'_xs_perc_struct.mat'],'xs_perc_struct');
    
    cd ..\
    cd morph_stimuli
    [par_EXPdata,~]=bsliang_fivesteps_Main(matrix_steps,matrix_steps,xs_perc_struct.xs_perc); 
    
    cd ..\
    par_EXPdata=noise_adjust(par_EXPdata,subj);
    cd ind_stimmat
    save([num2str(subj),'_par_EXPdata.mat'],'par_EXPdata');
    cd ..\
end

% load DATA
% dataold=load('..\10_3_2_TMS_experiment_IDDI_2019\DATA');
% dataold=dataold.DATA;
% for oldsubj = [3 5 6 9 10 14 17 23 33 44 45 47 50 55 56 58 59 61 63 66 70 75]
%     copyfile(['..\10_3_2_TMS_experiment_IDDI_2019\ind_stimmat\',num2str(oldsubj),'_xs_perc_struct.mat'],'ind_stimmat');
%     copyfile(['..\10_3_2_TMS_experiment_IDDI_2019\ind_stimmat\',num2str(oldsubj),'_par_EXPdata.mat'],'ind_stimmat');
%     DATA(oldsubj)=dataold(oldsubj);
% end
% save DATA

function par_EXPdata=noise_adjust(par_EXPdata,par_code_in)
        %加载def_range调好声强的刺激矩阵
        load DATA
        par_EXPdata_org=load(DATA(par_code_in).def_range.w_subj_stimsource{1,1});
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
    
        signalkk=par_EXPdata.T_old_BEHAV{1,1};
        [noisekk,~]=audioread(DATA(par_code_in).Id_Di.noise_filename{1,1});
        snrkk=10*log10((rms(signalkk)/rms(noisekk))^2);
        
        msgbox(['Adjustment finished!  Intensity correction k = ',num2str(kk),', SNR = ',num2str(snrkk),'dB']);
        clear DATA
