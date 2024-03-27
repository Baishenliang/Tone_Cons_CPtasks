function xvars=bsliang_adjust_getcurvPerc(stim_mat,no_steps)
% stim_mat = [xvars;yvars], 第一行是x坐标（刺激百分比列），第二行y坐标（被试反应列）
% 整个程序的目的在于寻找曲线两端的0和1点，进行刺激合成。如果曲线的0点不在范围内，则取step1，1点同理。
 stim_perc=stim_mat(1,:);
 resp_perc=stim_mat(2,:);
 
 end_index=zeros(1,2);
 zero_index=resp_perc==0;
 one_index=resp_perc==1;
 %
 end_index(1)=1; %[20191006]
%  if sum(zero_index)==0
%      end_index(1)=1;
%  else
%      %end_index(1)=find(zero_index,1,'last');
%      %[20191006增加]
%      end_index(1)=find(zero_index,1,'last')-1;
%      if end_index(1)<=0
%          end_index(1)=1;
%      end
%  end
 %
 if sum(one_index)==0
    end_index(2)=length(resp_perc);
 else
    end_index(2)=find(one_index,1,'first');
 end
 
 xvars=linspace(stim_perc(end_index(1)),stim_perc(end_index(2)),no_steps);
 %out.yvars=linspace(resp_perc(end_index(1)),resp_perc(end_index(2)),no_steps);
 