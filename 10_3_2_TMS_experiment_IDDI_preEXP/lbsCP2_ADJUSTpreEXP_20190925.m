function lbsCP2_ADJUSTpreEXP_20190925(par_code_in)

        lbsCP2_start_withinCOND(par_code_in,'_def_range_',1,1);
        lbsCP2_start_withinCOND(par_code_in,'_def_range_',2,1);
        
        DATA=lbsCP2_loadDATA();
        
        parT_IDcurve=DATA(par_code_in).def_range.data(1,1).half_threshold;
        parP_IDcurve=DATA(par_code_in).def_range.data(1,2).half_threshold;
        
        parT_IDcurve(:,2)=1-parT_IDcurve(:,2);
        parP_IDcurve(:,2)=1-parP_IDcurve(:,2);
        
        parT_raw=DATA(par_code_in).def_range.data(1,1).rawdata;
        parP_raw=DATA(par_code_in).def_range.data(1,2).rawdata;
        
        disp('================================================');
        disp('============ parT_IDcurve ======================');
        disp(['F0_perc = ',num2str(parT_IDcurve(:,1)')]);
        disp(['Resp = ',num2str(parT_IDcurve(:,2)')]);

        disp('============ parT_IDcurve ======================');
        disp(['VOT_perc = ',num2str(parP_IDcurve(:,1)')]);
        disp(['Resp = ',num2str(parP_IDcurve(:,2)')]);  
        disp('================================================');
                
%         tone_curends=bsliang_adjust_getcurvPerc(parT_IDcurve',5);
%         phon_curends=bsliang_adjust_getcurvPerc(parP_IDcurve',5);

        tone_curends=bsliang_adjust_getcurvPerc_LOGISTIC(parT_IDcurve',5,parT_raw,'TONE',par_code_in);
        phon_curends=bsliang_adjust_getcurvPerc_LOGISTIC(parP_IDcurve',5,parP_raw,'PHON',par_code_in);
        
        xs_perc_new.tone_old=tone_curends;
        xs_perc_new.phon_old=phon_curends;

        disp('============ Adjusted F0_perc ======================');
        disp(xs_perc_new.tone_old);
        disp('============ Adjusted VOT_perc ======================');
        disp(xs_perc_new.phon_old);
        %cd ../ 
        
        cd morph_stimuli
        
        startmorphingtic=tic;
        [par_EXPdata,xs_perc_struct]=bsliang_fivesteps_Main(5,5,xs_perc_new); 
        stopmorphingtoc=toc(startmorphingtic);
        disp(['合成个体化矩阵消耗',num2str(stopmorphingtoc/60),'分钟']);

        cd ../
                
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
        
        % 20210309新增：将连续体矩阵转化为连续体：
        uiwait(msgbox('请注意，以下操作会将连续体矩阵转换为连续体，第二维度变化取消。如要恢复连续体矩阵，请删除对应代码。'))
        par_EXPdata_new=bsliang_PTmatrix2PTcontin_Main(par_EXPdata);
        clear par_EXPdata
        par_EXPdata=par_EXPdata_new;
    
        save(['ind_stimmat\',num2str(par_code_in),'_par_EXPdata.mat'],'par_EXPdata');
        save(['ind_stimmat\',num2str(par_code_in),'_xs_perc_struct.mat'],'xs_perc_struct');

        signalkk=par_EXPdata.T_old_BEHAV{1,1};
        [noisekk,~]=audioread(DATA(par_code_in).Id_Di.noise_filename{1,1});
        snrkk=10*log10((rms(signalkk)/rms(noisekk))^2);
        
        msgbox(['Adjustment finished!  Intensity correction k = ',num2str(kk),', SNR = ',num2str(snrkk),'dB']);
        

        
        
