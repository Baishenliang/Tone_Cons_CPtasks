function [RT_lst,RT_diff]=bsliang_plot_SNRdata_RT(rawdata,step_num)
    RT_lst=zeros(1,step_num);
    for step=1:step_num
        RT_lst(1,step)=mean(rawdata(rawdata(:,1)==step,3));
    end
    %RT_diff=RT_lst(1,ceil(step_num/2))-mean(RT_lst(1,[1:floor(step_num/2),floor(step_num/2)+2:end]));
    RT_diff=RT_lst(1,ceil(step_num/2))-mean(RT_lst(1,[1 end]));