function [Exp_group,non_Exp_group]=bsliang_getPTvalue(num)
    % �������������Ϊidentification��log�ı���stim��˳�򣬽����ֳַ�ʵ���step��������step
    N_lst=[repmat(1:7,1,7);sort(repmat(1:7,1,7))];
    Exp_group=N_lst(1,num);
    non_Exp_group=N_lst(2,num);