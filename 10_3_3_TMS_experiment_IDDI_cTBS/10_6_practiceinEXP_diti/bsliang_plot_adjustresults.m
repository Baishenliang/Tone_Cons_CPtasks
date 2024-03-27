function [stats_result,range_predit]=bsliang_plot_adjustresults(par_nums,mode,Di_or_RT,am_unam,plot_types,fit_or_org_curve)

%如果要作所有被试，用这个：
%[stats_result,range_predict]=bsliang_plot_adjustresults(17:34,'_average_','RT','_ALL_',5,'_fit_');

%par_nums: list of participants' number
%mode: (1) '_individual_': plot individual graphs (show all tests for adjustment + discrimination peak(s))
%      (2) '_average_': ploy averaged graphs (show the first test for adjustment + discrimination peak(s)) 
%Di_or_RT: (1) 'Di': plot points/curve for discrimination;
%          (2) 'RT': plot points/curve for RT.
load('DATA.mat');
load('input/diti_7steps_xs_perc_struct.mat');
Di_Tx=xs_perc_struct.xs_perc.tone_old(2:end-1);
Di_Px=xs_perc_struct.xs_perc.phon_old(2:end-1);

if isequal(mode,'_average_')
    % cutoutlier_Id: If the condition did not show an entire range, such a condition is regarded as an outlier
    % cutoutlier_Di: If the condition did not show a peak, such a condition is regarded as an outlier
    % cutoutlier_both: If the condition did not show either an entire range or a peak, such a condition is regarded as an outlier
    % cutoutlier_both_strict: if either condition of the subject meets the cutoutlier_both, such a subject is an outlier
    cutoutlier={'all_left','cutoutlier_Id','cutoutlier_Di','cutoutlier_both','cutoutlier_both_strict'};
elseif isequal(mode,'_individual_')
    cutoutlier={'all_left'};
end
    

for oltype=plot_types
    
     T_ID_group=[];
     P_ID_group=[];
     T_IDRT_group=[];
     P_IDRT_group=[];
     T_IDRTx_group=[];
     P_IDRTx_group=[];
     T_DI_group=[];
     P_DI_group=[];
     
     for par_num=par_nums
        cut_this_par=[0 0]; % first for tone, and second for phoneme
        subjDATA=DATA(par_num).def_range.data;
        %校正前的discrimination：
        %Di_Ty=DATA(par_num).Id_Di.data(1).half_threshold;
        %Di_Py=DATA(par_num).Id_Di.data(2).half_threshold;

        %校正后的discrimination：
        Di_Tx_adjust=subjDATA(1).half_threshold(2:end-1,1);
        Di_Px_adjust=subjDATA(2).half_threshold(2:end-1,1);
        
        [T_IDy,P_IDy,~,~,Di_Ty_adjust,Di_Py_adjust,~]=bsliang_get9stepsRTs(par_num,9,am_unam);
        [~,~,IDRT_Ty,IDRT_Py,~,~,~]=bsliang_get9stepsRTs(par_num,9,am_unam);

        IDRT_Ty=IDRT_Ty-0.37;
        IDRT_Py=IDRT_Py-0.37;
        
          %IDRT_Ty=bsliang_normalone(IDRT_Ty); %归一化
          %IDRT_Py=bsliang_normalone(IDRT_Py); %归一化
        
        if isequal(mode,'_average_')
            %Di_Ty_adjust=bsliang_normalone(Di_Ty_adjust); %归一化
            %Di_Py_adjust=bsliang_normalone(Di_Py_adjust); %归一化
            [~,maxDi_Ty]=min(Di_Ty_adjust*(-1));
            [~,maxDi_Py]=min(Di_Py_adjust*(-1));
            if (oltype == 3) || (oltype == 4) || (oltype == 5) %  cutoutlier_Di || cutoutlier_both
                if maxDi_Ty~=2
                    cut_this_par(1)=1;
                    if oltype == 5
                        cut_this_par=[1 1];
                    end
                end
                if maxDi_Py~=2
                    cut_this_par(2)=1;
                    if oltype == 5
                        cut_this_par=[1 1];
                    end
                end
            end
        end

        load(['adjust_range_test_20190728/Par_',num2str(par_num),'_adjust_range_test_result.mat']);
        result=adjust_range_test_result;
        
        IDRT_Tx=result(1,1).T(:,1);
        IDRT_Px=result(1,1).P(:,1);
        
        if (oltype == 2) || (oltype == 4) || (oltype == 5) %  cutoutlier_Id || cutoutlier_both
            if isempty(find(T_IDy==0,1)) || isempty(find(T_IDy==1,1))
                cut_this_par(1)=1;
                if oltype == 5
                    cut_this_par=[1 1];
                end
            end
            if isempty(find(P_IDy==0,1)) || isempty(find(P_IDy==1,1))
                cut_this_par(2)=1;
                if oltype == 5
                    cut_this_par=[1 1];
                end
            end
        end 
        if cut_this_par(1)==0
            T_ID_group=[T_ID_group;T_IDy];
            T_IDRT_group=[T_IDRT_group;IDRT_Ty];
            T_IDRTx_group=[T_IDRTx_group;IDRT_Tx'];
            T_DI_group=[T_DI_group;Di_Ty_adjust'];
        end
        if cut_this_par(2)==0
            P_ID_group=[P_ID_group;P_IDy];
            P_IDRT_group=[P_IDRT_group;IDRT_Py];
            P_IDRTx_group=[P_IDRTx_group;IDRT_Px'];
            P_DI_group=[P_DI_group;Di_Py_adjust'];
        end
        
        if par_num==par_nums(end) && isequal(mode,'_average_')
            
            stats_result=[];
            
            [~,stats_result.T_IDRT_ttest_p,~,stats_result.T_IDRT_ttest_stats] = ttest(T_IDRT_group(:,round((1+end)/2)),(T_IDRT_group(:,1)+T_IDRT_group(:,end))/2);
            [~,stats_result.P_IDRT_ttest_p,~,stats_result.P_IDRT_ttest_stats] = ttest(P_IDRT_group(:,round((1+end)/2)),(P_IDRT_group(:,1)+P_IDRT_group(:,end))/2);
            [~,stats_result.T_DI_ttest_p,~,stats_result.T_DI_ttest_stats] = ttest(T_DI_group(:,round((1+end)/2)),(T_DI_group(:,1)+T_DI_group(:,end))/2);
            [~,stats_result.P_DI_ttest_p,~,stats_result.P_DI_ttest_stats] = ttest(P_DI_group(:,round((1+end)/2)),(P_DI_group(:,1)+P_DI_group(:,end))/2);
            
            T_ID_avg=mean(T_ID_group,1);
            [ID_T_mid,T_ID_fit]=bsliang_getfivesteps_phyisometrix_perc(100*result(1,trial).T(:,1)',100*T_ID_avg);
            ID_T_mid=ID_T_mid/100;
            T_ID_fit=T_ID_fit/100;
            T_IDRT_avg=mean(T_IDRT_group,1);
            T_IDRTx_avg=mean(T_IDRTx_group,1);
            T_DI_avg=mean(T_DI_group,1);
            P_ID_avg=mean(P_ID_group,1);
            [ID_P_mid,P_ID_fit]=bsliang_getfivesteps_phyisometrix_perc(100*result(1,trial).P(:,1)',100*P_ID_avg);
            ID_P_mid=ID_P_mid/100;
            P_ID_fit=P_ID_fit/100;
            P_IDRT_avg=mean(P_IDRT_group,1);
            P_IDRTx_avg=mean(P_IDRTx_group,1);
            P_DI_avg=mean(P_DI_group,1);
            
            T_ID_sd=zeros(1,length(T_ID_avg));
            T_IDRT_sd=zeros(1,length(T_IDRT_avg));
            T_DI_sd=zeros(1,length(T_DI_avg));
            P_ID_sd=zeros(1,length(P_ID_avg));
            P_IDRT_sd=mean(1,length(P_IDRT_avg));
            P_DI_sd=zeros(1,length(P_DI_avg));
            
            for step_i=1:length(T_ID_avg)
                T_ID_sd(step_i)=std(T_ID_group(:,step_i))/sqrt(length(par_nums));
                P_ID_sd(step_i)=std(P_ID_group(:,step_i))/sqrt(length(par_nums));
            end
            
            for step_i=1:length(T_IDRT_avg)
                T_IDRT_sd(step_i)=std(T_IDRT_group(:,step_i))/sqrt(length(par_nums));
                P_IDRT_sd(step_i)=std(P_IDRT_group(:,step_i))/sqrt(length(par_nums));
            end
            
            for step_i=1:length(T_DI_avg)
                T_DI_sd(step_i)=std(T_DI_group(:,step_i))/sqrt(length(par_nums));
                P_DI_sd(step_i)=std(P_DI_group(:,step_i))/sqrt(length(par_nums));
            end
        end
        
        figure(1);
        figure(2);
        if isequal(mode,'_individual_')
            IDendtrial=size(result,2);
            DIline={[1 0.9 0.9],[0.9 1 0.9],[0.9 0.9 1],[1 1 0.9],[0.9 1 1],[1 0.9 1],[1 0.9 0.9],[0.9 1 0.9],[0.9 0.9 1]};
        elseif isequal(mode,'_average_')
            IDendtrial=1;
            DIline={[1 0.9 0.9],[0.9 1 0.9],[0.9 0.9 1],[1 1 0.9],[0.9 1 1],[1 0.9 1],[1 0.9 0.9],[0.9 1 0.9],[0.9 0.9 1]};
        end

        figure(1);
        xlabel('F0百分比');
        ylabel('Id: 反应曲线 || Di: d'' || Id反应时: s');
        ylim([0 1.2]);
        %the following commented line is for Di_Id experiment with averaged
        %range
        %plot(Di_Tx,Di_Ty,'b--');
        if cut_this_par(1)==0
            if isequal(Di_or_RT,'Di')
                len_scatter=length(Di_Ty_adjust);
                %plot(Di_Tx_adjust,Di_Ty_adjust,'Color',[0.8 0.5 0.5],'LineWidth',1);
            elseif isequal(Di_or_RT,'RT')
                len_scatter=length(IDRT_Ty);
                %plot(IDRT_Tx,IDRT_Ty,'Color',[0.8 0.8 0.8],'LineWidth',1);
            end
            for Di_p=1:len_scatter
                if isequal(Di_or_RT,'Di')
                    scatter(Di_Tx_adjust(Di_p),Di_Ty_adjust(Di_p),30,DIline{Di_p},'filled');
                elseif isequal(Di_or_RT,'RT')
                    scatter(IDRT_Tx(Di_p),IDRT_Ty(Di_p),30,DIline{Di_p},'filled');
                end
                hold on;
            end
        end

        if isequal(mode,'_individual_')
            title(['被试',num2str(par_num),' 声调判断个体化range选取']);
            plot([result(1,end).T(1,1) result(1,end).T(1,1)],[0 1],'k--');
            plot([result(1,end).T(end,1) result(1,end).T(end,1)],[0 1],'k--');
        else
            title(['声调判断range选取 ','STEP',num2str(am_unam)]);
        end
        
        figure(2);
        xlabel('VOT百分比');
        ylabel('Id: 反应曲线 || Di: d'' || Id反应时: s');
        ylim([0 1.2]);
        %plot(Di_Px,Di_Py,'b--');
        if cut_this_par(2)==0
            if isequal(Di_or_RT,'Di')
                len_scatter=length(Di_Py_adjust);
            elseif isequal(Di_or_RT,'RT')
                len_scatter=length(IDRT_Py);
            end
            for Di_p=1:len_scatter
                if isequal(Di_or_RT,'Di')
                    scatter(Di_Px_adjust(Di_p),Di_Py_adjust(Di_p),30,DIline{Di_p},'filled');
                elseif isequal(Di_or_RT,'RT')
                    scatter(IDRT_Px(Di_p),IDRT_Py(Di_p),30,DIline{Di_p},'filled');
                end
                hold on;
            end
        end

        if isequal(mode,'_individual_')
            title(['被试',num2str(par_num),' 音位判断个体化range选取']);
            plot([result(1,end).P(1,1) result(1,end).P(1,1)],[0 1],'k--');
            plot([result(1,end).P(end,1) result(1,end).P(end,1)],[0 1],'k--');
        else
            title(['音位判断range选取','STEP',num2str(am_unam)]);
        end

        legend_Tags=cell(1,IDendtrial);
        for trial=1:IDendtrial
            legend_Tags{1,trial}=['Id曲线 ',num2str(trial)];
            figure(1);
            if cut_this_par(1)==0
                plot(result(1,trial).T(:,1),T_IDy,'Color',[0.9 0.9 0.9],'LineWidth',1);
                if par_num==par_nums(end) && isequal(mode,'_average_')
                    if isequal(fit_or_org_curve,'_fit_')
                        plot(result(1,trial).T(:,1)',T_ID_fit,'Color',[0.5 0.5 0.8],'LineWidth',2);
                        errorbar(result(1,trial).T(:,1)',T_ID_fit,T_ID_sd,'Color',[0.5 0.5 0.8],'LineWidth',1);
                    elseif isequal(fit_or_org_curve,'_org_')
                        plot(result(1,trial).T(:,1)',T_ID_avg,'Color',[0.5 0.5 0.8],'LineWidth',2)
                        errorbar(result(1,trial).T(:,1)',T_ID_avg,T_ID_sd,'Color',[0.5 0.5 0.8],'LineWidth',1);
                    	ID_T_mid=result(1,trial).T(round(1+end)/2,1)';
                    end
                    plot([ID_T_mid ID_T_mid],[0 1.2],'Color',[0.5 0.5 0.8]);
                    plot(T_IDRTx_avg,T_IDRT_avg,'Color',[0.8 0.5 0.5],'LineWidth',2);
                    [X_T_IDRT_line,~]=bsliang_gainPeakx_from_DIandRT(T_IDRTx_avg([round((1+end)/2)-1,round((1+end)/2),round((1+end)/2)+1]),T_IDRT_avg([round((1+end)/2)-1,round((1+end)/2),round((1+end)/2)+1]));
                    plot([X_T_IDRT_line X_T_IDRT_line],[0 1.2],'Color',[0.8 0.5 0.5]);
                    errorbar(T_IDRTx_avg,T_IDRT_avg,T_IDRT_sd,'Color',[0.8 0.5 0.5],'LineWidth',1);
                    plot(Di_Tx_adjust,T_DI_avg,'Color',[0.5 0.8 0.5],'LineWidth',2);
                    [X_T_DI_line,~]=bsliang_gainPeakx_from_DIandRT(Di_Tx_adjust,T_DI_avg);
                    plot([X_T_DI_line X_T_DI_line],[0 1.2],'Color',[0.5 0.8 0.5]);
                    errorbar(Di_Tx_adjust,T_DI_avg,T_DI_sd,'Color',[0.5 0.8 0.5],'LineWidth',1);
                    range_predit.T=bsliang_getRANGE(result(1,trial).T(1,1),mean([ID_T_mid X_T_DI_line]),result(1,trial).T(end,1));
                    plot([range_predit.T(1) range_predit.T(1)],[0 1.2],'k--');
                    plot([range_predit.T(2) range_predit.T(2)],[0 1.2],'k--');
                end
            end
            hold on
        figure(2);
            if cut_this_par(2)==0
                plot(result(1,trial).P(:,1),P_IDy,'Color',[0.9 0.9 0.9],'LineWidth',1);
                if par_num==par_nums(end) && isequal(mode,'_average_')
                    if isequal(fit_or_org_curve,'_fit_')
                        plot(result(1,trial).P(:,1)',P_ID_fit,'Color',[0.5 0.5 0.8],'LineWidth',2);
                        errorbar(result(1,trial).P(:,1)',P_ID_fit,P_ID_sd,'Color',[0.5 0.5 0.8],'LineWidth',1);
                    elseif isequal(fit_or_org_curve,'_org_')
                        plot(result(1,trial).P(:,1)',P_ID_avg,'Color',[0.5 0.5 0.8],'LineWidth',2)
                        errorbar(result(1,trial).P(:,1)',P_ID_avg,P_ID_sd,'Color',[0.5 0.5 0.8],'LineWidth',1);
                        ID_P_mid=result(1,trial).P(round(1+end)/2,1)';
                    end                        
                    plot([ID_P_mid ID_P_mid],[0 1.2],'Color',[0.5 0.5 0.8]);
                    plot(P_IDRTx_avg,P_IDRT_avg,'Color',[0.8 0.5 0.5],'LineWidth',2);
                    errorbar(P_IDRTx_avg,P_IDRT_avg,P_IDRT_sd,'Color',[0.8 0.5 0.5],'LineWidth',1);
                    [X_P_IDRT_line,~]=bsliang_gainPeakx_from_DIandRT(P_IDRTx_avg([round((1+end)/2)-1,round((1+end)/2),round((1+end)/2)+1]),P_IDRT_avg([round((1+end)/2)-1,round((1+end)/2),round((1+end)/2)+1]));
                    plot([X_P_IDRT_line X_P_IDRT_line],[0 1.2],'Color',[0.8 0.5 0.5]);
                    plot(Di_Px_adjust,P_DI_avg,'Color',[0.5 0.8 0.5],'LineWidth',2);
                    [X_P_DI_line,~]=bsliang_gainPeakx_from_DIandRT(Di_Px_adjust,P_DI_avg);
                    plot([X_P_DI_line X_P_DI_line],[0 1.2],'Color',[0.5 0.8 0.5]);
                    errorbar(Di_Px_adjust,P_DI_avg,P_DI_sd,'Color',[0.5 0.8 0.5],'LineWidth',1);
                    range_predit.P=bsliang_getRANGE(result(1,trial).P(1,1),mean([ID_P_mid X_P_DI_line]),result(1,trial).P(end,1));
                    plot([range_predit.P(1) range_predit.P(1)],[0 1.2],'k--');
                    plot([range_predit.P(2) range_predit.P(2)],[0 1.2],'k--');
                end
            end
            hold on
        end
        for ff=1:2
            figure(ff);
            if isequal(Di_or_RT,'Di')
                %legend([{'Di 1-3','Di 2-4','Di 5-7',legend_Tags}]);
            elseif isequal(Di_or_RT,'RT')
                %legend([{'RT step1','RT step2','RT step3','RT step4','RT step5','RT step6','RT step7','RT step8','RT step9',legend_Tags}]);
            end
        end
        
        if isequal(mode,'_individual_')
            saveas(figure(1),['./result_plots/No_',num2str(par_num),'_T_adjust_',strrep(strrep(strrep(datestr(now),':','_'),' ','_'),'-','_'),'.png'])
            saveas(figure(2),['./result_plots/No_',num2str(par_num),'_P_adjust_',strrep(strrep(strrep(datestr(now),':','_'),' ','_'),'-','_'),'.png'])
            close all
        end

        clear adjust_range_test_result
     end
 
	if isequal(mode,'_average_')
        saveas(figure(1),['./result_plots/',cutoutlier{oltype},'average_T_adjust_',strrep(strrep(strrep(datestr(now),':','_'),' ','_'),'-','_'),'.png']);
        saveas(figure(2),['./result_plots/',cutoutlier{oltype},'average_P_adjust_',strrep(strrep(strrep(datestr(now),':','_'),' ','_'),'-','_'),'.png']);
        close all
    end
end

