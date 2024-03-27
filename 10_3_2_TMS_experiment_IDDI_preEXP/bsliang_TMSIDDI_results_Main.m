%[AREAS_2,SLOPES_2,Prof_Xu_Index_2,DATA_avg,index_mat_2]=bsliang_TMSIDDI_results(SUBJ_lst,fitmode,fit_function,ORDER_RESULT,select_in_dispord,select_in_storord);

%fitmode: '_slopecurve_'(calculate the slope curve),'_IDcurve_'(calculate the ID curve)
%fit_function: '_pku_'(PKU least squares method) '_YQ_'(Genealized Linear Model )
%ORDER_RESULT: 1: test ORDER EFFECTS, 2: get RESULTS, 3: get Larynx/Tongue TMS ORDER EFFECTS (within the first 10mins after rTMS or Sham)
%select_in_dispord: 根据display order来选择turn
%select_in_storord: 根据store order来选择turn

SUBJ_lst=[7 10 12 18 38 39 41 51 55 59 67 70 78];
block_labels={'T CLEAR ID','P CLEAR ID','T NOISE ID','P NOISE ID','T CLEAR DI','P CLEAR DI','T NOISE DI','P NOISE DI'};

%% 1：turn order effect: Sham
[AREAS_sham,~,~,DATA_avg_sham,~]=bsliang_TMSIDDI_results(SUBJ_lst,'_slopecurve_','_pku_',1,1:4,[2 4],1,1);
% 求反应时的练习效应
p_sham=zeros(1,8);
stats_sham=cell(1,8);
for sham_i=1:8 %第一个是显著的
    [~,p_sham(1,sham_i),~,stats_sham{1,sham_i}]=ttest2(mean(DATA_avg_sham{1,sham_i},2),mean(DATA_avg_sham{2,sham_i},2));
end
[~,p_sham_AUC,~,~]=ttest(AREAS_sham{1,1}(:,1),AREAS_sham{1,1}(:,2));
pause();

%求DIpeak
[~,~,~,~,index_mat_2_sham,DATA_avgRT_sham]=bsliang_TMSIDDI_results(SUBJ_lst,'_IDcurve_','_pku_',1,1:4,[2 4],1,1);
[~,p_PEAK_sham,~,~]=ttest(index_mat_2_sham{1,4}(:,1),index_mat_2_sham{1,4}(:,2));
pause();

%% 1：turn order effect: rTMS
[AREAS_rTMS,~,~,DATA_avg_rTMS,~]=bsliang_TMSIDDI_results(SUBJ_lst,'_slopecurve_','_pku_',1,1:4,[1 3],1,1);
[~,p_AREAS_rTMS,~,~]=ttest(AREAS_rTMS{1,1}(:,1),AREAS_rTMS{1,1}(:,2));

pause();
[~,~,~,~,index_mat_2_rTMS,DATA_avgRT_rTMS]=bsliang_TMSIDDI_results(SUBJ_lst,'_IDcurve_','_pku_',1,1:4,[1 3],1,1);
pause();

%% 1：turn order effect: rTMS_Larynx
[~,~,~,~,~,DATA_avgRT_LrTMS]=bsliang_TMSIDDI_results(SUBJ_lst,'_IDcurve_','_pku_',1,1:4,1,1,1);
pause();

%% 1：turn order effect: rTMS_Tongue
[~,~,~,~,~,DATA_avgRT_TrTMS]=bsliang_TMSIDDI_results(SUBJ_lst,'_IDcurve_','_pku_',1,1:4,3,1,1);
pause();

%% compare order effects： Sham and rTMS
figure
for block=1:8
    DATA_avg_sham_rTMS_tmp=bsliang_fillmatrixgap({mean(DATA_avg_sham{1,block},2),mean(DATA_avg_rTMS{1,block},2),...
                            mean(DATA_avg_sham{2,block},2),mean(DATA_avg_rTMS{2,block},2),...
                            mean(DATA_avg_sham{3,block},2),mean(DATA_avg_rTMS{3,block},2),...
                            mean(DATA_avg_sham{4,block},2),mean(DATA_avg_rTMS{4,block},2)});
    subplot(8,1,block);
    boxplot(DATA_avg_sham_rTMS_tmp);
    title(block_labels{block});
    set(gca,'XTickLabel',{'Sham_1','rTMS_1','Sham_2','rTMS_2','Sham_3','rTMS_3','Sham_4','rTMS_4'});
end

%% 杜老师 20191112：看看排除了练习效应之后的三幅图
figure
    % plot1：对比sham的rTMS (pooled掉所有条件)
    subplot(1,5,1);
    sham_pool_m = mean(DATA_avgRT_sham{1,1});
    sham_pool_sd = std(DATA_avgRT_sham{1,1});
    rTMS_pool_m = mean(DATA_avgRT_rTMS{1,1});
    rTMS_pool_sd = std(DATA_avgRT_rTMS{1,1});
    errorbar(sham_pool_m,sham_pool_sd);
    hold on
    errorbar(rTMS_pool_m,rTMS_pool_sd);
    legend('Sham','rTMS');
    
    for cond_i=2:5
        subplot(1,5,cond_i);
        sham_pool_m = mean(DATA_avgRT_sham{1,cond_i});
        sham_pool_sd = std(DATA_avgRT_sham{1,cond_i});
        rTMS_L_m = mean(DATA_avgRT_LrTMS{1,cond_i});
        rTMS_L_sd = std(DATA_avgRT_LrTMS{1,cond_i});    
        rTMS_T_m = mean(DATA_avgRT_TrTMS{1,cond_i});
        rTMS_T_sd = std(DATA_avgRT_TrTMS{1,cond_i}); 
        errorbar(sham_pool_m,sham_pool_sd);
        hold on
        errorbar(rTMS_L_m,rTMS_L_sd);
        errorbar(rTMS_T_m,rTMS_T_sd);
        legend('Sham','Larynx','Tongue');
    end

   
%% compare order effects： Sham and rTMS [杜老师20191113：分开12次和34次，分开clear和noise]
RT_mean_mid=2;
block_labels2={'POOLED','T CLEAR ID','P CLEAR ID','T NOISE ID','P NOISE ID'};
select_in_dispord_1113={[1 2],[3 4],2,2,[3 4]}; %[20191116：后面加的两个条件是把position2的rTMS条件也算进去的，第一个2表示找position2的(rTMS,所以后面条件里面写的是[1 3])，第二个找position 3 4的，（Sham，所以后面条件里面写的是[2 4]））
SID_add=[0 5];
for SID=1:2
    % step1: sham1
    [AREAS_Lsham,~,~,DATA_avg_Lsham,~]=bsliang_TMSIDDI_results(SUBJ_lst,'_slopecurve_','_pku_',1,select_in_dispord_1113{SID},2,0,RT_mean_mid);
    [~,~,~,~,index_mat_2_Lsham,DATA_avgRT_Lsham]=bsliang_TMSIDDI_results(SUBJ_lst,'_IDcurve_','_pku_',1,select_in_dispord_1113{SID},2,0,RT_mean_mid);

   % step2: sham2 
    [AREAS_Tsham,~,~,DATA_avg_Tsham,~]=bsliang_TMSIDDI_results(SUBJ_lst,'_slopecurve_','_pku_',1,select_in_dispord_1113{SID},4,0,RT_mean_mid);
    [~,~,~,~,index_mat_2_Tsham,DATA_avgRT_Tsham]=bsliang_TMSIDDI_results(SUBJ_lst,'_IDcurve_','_pku_',1,select_in_dispord_1113{SID},4,0,RT_mean_mid);
    
    % step3: LrTMS
    [AREAS_LrTMS,~,~,DATA_avg_LrTMS,~]=bsliang_TMSIDDI_results(SUBJ_lst,'_slopecurve_','_pku_',1,select_in_dispord_1113{SID},1,0,RT_mean_mid);
    [~,~,~,~,index_mat_2_LrTMS,DATA_avgRT_LrTMS]=bsliang_TMSIDDI_results(SUBJ_lst,'_IDcurve_','_pku_',1,select_in_dispord_1113{SID},1,0,RT_mean_mid);

    % step4: TrTMS
    [AREAS_TrTMS,~,~,DATA_avg_TrTMS,~]=bsliang_TMSIDDI_results(SUBJ_lst,'_slopecurve_','_pku_',1,select_in_dispord_1113{SID},3,0,RT_mean_mid);
    [~,~,~,~,index_mat_2_TrTMS,DATA_avgRT_TrTMS]=bsliang_TMSIDDI_results(SUBJ_lst,'_IDcurve_','_pku_',1,select_in_dispord_1113{SID},3,0,RT_mean_mid);

    % step5: rTMS
    [AREAS_TrTMS,~,~,DATA_avg_TrTMS,~]=bsliang_TMSIDDI_results(SUBJ_lst,'_slopecurve_','_pku_',1,select_in_dispord_1113{SID},3,0,RT_mean_mid);
    [~,~,~,~,index_mat_2_TrTMS,DATA_avgRT_TrTMS]=bsliang_TMSIDDI_results(SUBJ_lst,'_IDcurve_','_pku_',1,select_in_dispord_1113{SID},3,0,RT_mean_mid);

    
    for concon=3%:3%:4
        if concon==1
            DATA_LrTMS=AREAS_LrTMS;
            DATA_Lsham=AREAS_Lsham;
            DATA_TrTMS=AREAS_TrTMS;
            DATA_Tsham=AREAS_Tsham;
        elseif concon==2
            DATA_LrTMS=index_mat_2_LrTMS;
            DATA_Lsham=index_mat_2_Lsham;
            DATA_TrTMS=index_mat_2_TrTMS;
            DATA_Tsham=index_mat_2_Tsham;
        elseif concon==3
            DATA_LrTMS=DATA_avgRT_LrTMS;
            DATA_Lsham=DATA_avgRT_Lsham;
            DATA_TrTMS=DATA_avgRT_TrTMS;
            DATA_Tsham=DATA_avgRT_Tsham;
        end
        if SID==1
            LrTMS_Sham_DATA = cell(2,5);
            TrTMS_Sham_DATA = cell(2,5);
            % 杜老师20191114新要求：对于第1 2次，看的是练习效应，需要的是将被试分成两组：每次来先做rTMS的和每组来先做Sham
            % 实际上我的每个avg_RT就是特定某次做特定某个条件（比如第三次来做LarynxTMS）的所有被试的数据，所以只需要把该次（如第三次）的rTMS减去另外一次（入第四次）的
            % Sham条件就可以了。

            for cond_i=1:5
                LrTMS_Sham_DATA{1,cond_i} = [DATA_LrTMS{1,cond_i}(:,1),DATA_Lsham{1,cond_i}(:,2)];
                LrTMS_Sham_DATA{2,cond_i} = [DATA_Lsham{1,cond_i}(:,1),DATA_LrTMS{1,cond_i}(:,2)];

                TrTMS_Sham_DATA{1,cond_i} = [DATA_TrTMS{1,cond_i}(:,1),DATA_Tsham{1,cond_i}(:,2)];
                TrTMS_Sham_DATA{2,cond_i} = [DATA_Tsham{1,cond_i}(:,1),DATA_TrTMS{1,cond_i}(:,2)];            
            end

            figure;
            for LT=1:2
                if LT==1
                    TMS_Sham_DATA=LrTMS_Sham_DATA;
                else
                    TMS_Sham_DATA=TrTMS_Sham_DATA;
                end
                for cond_i=1:5
                    subplot(2,5,cond_i+SID_add(LT));

                    TMS_1m=mean(TMS_Sham_DATA{1,cond_i}(:,1));
                    Sham_1m=mean(TMS_Sham_DATA{1,cond_i}(:,2));
                    TMS_2m=mean(TMS_Sham_DATA{2,cond_i}(:,2));
                    Sham_2m=mean(TMS_Sham_DATA{2,cond_i}(:,1));

                    TMS_1sd=std(TMS_Sham_DATA{1,cond_i}(:,1));
                    Sham_1sd=std(TMS_Sham_DATA{1,cond_i}(:,2));
                    TMS_2sd=std(TMS_Sham_DATA{2,cond_i}(:,2));
                    Sham_2sd=std(TMS_Sham_DATA{2,cond_i}(:,1));

                    errorbar([1 2],[TMS_1m TMS_2m],[TMS_1sd TMS_2sd],'ro');
                    hold on
                    errorbar([2 1],[Sham_1m Sham_2m],[Sham_1sd Sham_2sd],'bo');
                    plot([1 2],[TMS_1m Sham_1m],'Color',[0.5 0.8 0.5]);
                    plot([1 2],[Sham_2m TMS_2m],'Color',[0.8 0.8 0.8]);
                    legend('rTMS','Sham','TMS First','Sham First');

                    title(block_labels2{cond_i});
                    %ylim([0.5 1.2]);
                    set(gca,'xtick',[1 2]);
                    set(gca,'XTickLabel',{'Pos1','Pos2'});
                end
            end

        elseif SID==2

            TMS_Sham_DATA = cell(1,5);
            Sham_DATA = cell(1,5);

            % 杜老师20191114新要求：对于第3 4次，已经排除了练习效应，就应该直接对比S和T，并且3 4次和在一起。
            % [杜老师原话：你这几天是休息不够吧，脑子怎么不清晰了呢？34次已经不考虑学习效应了，把3，4次按照
            %  sham和TMS部位合在一起分析RT，最好是用每个人的sham作为基线，让他/她的TMS-sham作为指标，比较
            %  不同刺激部位和任务条件]。
            % 实际上我的每个avg_RT就是特定某次做特定某个条件（比如第三次来做LarynxTMS）的所有被试的数据，所以只需要把该次（如第三次）的rTMS减去另外一次（入第四次）的
            % Sham条件就可以了。

            for cond_i=1:5
                LrTMS_Sham_DATA_1 = DATA_LrTMS{1,cond_i}(:,3) - DATA_Lsham{1,cond_i}(:,4);
                LrTMS_Sham_DATA_2 = DATA_LrTMS{1,cond_i}(:,4) - DATA_Lsham{1,cond_i}(:,3);
                TMS_Sham_DATA{1,cond_i}(:,1) = [LrTMS_Sham_DATA_1;LrTMS_Sham_DATA_2];
                
                LSham_DATA_1 = DATA_Lsham{1,cond_i}(:,4);
                LSham_DATA_2 = DATA_Lsham{1,cond_i}(:,3);
                Sham_DATA{1,cond_i}(:,1) = [LSham_DATA_1;LSham_DATA_2];
                
                TrTMS_Sham_DATA_1 = DATA_TrTMS{1,cond_i}(:,3) - DATA_Tsham{1,cond_i}(:,4);
                TrTMS_Sham_DATA_2 = DATA_TrTMS{1,cond_i}(:,4) - DATA_Tsham{1,cond_i}(:,3);
                TMS_Sham_DATA{1,cond_i}(:,2) = [TrTMS_Sham_DATA_1;TrTMS_Sham_DATA_2];
                
                TSham_DATA_1 = DATA_Tsham{1,cond_i}(:,4);
                TSham_DATA_2 = DATA_Tsham{1,cond_i}(:,3);
                Sham_DATA{1,cond_i}(:,2) = [TSham_DATA_1;TSham_DATA_2];
            end

            figure;
            gretna_plot_dot(TMS_Sham_DATA,block_labels2,{'Larynx-Sham','Tongue-Sham'},'sem');

            figure;
            for cond_i=1:5
                
                subplot(3,5,cond_i);
                boxplot(TMS_Sham_DATA{1,cond_i})
                h1_tmp=ttest(TMS_Sham_DATA{1,cond_i}(:,1));
                h2_tmp=ttest(TMS_Sham_DATA{1,cond_i}(:,2));
                enh1_tmp=sum(TMS_Sham_DATA{1,cond_i}(:,1)>0);
                enh2_tmp=sum(TMS_Sham_DATA{1,cond_i}(:,2)>0);
                size_tmp=size(TMS_Sham_DATA{1,cond_i},1);
                
                if h1_tmp==1
                    text(1,mean(TMS_Sham_DATA{1,cond_i}(:,1))+2*std(TMS_Sham_DATA{1,cond_i}(:,1)),'*','FontSize',30);
                end
                if h2_tmp==1
                    text(2,mean(TMS_Sham_DATA{1,cond_i}(:,2))+2*std(TMS_Sham_DATA{1,cond_i}(:,2)),'*','FontSize',30);
                end
                title(block_labels2{cond_i});
               % ylim([-0.25 0.25]);
                set(gca,'XTickLabel',{['Larynx-Sham ',num2str(enh1_tmp),'/',num2str(size_tmp)],['Tongue-Sham ',num2str(enh2_tmp),'/',num2str(size_tmp)]});
                
                for condi_add=[5 10]
                    subplot(3,5,cond_i+condi_add);
                    X = TMS_Sham_DATA{1,cond_i}(:,condi_add/5);
                    Y = Sham_DATA{1,cond_i}(:,condi_add/5);
                    p = polyfit(X,Y,1);
                    f = polyval(p,X); 
                    plot(X,Y,'o',X,f,'-');
                    [Rcro,Pcro]=corrcoef(X,Y);
                    xlabel({['Y = ',num2str(round(p(1),3)),'X + ',num2str(round(p(2),3)),' R^2 = ',num2str(round(1-sum((Y-f).^2)/((length(Y)-1)*var(Y)),3))],['r = ',num2str(round(Rcro(2),3)),' p = ',num2str(round(Pcro(2),3))]});
                end

            end

        end
    end
end
    
    % plot1：对比sham的rTMS (pooled掉所有条件)
%     subplot(2,5,1+SID_add(SID));
%     sham_pool_m = mean(DATA_avgRT_sham{1,1});
%     sham_pool_sd = std(DATA_avgRT_sham{1,1});
%     LrTMS_pool_m = mean(DATA_avgRT_LrTMS{1,1});
%     LrTMS_pool_sd = std(DATA_avgRT_LrTMS{1,1});
%     TrTMS_pool_m = mean(DATA_avgRT_TrTMS{1,1});
%     TrTMS_pool_sd = std(DATA_avgRT_TrTMS{1,1});
%     errorbar(sham_pool_m,sham_pool_sd);
%     title(block_labels2{1});
%     xlim([2.5 4.5]);
%     hold on
%     errorbar(LrTMS_pool_m,LrTMS_pool_sd);
%     errorbar(TrTMS_pool_m,TrTMS_pool_sd);
%     legend('Sham','LrTMS','TrTMS');
%     
%     for cond_i=2:5
%         subplot(2,5,cond_i+SID_add(SID));
%         sham_pool_m = mean(DATA_avgRT_sham{1,cond_i});
%         sham_pool_sd = std(DATA_avgRT_sham{1,cond_i});
%         rTMS_L_m = mean(DATA_avgRT_LrTMS{1,cond_i});
%         rTMS_L_sd = std(DATA_avgRT_LrTMS{1,cond_i});    
%         rTMS_T_m = mean(DATA_avgRT_TrTMS{1,cond_i});
%         rTMS_T_sd = std(DATA_avgRT_TrTMS{1,cond_i}); 
%         errorbar(sham_pool_m,sham_pool_sd);
%         xlim([2.5 4.5]);
%         title(block_labels2{cond_i});
%         hold on
%         errorbar(rTMS_L_m,rTMS_L_sd);
%         errorbar(rTMS_T_m,rTMS_T_sd);
%         legend('Sham','Larynx','Tongue');
%     end
    
% end
    
%% 2：without the first turn: ALL
[AREAS_234turns,~,~,DATA_avg_234turns,~]=bsliang_TMSIDDI_results(SUBJ_lst,'_slopecurve_','_pku_',2,1:4,1:4,1,1);
pause();
[~,~,~,~,index_mat_2_234turns]=bsliang_TMSIDDI_results(SUBJ_lst,'_IDcurve_','_pku_',2,1:4,1:4,1,1);
pause();

%% 3：rTMS after effects (only select 10min): ALL
[AREAS_10min,~,~,DATA_avg_10min,~]=bsliang_TMSIDDI_results(SUBJ_lst,'_slopecurve_','_pku_',3,1:4,1:4,1,1);
pause();
[~,~,~,~,index_mat_2_10min]=bsliang_TMSIDDI_results(SUBJ_lst,'_IDcurve_','_pku_',3,1:4,1:4,1,1);
pause();
