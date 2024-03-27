function [min_lst,min_ind_lst]=bsliang_multimin(list)
    %求出数列的所有最小值及位置
    [min_temp,ind_temp]=min(list);
    min_lst=min_temp;
    min_ind_lst=ind_temp;
    list(ind_temp)=max(list);
    for i=2:length(list)
        [min_temp,ind_temp]=min(list);
        if min_temp==min_lst(end)
            min_ind_lst=[min_ind_lst,ind_temp];
        end
        list(ind_temp)=max(list);
    end