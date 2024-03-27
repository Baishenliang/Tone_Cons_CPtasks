function [AREAS_2,SLOPES_2,Prof_Xu_Index_2,DATA_avg,index_mat_2,DATA_avgRT_2]=bsliang_TMSIDDI_results(SUBJ_lst,fitmode,fit_function,ORDER_RESULT,select_in_dispord,select_in_storord,isplot,RT_mean_mid)
    %fitmode: '_slopecurve_'(calculate the slope curve),'_IDcurve_'(calculate the ID curve)
    %fit_function: '_pku_'(PKU least squares method) '_YQ_'(Genealized Linear Model )
    %ORDER_RESULT: 1: test ORDER EFFECTS (only for sham), 2: get RESULTS, 3: get Larynx/Tongue TMS ORDER EFFECTS (within the first 10mins after rTMS or Sham)
    %select: ����turn˳��ЧӦ��[2 4]Ϊsham��[1 3]ΪrTMS
    % select_in_dispord�� ѡ����������turns������˳��
    % select_in_storord�� ѡ����������turns������˳��
    % isplot���Ƿ�Ҫ��ͼ
    % RT_mean_mid�������ӦʱTMS-Sham��ʱ�����������ֵ�ľ�ֵ(1)����������е㣨2������ģ���㣩��ֵ��
        
    %isplot:
    
    %�����
    %AREAS_2=area under curve (��fitmode=slopecurve)
    %SLOPES_2=position of max slope (��fitmode=slopecurve)
    %Prof_Xu_Index_2=Prof. Ninglong Xu's index (��fitmode=IDcurve)
    %DATA_avg=individualized averaged reaction time
    %index_mat_2=the first four columns are slopes for Identification
    %            curves, the last four columns are ID peaks (between-within) for Discrimination curves (��fitmode=IDcurve)   
    %DATA_avgRT_2=RT pooled for all conditions, RT for tone ID, and RT for phoneme ID. 
    
%   stimSITE   NUMBER
%       L        1
%       S1       2
%       T        3
%       S2       4

%   Id_Di	BLOCK	NAME        NUMBER
%   Id      A       T_CLEAR_ID      1
%   Id      B       P_CLEAR_ID      2
%   Id      C       T_NOISE_ID      3
%   Id      D       P_NOISE_ID      4
%    Di     A       T_CLEAR_DI      5
%    Di     B       P_CLEAR_DI      6
%    Di     C       T_NOISE_DI      7
%    Di     D       P_NOISE_DI      7

xtick={'L','S1','T','S2'};

load('DATA.mat');

block_labels={'T CLEAR ID','P CLEAR ID','T NOISE ID','P NOISE ID','T CLEAR DI','P CLEAR DI','T NOISE DI','P NOISE DI'};
index_mat=cell(4,8);
RT_raw=cell(1,8);
RT_subjAVG=RT_raw;
index_mat_avg=zeros(4,4);
AREAS=cell(4,4); %����slope���߰�Χ�����
SLOPES=AREAS; %����slope
Prof_Xu_Index=AREAS; %��������ʦ��Ϊ������е�����ʧ�ˣ���ô�����ж�ģ��trial�ͻᱻ֮ǰ������trial��ƫ��������Ǵ��桰��ƫ�ȡ���Ҳ����ǰһ��������������������trial������ģ��trial�жϷ���֮�
 
%for ORDER_RESULT = 3 % 1: test ORDER EFFECTS (only for sham), 2: get RESULTS, 3: get Larynx/Tongue TMS ORDER EFFECTS (within the first 10mins after rTMS or Sham)
    for ACC_RT=1:2 %(1: ACC, 2: RT)
        DATA_avg=cell(4,8); % Row: L S1 T S2; Column: Conditions
        DATA_avg_3=DATA_avg;

       %% ����ͼ��turn˳��ЧӦ�����н�����Լ�block��˳��ЧӦ
            %subj data
            %step1����Ϊ���ߣ�ID��DI����ƽ��ֵ
            if isplot
                figure
            end
            for subj=SUBJ_lst
                
                % =============================   �����ռ䣺Ҫ�޸�ʲô�����������������   ==================
                if ORDER_RESULT == 1
                    [block_orders,turn_orders]=bsliang_getindorder(subj);
                    turn_indices = bsliang_select_turns(turn_orders,select_in_dispord,select_in_storord,'_and_');%����������ѡ���ų�
                    %turn_indices=turn_orders(2:4); %����ʱ��˳����ѡ������
                elseif ORDER_RESULT == 2
                    [~,turn_orders]=bsliang_getindorder(subj);
                    turn_indices=1:4; % ���մ���˳��
                    %turn_indices=turn_orders(3:4); %���ճ���˳��
                elseif ORDER_RESULT == 3
                    [block_orders,turn_orders]=bsliang_getindorder(subj);
                    turn_indices=1:4;
                end
                
                if ~isempty(turn_indices)
                    for turn_index=turn_indices
                        if ORDER_RESULT == 1 || ORDER_RESULT == 2
                            block_indices=1:8; % ��ȫ
                            %block_indices=block_orders(turn_orders==turn_index,1:4);%��ǰ���10min��һ�룩��blocks
                        elseif ORDER_RESULT == 3
                            block_indices=block_orders(turn_orders==turn_index,1:4);%��ǰ���10min��һ�룩��blocks
                        end
                   %=============================================================================================


                        try
                            for block_index=block_indices
                               if ACC_RT==1
                                    data_temp=DATA(subj).Id_Di.data(1,block_index,turn_index).half_threshold(:,end);
                                    data_temp_raw=DATA(subj).Id_Di.data(1,block_index,turn_index).rawdata;

                                    %�������ID��slope��DI��peak������slope curve
                                    %AUC��Ѱ��б�����㣬������������ʦ����

                                    if ORDER_RESULT == 2 || ORDER_RESULT == 3
                                        %��������н���ǣ�turn��block��˳����Ǵ���˳��
                                        turn_index_p = turn_index;
                                        block_index_p = block_index;
                                    elseif ORDER_RESULT == 1
                                        %������turn˳��ЧӦʱ��turn��˳��Ϊ����˳������ÿ�μ����turn���ǳ��ֵڼ���turn
                                        turn_index_p = find(turn_orders==turn_index); %Ѱ����������turnʵ�����ǵڼ������ֵ�
                                        block_index_p = block_index;
                                    end
                                    if block_index<=4 % ID
                                        [data_temp,b_tmp]=bsliang_plot_SNRdata_fitIDcurve(data_temp_raw,5,1:5,'beta_100out',fitmode,fit_function); %�������
                                        %if abs(b_tmp(2))<10 %ɸѡslope
                                            index_mat{turn_index_p,block_index_p}=[index_mat{turn_index_p,block_index_p};abs(b_tmp)];
                                        %end
                                        AREAS{turn_index_p,block_index_p}=[AREAS{turn_index_p,block_index_p};polyarea([1 1:length(data_temp) length(data_temp)],[0 data_temp' 0])];
                                        %SLOPES{turn_index_p,block_index_p}=[SLOPES{turn_index_p,block_index_p};abs(b_tmp)];
                                        jjj=find(data_temp==min(data_temp));
                                        SLOPES{turn_index_p,block_index_p}=[SLOPES{turn_index_p,block_index_p};mean(jjj)];
                                        [Prof_Xu_Index_t,~]=bsliang_Prof_Xu_Index(data_temp_raw,[1 5]);
                                        Prof_Xu_Index{turn_index_p,block_index_p}=[Prof_Xu_Index{turn_index_p,block_index_p};Prof_Xu_Index_t];
                                            %

                                    else
                                        D_tmp=data_temp(2)-(data_temp(1)+data_temp(3))/2;
                                        index_mat{turn_index_p,block_index_p}=[index_mat{turn_index_p,block_index_p};D_tmp];
                                    end

                               else
                                    steps_tmp=DATA(subj).Id_Di.data(1,block_index,turn_index).rawdata(:,1);
                                    RTs_tmp=DATA(subj).Id_Di.data(1,block_index,turn_index).rawdata(:,3);
                                    [~,data_temp]=bsliang_getRTlst(steps_tmp,RTs_tmp);
                                    data_temp=data_temp';
                               end

                               if ORDER_RESULT == 1
                                   %��ʱ����ƽ������˳����turn����˳��block����˳��
                                    DATA_avg{turn_orders==turn_index,block_index}=[DATA_avg{turn_orders==turn_index,block_index};data_temp'];
                                    if RT_mean_mid==1
                                        DATA_avg_3{turn_orders==turn_index,block_index}=[DATA_avg_3{turn_orders==turn_index,block_index};mean(data_temp)];
                                    elseif RT_mean_mid==2
                                        DATA_avg_3{turn_orders==turn_index,block_index}=[DATA_avg_3{turn_orders==turn_index,block_index};data_temp(3)-mean([data_temp(1),data_temp(2),data_temp(4),data_temp(5)])];
                                    end
                                    
                                    [~,lin_cor]=bsliang_TMSIDDI_order_plot_para(0,turn_index,turn_orders);
                                    if isplot
                                        subplot(1,8,block_index);
                                    end
                               elseif ORDER_RESULT == 2 || ORDER_RESULT == 3
                                   %��ʱ����ƽ������˳����turn����˳��block����˳��
                                    DATA_avg{turn_index,block_index}=[DATA_avg{turn_index,block_index};data_temp'];
                                    [subplot_add,lin_cor]=bsliang_TMSIDDI_results_plot_para(0,turn_index);
                                    if isplot
                                        subplot(2,8,subplot_add+block_index);
                                    end
                               end

                                if isplot
                                   hold on
                                   plot(data_temp,'Color',lin_cor);
                                   title(block_labels{block_index});
                                   if ACC_RT==1
                                       if block_index<=4
                                           if isequal(fitmode,'_IDcurve_')
                                                ylim([0 1])
                                           elseif isequal(fitmode,'_slopecurve_')
                                                ylim([-0.05 0]);
                                           end
                                       else
                                           ylim([0 2]);
                                       end
                                   else
                                       if block_index<=4
                                           ylim([0 1.4]);
                                       else
                                           ylim([1 2.8]);
                                       end
                                   end
                                end
                            end
                        catch
                        end
                    end
                end
            end

            DATA_RT_2=DATA_avg;
            %compute average
            for turn_index=1:4
                %������˳���ʱ��turn_index��ʵ����sham���ֵ�˳��λ�ã�������sham�����ĸ�turn
                for block_index=1:8
                    DATA_RT_2{turn_index,block_index}=mean(DATA_avg{turn_index,block_index},1);
                    index_mat_avg(turn_index,block_index)=mean(index_mat{turn_index,block_index});

                       if ORDER_RESULT == 1
                            [~,lin_cor]=bsliang_TMSIDDI_order_plot_para(1,turn_index,turn_orders);
                            if isplot
                                subplot(1,8,block_index);
                            end
                       elseif ORDER_RESULT == 2 || ORDER_RESULT == 3
                            [subplot_add,lin_cor]=bsliang_TMSIDDI_results_plot_para(1,turn_index);
                            if isplot
                                subplot(2,8,subplot_add+block_index);
                            end
                       end

                     
                     if isplot
                         hold on
                        plot(DATA_RT_2{turn_index,block_index},'Color',lin_cor);
                     end
                end
            end

        %% step2���ڹ۲�slope���ߵ������л����߰�Χ�����������б�����ĵ�
        AREAS_2=cell(1,5);
        SLOPES_2=cell(1,5);
        Prof_Xu_Index_2=cell(1,5);
        index_mat_2=cell(1,5);
        DATA_avgRT_2=cell(1,5);

        for block_index=1:4
                
            if ORDER_RESULT == 1 % test ORDER EFFECTS [20191112:���ݶ���ʦ��Ҫ�󣬿�sham��rTMS����ϰЧӦ��Ҫ����������pool��һ��]
                
                %block������˳���block��ָÿ��������
                %turn������˳���turn��ָÿ��position��
                %area_temp��ÿ��ѭ��֮�����һ��block����turn������
                
                %[20191112Ҳ���Կ���������������ϰЧӦ��������]
                area_tmp=bsliang_fillmatrixgap({AREAS{1,block_index},AREAS{2,block_index},AREAS{3,block_index},AREAS{4,block_index}});
                slopes_tmp=bsliang_fillmatrixgap({SLOPES{1,block_index},SLOPES{2,block_index},SLOPES{3,block_index},SLOPES{4,block_index}});
                prof_xu_index_tmp=bsliang_fillmatrixgap({Prof_Xu_Index{1,block_index},Prof_Xu_Index{2,block_index},Prof_Xu_Index{3,block_index},Prof_Xu_Index{4,block_index}});
                index_mat_tmp=bsliang_fillmatrixgap({index_mat{1,block_index+4},index_mat{2,block_index+4},index_mat{3,block_index+4},index_mat{4,block_index+4}});
                DATA_avgRT_2_tmp=bsliang_fillmatrixgap({DATA_avg_3{1,block_index},DATA_avg_3{2,block_index},DATA_avg_3{3,block_index},DATA_avg_3{4,block_index}});
                
                % ͼ1����������pool
                AREAS_2{1,1}=[AREAS_2{1,1};area_tmp];
                SLOPES_2{1,1}=[SLOPES_2{1,1};slopes_tmp];
                Prof_Xu_Index_2{1,1}=[Prof_Xu_Index_2{1,1};prof_xu_index_tmp];
                index_mat_2{1,1}=[index_mat_2{1,1};index_mat_tmp];
                DATA_avgRT_2{1,1}=[DATA_avgRT_2{1,1};DATA_avgRT_2_tmp];
                
                if  block_index == 1 % Tone Clear
                    DLS_index=2;
                elseif block_index == 2 % Phon Clear
                    DLS_index=3;
                elseif block_index == 3   % Tone Noise
                    DLS_index=4;
                elseif block_index == 4   % Phon Noise
                    DLS_index=5;
                end
                
                % ͼ2/3��tone��phoneme ID
                if isequal(select_in_dispord,1:4)
                     AREAS_2{1,DLS_index}=[AREAS_2{1,DLS_index};bsliang_combinecol(area_tmp)];
                     SLOPES_2{1,DLS_index}=[SLOPES_2{1,DLS_index};bsliang_combinecol(slopes_tmp)];
                     Prof_Xu_Index_2{1,DLS_index}=[Prof_Xu_Index_2{1,DLS_index};bsliang_combinecol(prof_xu_index_tmp)];
                     index_mat_2{1,DLS_index}=[index_mat_2{1,DLS_index};bsliang_combinecol(index_mat_tmp)];
                     DATA_avgRT_2{1,DLS_index}=[DATA_avgRT_2{1,DLS_index};bsliang_combinecol(DATA_avgRT_2_tmp)];
                else
                     AREAS_2{1,DLS_index}=[AREAS_2{1,DLS_index};area_tmp];
                     SLOPES_2{1,DLS_index}=[SLOPES_2{1,DLS_index};slopes_tmp];
                     Prof_Xu_Index_2{1,DLS_index}=[Prof_Xu_Index_2{1,DLS_index};prof_xu_index_tmp];
                     index_mat_2{1,DLS_index}=[index_mat_2{1,DLS_index};index_mat_tmp];
                     DATA_avgRT_2{1,DLS_index}=[DATA_avgRT_2{1,DLS_index};DATA_avgRT_2_tmp];
                end
                
            elseif  ORDER_RESULT == 2 % 2: get RESULTS [20191112:���ݶ���ʦ��Ҫ�󣬿�ԭʼ���ݶԱ�ʱÿ������ĳɼ���ȥsham]
                AREAS_2{1,block_index}=bsliang_fillmatrixgap({AREAS{1,block_index}-AREAS{2,block_index},AREAS{3,block_index}-AREAS{4,block_index}});
                SLOPES_2{1,block_index}=bsliang_fillmatrixgap({SLOPES{1,block_index}-SLOPES{2,block_index},SLOPES{3,block_index}-SLOPES{4,block_index}});
                Prof_Xu_Index_2{1,block_index}=bsliang_fillmatrixgap({Prof_Xu_Index{1,block_index}-Prof_Xu_Index{2,block_index},Prof_Xu_Index{3,block_index}-Prof_Xu_Index{4,block_index}});
                index_mat_2{1,block_index}=bsliang_fillmatrixgap({index_mat{1,block_index+4}-index_mat{2,block_index+4},index_mat{3,block_index+4}-index_mat{4,block_index+4}});
            elseif ORDER_RESULT == 3 % 3: get Larynx/Tongue TMS ORDER EFFECTS (within the first 10mins after rTMS or Sham)
                % [20191112:������ģ�������ǰ�ķ������ֿ�rTMS��sham]
                AREAS_2{1,block_index}=bsliang_fillmatrixgap({AREAS{1,block_index},AREAS{2,block_index},AREAS{3,block_index},AREAS{4,block_index}});
                SLOPES_2{1,block_index}=bsliang_fillmatrixgap({SLOPES{1,block_index},SLOPES{2,block_index},SLOPES{3,block_index},SLOPES{4,block_index}});
                Prof_Xu_Index_2{1,block_index}=bsliang_fillmatrixgap({Prof_Xu_Index{1,block_index},Prof_Xu_Index{2,block_index},Prof_Xu_Index{3,block_index},Prof_Xu_Index{4,block_index}});
                index_mat_2{1,block_index}=bsliang_fillmatrixgap({index_mat{1,block_index+4},index_mat{2,block_index+4},index_mat{3,block_index+4},index_mat{4,block_index+4}});
            end

        end

        if ACC_RT==1 && ORDER_RESULT~=1 && isplot

            if isplot
                figure
            end
            for block_index=1:4 %[20191112�����������ͼ��Ū�ã���ʵ��ŪҲû��ϵ�����Ժ��������ͼ��]
                 if isequal(fitmode,'_slopecurve_')
                        subplot(2,4,block_index);
                        title(['SLOPE AUC' block_labels{block_index}]);
                        boxplot(AREAS_2{1,block_index});
                     if ORDER_RESULT == 2 || ORDER_RESULT == 3
                        set(gca,'XTickLabel',xtick);
                     elseif ORDER_RESULT == 1
                        set(gca,'XTickLabel',{'Pos1','Pos2','Pos3','Pos4'});
                     end               
                     %ylim([20 100]);
                     
                        subplot(2,4,block_index+4);
                     title(['BOUND POS ' block_labels{block_index}]);
                     hold on
                     boxplot(SLOPES_2{1,block_index});
                     if ORDER_RESULT == 2 || ORDER_RESULT == 3
                        set(gca,'XTickLabel',xtick);
                     elseif ORDER_RESULT == 1
                        set(gca,'XTickLabel',{'Pos1','Pos2','Pos3','Pos4'});
                     end  

                elseif isequal(fitmode,'_IDcurve_')
                        subplot(3,4,block_index);
                     title(['PrXu Index ' block_labels{block_index}]);
                     hold on
                     boxplot(Prof_Xu_Index_2{1,block_index});
                     if ORDER_RESULT == 2 || ORDER_RESULT == 3
                        set(gca,'XTickLabel',xtick);
                     elseif ORDER_RESULT == 1
                        set(gca,'XTickLabel',{'Pos1','Pos2','Pos3','Pos4'});
                     end
                     %ylim([0 3]);
                        subplot(3,4,block_index+4);
                     title(['DI PEAK ' block_labels{block_index+4}]);
                     hold on
                     boxplot(index_mat_2{1,block_index});
                     if ORDER_RESULT == 2 || ORDER_RESULT == 3
                        set(gca,'XTickLabel',xtick);
                     elseif ORDER_RESULT == 1
                        set(gca,'XTickLabel',{'Pos1','Pos2','Pos3','Pos4'});
                     end                     
                 end
            end
        end

        %% step3�� ����sham��compare L with T
    %             if isplot
    %                 figure
    %             end
    %     for block_index=1:8
    %          subplot(1,8,block_index);
    %          title(block_labels{block_index});
    %          hold on
    %          plot(DATA_avg{2,block_index},'Color',[0 0.9 0]);
    %          plot(DATA_avg{4,block_index},'Color',[0 0 0.9]);
    %          set(gca,'XTickLabel',xtick);
    %     end

        %% step4��get raw RT data points and plot:
        if ORDER_RESULT == 2 && ACC_RT==2
            for subj=SUBJ_lst
                for block_index=1:8
                    subj_turn1_RT=DATA(subj).Id_Di.data(1,block_index,1).rawdata(:,3);
                    subj_turn2_RT=DATA(subj).Id_Di.data(1,block_index,2).rawdata(:,3);
                    subj_turn3_RT=DATA(subj).Id_Di.data(1,block_index,3).rawdata(:,3);
                    subj_turn4_RT=DATA(subj).Id_Di.data(1,block_index,3).rawdata(:,3);
                    subj_RT=[subj_turn1_RT,subj_turn2_RT,subj_turn3_RT,subj_turn4_RT];
                    subj_RTAVG=mean(subj_RT,1);
                    RT_raw{1,block_index}=[RT_raw{1,block_index};subj_RT];
                    RT_subjAVG{1,block_index}=[RT_subjAVG{1,block_index};subj_RTAVG];
                end
            end
            if isplot
                figure
            end
            for block_index=1:8
                 if isplot
                    subplot(1,8,block_index);
                    title(block_labels{block_index});
                    hold on
                    boxplot(RT_raw{1,block_index});
                    ylim([0 5]);
                    set(gca,'XTickLabel',xtick);
                 end
            end
            if isplot
                figure
            end
            for block_index=1:8
                 if isplot
                    subplot(1,8,block_index);
                     title(block_labels{block_index});
                     hold on
                     boxplot(RT_subjAVG{1,block_index});
                     ylim([0 2.5]);
                     set(gca,'XTickLabel',xtick);
                 end
            end
        end

    end

    %index_mat_avg_out=index_mat_avg([1,3],:)-index_mat_avg([2,4],:);
%end


function [subplot_add,lin_cor]=bsliang_TMSIDDI_results_plot_para(is_avg,turn_index)
    %��ɫ�����������ЧӦ
       if turn_index == 1 || turn_index == 2
           % L and S1
           subplot_add=0;
       else % T and S2
           subplot_add=8;
       end
       if turn_index == 1 || turn_index == 3
           % rTMS conditions
           if ~is_avg
                lin_cor=[0.9 0.75 0.75];
           else
                lin_cor=[1 0 0];
           end
       else % Sham conditions
           if ~is_avg
                lin_cor=[0.8 0.8 0.8];
           else
               lin_cor=[0 0 0];
           end
       end
       
function [subplot_add,lin_cor]=bsliang_TMSIDDI_order_plot_para(is_avg,turn_index,turn_orders)
        %��ɫ��������˳��ЧӦ
       if turn_index == 1 || turn_index == 2
           % S1
           subplot_add=0;
       else % S2
           subplot_add=0;
       end
       if ~is_avg
            turn_position=find(turn_orders==turn_index);
       else
           turn_position=turn_index;
       end
       if turn_position == 1
           % 1: ��
               if ~is_avg
                    lin_cor=[0.9 0.75 0.75];
               else
                    lin_cor=[1 0 0];
               end
       elseif turn_position == 2
           % 2: ��
               if ~is_avg
                    lin_cor=[0.75 0.9 0.75];
               else
                    lin_cor=[0 1 0];
               end
       elseif turn_position == 3
           % 3: ��
               if ~is_avg
                    lin_cor=[0.75 0.75 0.9];
               else
                    lin_cor=[0 0 1];
               end
       elseif turn_position == 4
           % 4: ��
               if ~is_avg
                    lin_cor=[0.8 0.8 0.8];
               else
                    lin_cor=[0 0 0];
               end
       end
       
function out=bsliang_combinecol(in)
        out=[in(:,1),mean(in(:,2:4),2)];
        
function turn_indices = bsliang_select_turns(turn_orders,select_in_dispord,select_in_storord,logic)
        % turn_orders: ����turns�ĳ���˳��
        % select_in_dispord�� ѡ����������turns������˳��
        % select_in_storord�� ѡ����������turns������˳��
        % logic��'_and_', '_or_'��
        % ѡ��ͬʱ����select_in_dispord��select_in_storord����Ҫ����ģ�����ѡ��ֻҪ��������һ����OK��
        disp_included=turn_orders(select_in_dispord);
        turn_indices=[];
        if isequal(logic,'_and_')
            for turn_i=1:length(select_in_storord)
                if ~isempty(find(disp_included==select_in_storord(turn_i),1))
                    turn_indices=[turn_indices,select_in_storord(turn_i)];
                end
            end
        elseif isequal(logic,'_or_')
            turn_indices=unique([disp_included,select_in_storord]);
        end
        