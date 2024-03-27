function [DIFF_ACC,DIFF_RT]=bsliang_Prof_Xu_Index(rawdata,edg_steps)

    % edg_steps = [1 5] 就是开始和结束的两个点
    
    Ledg_raw = zeros(size(rawdata,1),size(rawdata,2));
    Redg_raw = Ledg_raw;
    
    
%     老版本：1step或5step后面的所有trials（直到下一个1step或5step出现）都要
%     INTedge = 0; %最近经历的边界
%     for step = 1:size(rawdata,1)
%         if rawdata(step,1) == edg_steps(1)
%             INTedge = edg_steps(1);
%             Ledg_raw(step,:) = rawdata(step,:);
%         elseif rawdata(step,1) == edg_steps(end)
%             INTedge = edg_steps(end);
%             Redg_raw(step,:) = rawdata(step,:);
%         elseif INTedge == edg_steps(1)
%             Ledg_raw(step,:) = rawdata(step,:);
%         elseif INTedge == edg_steps(end)
%             Redg_raw(step,:) = rawdata(step,:);
%         end
%     end

%     新版本1：1step或5step后面只要紧跟着是step3的trial
%     for step = 1:size(rawdata,1)
%         if rawdata(step,1) == edg_steps(1) && rawdata(step+1,1) == (edg_steps(1) + edg_steps(end))/2
%             %Ledg_raw(step,:) = rawdata(step,:);
%             Ledg_raw(step+1,:) = rawdata(step+1,:);
%         elseif rawdata(step,1) == edg_steps(end) && rawdata(step+1,1) == (edg_steps(1) + edg_steps(end))/2
%             %Redg_raw(step,:) = rawdata(step,:);
%             Redg_raw(step+1,:) = rawdata(step+1,:);
%         end
%     end
    
    %     新版本2：（由于有的被试新版本1满足的trials一个都没有）1step或5step后面只要紧跟着不是step5或step1的trial
    for step = 1:size(rawdata,1)-1
        if rawdata(step,1) == edg_steps(1) && rawdata(step+1,1) ~= edg_steps(1) && rawdata(step+1,1) ~= edg_steps(end)
            %Ledg_raw(step,:) = rawdata(step,:);
            Ledg_raw(step+1,:) = rawdata(step+1,:);
        elseif rawdata(step,1) == edg_steps(end) && rawdata(step+1,1) ~= edg_steps(1) && rawdata(step+1,1) ~= edg_steps(end)
            %Redg_raw(step,:) = rawdata(step,:);
            Redg_raw(step+1,:) = rawdata(step+1,:);
        end
    end

   Ledg_raw = Ledg_raw(Ledg_raw(:,1)>0,:);
%    if isempty(Ledg_raw)
%        disp('Ledg_raw is empty');
%    end
   Redg_raw = Redg_raw(Redg_raw(:,1)>0,:);
%    if isempty(Redg_raw)
%        disp('Redg_raw is empty');
%    end   
%    

   [~,ID_lst_left]=bsliang_getRTlst(Ledg_raw(:,1),Ledg_raw(:,2));
   [~,ID_lst_right]=bsliang_getRTlst(Redg_raw(:,1),Redg_raw(:,2));
   [~,ID_lst_left_RT]=bsliang_getRTlst(Ledg_raw(:,1),Ledg_raw(:,3));
   [~,ID_lst_right_RT]=bsliang_getRTlst(Redg_raw(:,1),Redg_raw(:,3));
   
   Ledg_ACC = mean(ID_lst_left);
   Ledg_RT = mean(ID_lst_left_RT);
   
   Redg_ACC = mean(ID_lst_right);
   Redg_RT = mean(ID_lst_right_RT);  
   
   DIFF_ACC = Ledg_ACC - Redg_ACC;
   DIFF_RT = Ledg_RT - Redg_RT;

   
   % 下面开始钻研数据
   