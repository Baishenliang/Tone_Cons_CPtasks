function xvars=bsliang_adjust_getcurvPerc_LOGISTIC(stim_mat,no_steps,raw,TITLE,par_code)
%% 新的求个体化range的代码，采用logistic拟合，更加考虑到被试的所有判断情况
     stim_perc=stim_mat(1,:); % 每个step的刺激百分点
     resp_perc=stim_mat(2,:); % 每个step的平均正确率
     stim_steps=raw(:,1); % 原始数据的steps列表
     stim_resps=1-raw(:,2); % 原始数据的反应列表
     
     no_steps_dfrange=max(stim_steps);

     %% 进行拟合
     bsliang=@(paras,X) 0+(1-0)./(1+exp(-1*paras(1)*(X-paras(2))));
     paras = lsqcurvefit(bsliang,[1 (1+no_steps_dfrange)/2],stim_steps,stim_resps);
     
     %% 进行画图和选取range
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
     Xa=1; %之前的规定是让被试的Xa=1，而且后面的实验的确发现不能根据被试曲线调Xa，被试会觉得很模糊，这是个迷anyway
    Fb=@(X)bsliang(paras,X)-(1-criteria);
    Xb=fzero(Fb,1,options);
    plot([Xa Xb],[bsliang(paras,Xa) bsliang(paras,Xb)],'r*');
    
    % 手动调整前后边界
    is_manualADJ_Xa=input('是否手动调节前(Xa)边界？ 1-是 0-否');
    if is_manualADJ_Xa
        Xa=input('请输入Xa(单位：step)：');
    end
    is_manualADJ_Xb=input('是否手动调节前(Xb)边界？ 1-是 0-否');
    if is_manualADJ_Xb
        Xb=input('请输入Xb(单位：step)：');
    end
    plot([Xa Xb],[bsliang(paras,Xa) bsliang(paras,Xb)],'m+');
    saveas(figure(1),['./result_plots/RANGE_No_',num2str(par_code),'_',strrep(strrep(strrep(datestr(now),':','_'),' ','_'),'-','_'),'.png']);
    close all
    
    %% 转换为百分位
    paras=polyfit(1:no_steps_dfrange,stim_perc,1);
    bsliang_perc=@(X)paras(1)*X+paras(2);
    xvars=linspace(bsliang_perc(Xa),bsliang_perc(Xb),no_steps);
     