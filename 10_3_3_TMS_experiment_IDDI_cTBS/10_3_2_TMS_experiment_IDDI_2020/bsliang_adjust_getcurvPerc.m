function xvars=bsliang_adjust_getcurvPerc(stim_mat,no_steps)
% stim_mat = [xvars;yvars], ��һ����x���꣨�̼��ٷֱ��У����ڶ���y���꣨���Է�Ӧ�У�
% ���������Ŀ������Ѱ���������˵�0��1�㣬���д̼��ϳɡ�������ߵ�0�㲻�ڷ�Χ�ڣ���ȡstep1��1��ͬ��
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
%      %[20191006����]
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
 