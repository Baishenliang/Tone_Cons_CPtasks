function bsliang_plot_adjustresults_individual(par_nums)
%par_nums: list of participants' number
load('DATA.mat');
load('input/diti_7steps_xs_perc_struct.mat');
Di_Tx=xs_perc_struct.xs_perc.tone_old(2:end-1);
Di_Px=xs_perc_struct.xs_perc.phon_old(2:end-1);
 for par_num=par_nums
    %校正前的discrimination：
    %Di_Ty=DATA(par_num).Id_Di.data(1).half_threshold;
    %Di_Py=DATA(par_num).Id_Di.data(2).half_threshold;
    
    %校正后的discrimination：
    Di_Tx_adjust=DATA(par_num).def_range.data(1).half_threshold(2:end-1,1);
    Di_Px_adjust=DATA(par_num).def_range.data(2).half_threshold(2:end-1,1);
    Di_Ty_adjust=DATA(par_num).def_range.data(3).half_threshold;
    Di_Py_adjust=DATA(par_num).def_range.data(4).half_threshold;
    
    load(['adjust_range_test_20190728/Par_',num2str(par_num),'_adjust_range_test_result.mat']);
    result=adjust_range_test_result;
    figure(1);
    figure(2);
    legend_Tags=cell(1,size(result,2));
    for trial=1:size(result,2)
        legend_Tags{1,trial}=['Test ',num2str(trial)];
        figure(1);
        plot(result(1,trial).T(:,1),result(1,trial).T(:,2),'LineWidth',2);
        hold on
        figure(2);
        plot(result(1,trial).P(:,1),result(1,trial).P(:,2),'LineWidth',2);
        hold on
    end

    figure(1);
    xlabel('F0百分比');
    ylabel('反应曲线');
    title(['被试',num2str(par_num),' 声调判断个体化range选取']);
    %plot(Di_Tx,Di_Ty,'b--');
    plot(Di_Tx_adjust,Di_Ty_adjust,'r--');
    legend([legend_Tags,{'校正后Discrim'}]);
    plot([result(1,end).T(1,1) result(1,end).T(1,1)],[0 1],'k--');
    plot([result(1,end).T(end,1) result(1,end).T(end,1)],[0 1],'k--');

    figure(2);
    xlabel('VOT百分比');
    ylabel('反应曲线');
    title(['被试',num2str(par_num),' 音位判断个体化range选取']);
    %plot(Di_Px,Di_Py,'b--');
    plot(Di_Px_adjust,Di_Py_adjust,'r--');
    legend([legend_Tags,{'校正后Discrim'}]);
    plot([result(1,end).P(1,1) result(1,end).P(1,1)],[0 1],'k--');
    plot([result(1,end).P(end,1) result(1,end).P(end,1)],[0 1],'k--');
    
    saveas(figure(1),['./result_plots/No_',num2str(par_num),'_T_adjust_',strrep(strrep(strrep(datestr(now),':','_'),' ','_'),'-','_'),'.png'])
    saveas(figure(2),['./result_plots/No_',num2str(par_num),'_P_adjust_',strrep(strrep(strrep(datestr(now),':','_'),' ','_'),'-','_'),'.png'])
    
    clear adjust_range_test_result
    close all
 end
