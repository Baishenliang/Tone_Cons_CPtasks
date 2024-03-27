%**************************************************************************
% ��������������Psychometric function������ֵ������������,���ɻ���Psychometric function�������
%**************************************************************************
% ��Ȩ���ڱ�����ѧ�������Ӿ������ص�ʵ����
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
%�������ݵ��������
%**************************************************************************
s=0:1:100;
F{i,k}=100./(1+exp(-a(1)*(s-a(2))));

fs_5=@(s)(100./(1+exp(-a(1)*(s-a(2))))-5);
step_one_x=fzero(fs_5,0);

fs_95=@(s)(100./(1+exp(-a(1)*(s-a(2))))-95);
step_seven_x=fzero(fs_95,0);

expand_k=1/2; %��չϵ����ȷ��range����չһ�£��Ա�֤�������ߵ�����

if step_one_x-abs(step_seven_x-step_one_x)*expand_k>0.0385 %(2-1)/(27-1)=0.0385
    xs=linspace(step_one_x-abs(step_seven_x-step_one_x)*expand_k,step_seven_x+abs(step_seven_x-step_one_x)*expand_k,no_steps+1);
else
    xs=linspace(0.0385,step_seven_x+abs(step_seven_x-step_one_x)*expand_k,no_steps+1);
end
    %[20190810�����ԣ��ºϳɵ�xs�����ҷֱ���չ����steps��ȷ���������жϸ�������ˣ���ֵ��Ҫ��������]��
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
%��ͺ����ֵ���,result�ڶ��ж�Ӧÿ������ÿ����������ֵ,��һ�ж�Ӧ����ֵ��б���йص���
%**************************************************************************
result=[result;a];