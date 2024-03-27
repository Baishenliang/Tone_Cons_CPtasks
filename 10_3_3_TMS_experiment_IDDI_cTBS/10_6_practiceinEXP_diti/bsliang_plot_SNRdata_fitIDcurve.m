function [ID_fitlst,slope,width]=bsliang_plot_SNRdata_fitIDcurve(rawdata,step_num,xsteps,getslopemethod,fitmode,fit_function)
    %fitmode: '_slopecurve_'(calculate the slope curve),'_IDcurve_'(calculate the ID curve)
    %fit_function: '_pku_'(PKU least squares method) '_YQ_'(Genealized Linear Model )
    ID_lst=zeros(1,step_num);
    n=ID_lst;
    width=[];
    for step=1:step_num
        n(1,step)=sum(rawdata(:,1)==step);
        %ID_lst(1,step)=n(1,step)-sum(rawdata(rawdata(:,1)==step,2));
        ID_lst(1,step)=sum(rawdata(rawdata(:,1)==step,2));
    end
    s=linspace(xsteps(1),xsteps(end),100);
    %s=0:100;
    if isequal(fit_function,'_YQ_')
        beta = glmfit(xsteps,[ID_lst' n'],'binomial');
        %ID_fitlst = glmval(beta,xsteps,'logit','size',n)'./n;
        ID_fitlst = glmval(beta,xsteps,'logit','size',n)'./n;
        width = (log(0.25/(1-0.25))-beta(1))/beta(2)-(log(0.75/(1-0.75))-beta(1))/beta(2);
        ID_fitlst=ID_fitlst';
        beta = beta(2);
        %plot(xsteps, ID_lst./n,'o',xsteps,ID_fitlst,'-','LineWidth',2)
    elseif isequal(fit_function,'_pku_')
        a0=[0 -5 (xsteps(1)+xsteps(end))/2]; % �ؾ�Ϊ0�����ֵΪ1��б��Ϊ-1�����ĵ����Ϊ2.5
        [beta,~,~,~,~] = lsqcurvefit(@lsfit_sammler,a0,xsteps,ID_lst./n);
        
        ID_fitlst=beta(1)+1./(1+exp(-beta(2)*(s-beta(3))));
        
        yyy = @(xx)(beta(1)+1./(1+exp(-beta(2)*(xx-beta(3))))-0.75);
        options = optimset('TolX',0.00001);
        xx_75=fzero(yyy,xsteps(1),options);
        
        yyy = @(xx)(beta(1)+1./(1+exp(-beta(2)*(xx-beta(3))))-0.25);
        options = optimset('TolX',0.00001);
        xx_25=fzero(yyy,xsteps(end),options);
        
        width = xx_25-xx_75;
        
        beta = beta(2); %beta(1)�ǲ��ǲ��������Ľؾ��ؿ���ʽ�ǵģ�����֪�������ǲ��������
        ID_fitlst = ID_fitlst';
    end
    if isequal(fitmode,'_slopecurve_')
        ID_fitlst = diff(ID_fitlst);
    end
    %��б�ʣ�
    if isequal(getslopemethod,'beta_log10')
        %����һ��ֱ�Ӵ�ϵ����ó�б�ʣ��ŵ㣺��ѧ���Ͻ���ȱ�㣺��ͻȻ�ɵ�300��
        slope=beta;
    %         %ȱ���������һ��ȡ��������֪���������ɲ���ѧ��
        slope=log10(slope);
        if slope<0
            slope=nan;
        end
    elseif isequal(getslopemethod,'beta_100out')
        %����һ��ֱ�Ӵ�ϵ����ó�б�ʣ��ŵ㣺��ѧ���Ͻ���ȱ�㣺��ͻȻ�ɵ�300��
        slope=beta;
%         %ȱ��������������޳�����100��ֵ����֪����ô���ɲ���ѧ��
        if slope>100
            slope=nan;
        end
    elseif isequal(getslopemethod,'diff')
        %��������ͨ�������е�б�ʣ��ŵ㣺ֱ�ӣ�ȱ�㣺ֻ���е㣬���Ͻ���
        slope_dif=diff(ID_fitlst);
        slope=mean([slope_dif(floor((1+end)/2)),slope_dif(ceil((1+end)/2))]);
    end
