function xvars=bsliang_adjust_getcurvPerc_LOGISTIC(stim_mat,no_steps,raw,TITLE,par_code)
%% �µ�����廯range�Ĵ��룬����logistic��ϣ����ӿ��ǵ����Ե������ж����
     stim_perc=stim_mat(1,:); % ÿ��step�Ĵ̼��ٷֵ�
     resp_perc=stim_mat(2,:); % ÿ��step��ƽ����ȷ��
     stim_steps=raw(:,1); % ԭʼ���ݵ�steps�б�
     stim_resps=1-raw(:,2); % ԭʼ���ݵķ�Ӧ�б�
     
     no_steps_dfrange=max(stim_steps);

     %% �������
     bsliang=@(paras,X) 0+(1-0)./(1+exp(-1*paras(1)*(X-paras(2))));
     paras = lsqcurvefit(bsliang,[1 (1+no_steps_dfrange)/2],stim_steps,stim_resps);
     
     %% ���л�ͼ��ѡȡrange
     figure;
     X=0:0.01:no_steps_dfrange+1;
     Y=0+(1-0)./(1+exp(-1*paras(1)*(X-paras(2))));
     plot(X,Y);
     hold on
     plot(1:no_steps_dfrange,resp_perc,'ko');
     title(TITLE);
     %JUST A TEST: find thresholds
%      Ya=0+(1-0)./(1+exp(-1*paras(1)*(1-paras(2))));
%      Yb=0+(1-0)./(1+exp(-1*paras(1)*(8-paras(2))));
    % We can see that 98% is an appropriate threshold
    
    criteria=0.02;
    options = optimset('TolX',0.00001);
%     Fa=@(X)bsliang(paras,X)-criteria;
%     Xa=fzero(Fa,0,options);
     Xa=1; %֮ǰ�Ĺ涨���ñ��Ե�Xa=1�����Һ����ʵ���ȷ���ֲ��ܸ��ݱ������ߵ�Xa�����Ի���ú�ģ�������Ǹ���anyway
    Fb=@(X)bsliang(paras,X)-(1-criteria);
    Xb=fzero(Fb,1,options);
    plot([Xa Xb],[bsliang(paras,Xa) bsliang(paras,Xb)],'r*');
    
    % �ֶ�����ǰ��߽�
    is_manualADJ_Xa=input('�Ƿ��ֶ�����ǰ(Xa)�߽磿 1-�� 0-��');
    if is_manualADJ_Xa
        Xa=input('������Xa(��λ��step)��');
    end
    is_manualADJ_Xb=input('�Ƿ��ֶ�����ǰ(Xb)�߽磿 1-�� 0-��');
    if is_manualADJ_Xb
        Xb=input('������Xb(��λ��step)��');
    end
    plot([Xa Xb],[bsliang(paras,Xa) bsliang(paras,Xb)],'m+');
    saveas(figure(1),['./result_plots/RANGE_No_',num2str(par_code),'_',strrep(strrep(strrep(datestr(now),':','_'),' ','_'),'-','_'),'.png']);
    close all
    
    %% ת��Ϊ�ٷ�λ
    paras=polyfit(1:no_steps_dfrange,stim_perc,1);
    bsliang_perc=@(X)paras(1)*X+paras(2);
    xvars=linspace(bsliang_perc(Xa),bsliang_perc(Xb),no_steps);
     