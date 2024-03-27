function [Exp_group,non_Exp_group]=bsliang_getPTvalue(num)
    % 这个函数用于行为identification的log文本的stim的顺序，将数字分成实验的step和正交的step
    N_lst=[repmat(1:7,1,7);sort(repmat(1:7,1,7))];
    Exp_group=N_lst(1,num);
    non_Exp_group=N_lst(2,num);