function [step_lst,RT_lst]=bsliang_getRTlst(steps,RTs)
% get mean value of reaction times for each Id step
    step_lst=unique(steps);
    RT_lst=zeros(1,length(step_lst));
    for step=1:length(step_lst)
        RT_lst(step)=mean(RTs(steps==step_lst(step)));
    end