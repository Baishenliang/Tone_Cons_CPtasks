function lbsCP2_initialize_EXP(par_info,par_code)
    % initialize a subject
    % par_info: a struct, including participant's name, gender, and any
    %            other personal information
    % par_code: a double, to mark this participant;
    % w_subj_cond: a cell, to indicate names of within subject conditions
    % w_subj_cond_para: a struct, including parameters of every within_subj
    %           condition
    % b_subj_cond_para: a struct,  including parameters of every between_subj
    %           condition

    % === EXAMPLE ===

%     par_info.name='Practice';
%     par_info.gen=2;
%     par_info.age=24;
%     par_code=1;
%     

%【如果是正式实验的话，这里还需要加上def_range的一系列定义】

% ============The followings are parameters constant for a whole session,
%% =============Kept unchanged for across each participant
    NOsnrsteps=1;
    noise_filename_def_range='input\diti_defrange_bsliang_continune_SSN_YD.wav';

    steps5_Di_stimcluster = [13,31,11,33; %每一行的标记归为一个条件
                            24,42,22,44;
                            35,53,33,55];
    steps5_Di_xaxis = {[],'1-3','2-4','3-5',[]};
    
%% session 1: define range(9steps identification)
    def_range.soundk=repmat({'soundint_k.mat','soundint_k.mat'},1,NOsnrsteps);

    def_range.w_subj_cond=repmat({'T_old_BEHAV','P_old_BEHAV'},1,NOsnrsteps);
    
    def_range.ses2_cond=cell(1,NOsnrsteps*2);
    def_range.noise_filename=cell(1,NOsnrsteps*2);
    def_range.ses2_cond{1,1}='T_CLEAR_ID';
    def_range.ses2_cond{1,2}='P_CLEAR_ID';
    def_range.noise_filename{1,1}=noise_filename_def_range;
    def_range.noise_filename{1,2}=noise_filename_def_range;
    
    def_range.filename=repmat({{'T_old_BEHAV';'tone_old'},{'P_old_BEHAV';'phon_old'}},1,NOsnrsteps);
                        
    def_range.Di_stimcluster=repmat({steps5_Di_stimcluster,steps5_Di_stimcluster},1,NOsnrsteps);
    def_range.Di_xaxis=repmat({steps5_Di_xaxis,steps5_Di_xaxis},1,NOsnrsteps);
    
    def_range.w_subj_stimsource=repmat({'input/diti_defrange_par_EXPdata.mat','input/diti_defrange_par_EXPdata.mat';...
        'input/diti_defrange_xs_perc_struct.mat','input/diti_defrange_xs_perc_struct.mat'},1,NOsnrsteps);

    def_range.stimsourcetype='_avg_';                
        
    def_range.w_cond_order=[1 2];
    %def_range.w_cond_order=1:NOsnrsteps*2;
    
    def_range.Zjudge_text=repmat({'/一声/','/d_/'},1,NOsnrsteps);
    
    def_range.Mjudge_text=repmat({'/二声/','/t_/'},1,NOsnrsteps);
    
    def_range.addnoise=[0,0];  

    def_range.measure_type=1*ones(1,NOsnrsteps*2); % 1=Constant; 2=Staircase;
    def_range.interact_type=2*ones(1,NOsnrsteps*2); % 1=Button; 2=Keyboard;
    def_range.staircase_id_dis=2*ones(1,NOsnrsteps*2); % 1=Staircase; 2=Identification; 3=Discrimination
    
    def_range.staircase_stoprunstage=3*ones(1,NOsnrsteps*2);
    def_range.staircase_stoprunchange=4*ones(1,NOsnrsteps*2);
    
    def_range.const_reptimes=1*ones(1,NOsnrsteps*2);
    
%% session 2: practice(5steps identification + discrimination)

    ind_par_EXPdata_log=['ind_stimmat/',num2str(par_code),'_par_EXPdata.mat'];
    ind_xs_perc_struct_log=['ind_stimmat/',num2str(par_code),'_xs_perc_struct.mat'];

    practice.soundk=repmat({'soundint_k.mat','soundint_k.mat','soundint_k.mat','soundint_k.mat'},1,NOsnrsteps);

    practice.w_subj_cond=repmat({'T_old_BEHAV','P_old_BEHAV','T_old_BEDIS','P_old_BEDIS'},1,NOsnrsteps);
    
    practice.ses2_cond=cell(1,NOsnrsteps*4);
    practice.noise_filename=cell(1,NOsnrsteps*4);
    practice.ses2_cond{1,1}='T_CLEAR_ID';
    practice.ses2_cond{1,2}='P_CLEAR_ID';
    practice.ses2_cond{1,3}='T_CLEAR_DI';
    practice.ses2_cond{1,4}='P_CLEAR_DI';
    practice.noise_filename{1,1}=noise_filename_def_range;
    practice.noise_filename{1,2}=noise_filename_def_range;
    practice.noise_filename{1,3}=noise_filename_def_range;
    practice.noise_filename{1,4}=noise_filename_def_range;
    
    practice.filename=repmat({{'T_old_BEHAV';'tone_old'},{'P_old_BEHAV';'phon_old'},{'T_old_BEDIS';'tone_old'},{'P_old_BEDIS';'phon_old'}},1,NOsnrsteps);
                        
    practice.Di_stimcluster=repmat({steps5_Di_stimcluster,steps5_Di_stimcluster,steps5_Di_stimcluster,steps5_Di_stimcluster},1,NOsnrsteps);
    practice.Di_xaxis=repmat({steps5_Di_xaxis,steps5_Di_xaxis,steps5_Di_xaxis,steps5_Di_xaxis},1,NOsnrsteps);
    
    practice.w_subj_stimsource=repmat({ind_par_EXPdata_log;ind_xs_perc_struct_log},1,NOsnrsteps*4);

    practice.stimsourcetype='_avg_';                
        
    practice.w_cond_order=[1 2 3 4];
    %practice.w_cond_order=1:NOsnrsteps*2;
    
    practice.Zjudge_text=repmat({'/一声/','/d_/','/一声/','/d_/'},1,NOsnrsteps);
    
    practice.Mjudge_text=repmat({'/二声/','/t_/','/二声/','/t_/'},1,NOsnrsteps);
    
    practice.addnoise=[0,0,0,0];  

    practice.measure_type=1*ones(1,NOsnrsteps*4); % 1=Constant; 2=Staircase;
    practice.interact_type=2*ones(1,NOsnrsteps*4); % 1=Button; 2=Keyboard;
    practice.staircase_id_dis=[2*ones(1,NOsnrsteps*2),3*ones(1,NOsnrsteps*2)]; % 1=Staircase; 2=Identification; 3=Discrimination
    
    practice.staircase_stoprunstage=3*ones(1,NOsnrsteps*4);
    practice.staircase_stoprunchange=4*ones(1,NOsnrsteps*4);
    
    practice.const_reptimes=[2,2,2,2];
    
    
%% session3: identification_discrimination

    % 以前的顺序，统一一下：TC PC TN PN
    
    % 20201020:实际上这个程序现在只用来做练习，所以不用加noise，且identification的block少掉一半（可对比正式实验的设置）

    ind_par_EXPdata_log_d=['ind_stimmat/',num2str(par_code),'_par_EXPdata.mat'];
    ind_xs_perc_struct_log_d=['ind_stimmat/',num2str(par_code),'_xs_perc_struct.mat'];

    Id_Di.soundk=repmat({'soundint_k.mat','soundint_k.mat','soundint_k.mat','soundint_k.mat'},1,NOsnrsteps);

    Id_Di.w_subj_cond=repmat({'T_old_BEHAV','P_old_BEHAV','T_old_BEDIS','P_old_BEDIS'},1,NOsnrsteps);
    
    Id_Di.ses2_cond=cell(1,NOsnrsteps*4);
    Id_Di.noise_filename=cell(1,NOsnrsteps*4);
    Id_Di.ses2_cond{1,1}='T_CLEAR_ID';
    Id_Di.ses2_cond{1,2}='P_CLEAR_ID';
    Id_Di.ses2_cond{1,3}='T_CLEAR_DI';
    Id_Di.ses2_cond{1,4}='P_CLEAR_DI';
    
    Id_Di.noise_filename(1,1:4)=repmat({'input\T_m4dB_SSN.wav','input\P_m4dB_SSN.wav'},1,2);
        
    Id_Di.filename=repmat({{'T_old_BEHAV';'tone_old'},{'P_old_BEHAV';'phon_old'},{'T_old_BEDIS';'tone_old'},{'P_old_BEDIS';'phon_old'}},1,NOsnrsteps);
                        
    Id_Di.Di_stimcluster=repmat({steps5_Di_stimcluster,steps5_Di_stimcluster,steps5_Di_stimcluster,steps5_Di_stimcluster},1,NOsnrsteps);
    Id_Di.Di_xaxis=repmat({steps5_Di_xaxis,steps5_Di_xaxis,steps5_Di_xaxis,steps5_Di_xaxis},1,NOsnrsteps);
    
    Id_Di.w_subj_stimsource=repmat({ind_par_EXPdata_log_d;ind_xs_perc_struct_log_d},1,NOsnrsteps*4);

    Id_Di.stimsourcetype='_avg_';                
        
    Id_Di.w_cond_order=[1 2 3 4]; 
    %Id_Di.w_cond_order=1:NOsnrsteps*2;
    
    Id_Di.Zjudge_text=repmat({'/一声/','/b_/','/一声/','/b_/'},1,NOsnrsteps);
    
    Id_Di.Mjudge_text=repmat({'/二声/','/p_/','/二声/','/p_/'},1,NOsnrsteps);
    
    Id_Di.addnoise=[0,0,0,0];  

    Id_Di.measure_type=1*ones(1,NOsnrsteps*4); % 1=Constant; 2=Staircase;
    Id_Di.interact_type=2*ones(1,NOsnrsteps*4); % 1=Button; 2=Keyboard;
    Id_Di.staircase_id_dis=[2*ones(1,NOsnrsteps*2),3*ones(1,NOsnrsteps*2)]; % 1=Staircase; 2=Identification; 3=Discrimination
    
    Id_Di.staircase_stoprunstage=3*ones(1,NOsnrsteps*4);
    Id_Di.staircase_stoprunchange=4*ones(1,NOsnrsteps*4);
    
    Id_Di.const_reptimes=[1 1 1 1];

    %=================================================================     
    DATA=lbsCP2_loadDATA();
    DATA(par_code).par_info=par_info;
    DATA(par_code).def_range=def_range;
    DATA(par_code).practice=practice;
    DATA(par_code).Id_Di=Id_Di;
    disp(['==== Successfully initialize participant No.',num2str(par_code)]);
    lbsCP2_saveDATA(DATA)
    