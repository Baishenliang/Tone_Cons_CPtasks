%**************************************************************************
% 本程序可完成利用Psychometric function计算域值的数据批处理,并可绘制Psychometric function拟和曲线
%**************************************************************************
% 版权属于北京大学听觉与视觉国家重点实验室
%**************************************************************************
function [xs]=bsliang_getfivesteps_phyisometrix_perc(xs_org,resp_org,fig_nameTag,no_steps)
%options = optimset('LargeScale','off','LevenbergMarquardt','on');
x=xs_org; 

sub=resp_org;

result=[0 0];
k=0;
k=k+1;
y=sub;
a0=[0.1,-8];
[a,resnorm,residual,exitflag,output] = lsqcurvefit(@myfun,a0,x,y);

i=1;

%**************************************************************************
%绘制数据的拟和曲线
%**************************************************************************
s=0:1:100;
F{i,k}=100./(1+exp(-a(1)*(s-a(2))));

fs_5=@(s)(100./(1+exp(-a(1)*(s-a(2))))-5);
step_one_x=fzero(fs_5,0);

fs_95=@(s)(100./(1+exp(-a(1)*(s-a(2))))-95);
step_seven_x=fzero(fs_95,0);

expand_k=1/2; %扩展系数：确定range后扩展一下，以保证被试曲线的完整

if step_one_x-abs(step_seven_x-step_one_x)*expand_k>0.0385 %(2-1)/(27-1)=0.0385
    xs=linspace(step_one_x-abs(step_seven_x-step_one_x)*expand_k,step_seven_x+abs(step_seven_x-step_one_x)*expand_k,no_steps+1);
else
    xs=linspace(0.0385,step_seven_x+abs(step_seven_x-step_one_x)*expand_k,no_steps+1);
end
    %[20190810试验性：新合成的xs往左右分别扩展两个steps，确保被试能判断更多的两端，数值需要慢慢调整]；
ys=100./(1+exp(-a(1)*(xs-a(2))));
% xs=zeros(1,length(seven_steps));
% for s_step=1:length(seven_steps)
%     xs(s_step)=fzero(@(s)(100./(1+exp(-a(1)*(s-a(2))))-seven_steps(s_step)),0);
% end
%subplot(3,4,i);
%hold on
outFig=figure(1);
plot(x,y,'ko');
old_tag='_';
new_tag=' ';
title(strrep(fig_nameTag(18:end-4),old_tag,new_tag));
hold on;
plot(xs,ys,'*');
plot(xs,0,'ro');
plot(0,ys,'ro');
plot(s,F{i,k});
xlabel('Steps');
ylabel('Rates');
saveas(outFig,fig_nameTag);
close(outFig);
%axis([0:1:178]);
%hold off
%**************************************************************************
%拟和后的域值结果,result第二列对应每个被试每个条件的域值,第一列对应和域值点斜率有关的量
%**************************************************************************
result=[result;a];