function [DATAout,subj_selected] = bsliang_reshapeDATA(DATA,COND,SUBJ_lst,blocks_stored,blocks_disped,block_rangedmode,turns_stored,turns_disped,turn_rangedmode,special_argu_turn,dls_mode)
% This function reshape the original raw DATA into new DATA, ranked in
% selected subjects, order in displayed or stored orders of turns and
% blocks,


%======== turn stored order ==============
%   stimSITE   NUMBER
%       L        1
%       S1       2
%       T        3
%       S2       4

%======== block stored order =============
%   Id_Di	BLOCK	NAME        NUMBER
%   Id      A       T_CLEAR_ID      1
%   Id      B       P_CLEAR_ID      2
%   Id      C       T_NOISE_ID      3
%   Id      D       P_NOISE_ID      4
%    Di     A       T_CLEAR_DI      5
%    Di     B       P_CLEAR_DI      6
%    Di     C       T_NOISE_DI      7
%    Di     D       P_NOISE_DI      7

%========INPUT==========
% DATA: input raw data

% COND: 1: Identification, 2: Discrimination

% SUBJ_lst: selected codes of subjects


% blocks_stored: blocks ranged in stored order.
% blocks_disped: blocks ranged in displayed order.

% block/turn_rangedmode: '_stored_': the output datasets are arranged in a
%                               stored order;
%                        '_disped_': the output datasets are arranged in a
%                               displayed order;

% turns_stored: turns ranged in stored order.
% turns_disped: turns ranged in displayed order.

% special_argu_turn: special arguments for later alterations (for turns)

% dls_mode: calculating mode:

%           dls_mode=1
%           % Identification
%           ACCs→Mean ACC | RTs | ACC_DIFFs | AUCs | MAXSLOPEPOSs→pos maxslope | Prof_Xu_Indexs
%           % Discrimination
%           ACCs | RTs ;

%           dls_mode=2
%           % Identification
%           ACCs→BOUNDARY WIDTH | RTs | ACC_DIFFs | AUCs | MAXSLOPEPOSs→maxslope | Prof_Xu_Indexs
%           % Discrimination
%           ACCs | RTs ;



DATAout=[];
maxsubj=max(SUBJ_lst);
subj_selected=zeros(1,maxsubj);

% all data mats are organized in a four-dimensional way of (data,blocks,turns,subjects)
if COND == 1
    % Identification
    ACCs = zeros(5,8,4,maxsubj);
    RTs = zeros(5,8,4,maxsubj);
    ACC_DIFFs = zeros(4,8,4,maxsubj);
    AUCs = zeros(1,8,4,maxsubj);
    MAXSLOPEPOSs = AUCs;
    Prof_Xu_Indexs = AUCs;
elseif COND == 2
    % Discrimination
    ACCs = zeros(3,8,4,maxsubj);
    RTs = zeros(11,8,4,maxsubj);
end    

for subj=SUBJ_lst
    % for each subjects
    [block_orders,turn_orders]=bsliang_getindorder(subj);
    turn_indices =  bsliang_select_turns(turn_orders,turns_disped,turns_stored,'_and_');
    
    if isequal(special_argu_turn,'_no_sham_pos2_')
        special_turn_flag = ((turn_orders(2) ~= 2) && (turn_orders(2) ~= 4));
    elseif isequal(special_argu_turn,'_LrTMS_pos2_')
        special_turn_flag = turn_orders(2) == 1;
    elseif isequal(special_argu_turn,'_TrTMS_pos2_')
        special_turn_flag = turn_orders(2) == 3;
    elseif isequal(special_argu_turn,'_LrTMS_pos3_')
        special_turn_flag = turn_orders(3) == 1;
    elseif isequal(special_argu_turn,'_TrTMS_pos3_')
        special_turn_flag = turn_orders(3) == 3;
    elseif isequal(special_argu_turn,'_LrTMS_pos4_')
        special_turn_flag = turn_orders(4) == 1;
    elseif isequal(special_argu_turn,'_TrTMS_pos4_')
        special_turn_flag = turn_orders(4) == 3;
    elseif isequal(special_argu_turn,'_Sham_pos1_')
        special_turn_flag = ((turn_orders(1) == 2) || (turn_orders(1) == 4));
    elseif isequal(special_argu_turn,'_Sham_pos2_')
        special_turn_flag = ((turn_orders(2) == 2) || (turn_orders(2) == 4));
    else
        special_turn_flag=1;
    end
    
    if ~isempty(turn_indices) && special_turn_flag
        subj_selected(subj)=1;
        for turn_index=turn_indices
            % for each turn
            block_orders_tmp = block_orders(turn_orders==turn_index,:);
            block_indices = bsliang_select_turns(block_orders_tmp,blocks_disped,blocks_stored,'_and_');
            
            if ~isempty(block_indices)
                for block_index=block_indices
                % for each block
                    
                    % get ACC data
                    ACC_temp=DATA(subj).Id_Di.data(1,block_index,turn_index).half_threshold(:,end);
                    ACC_temp_raw=DATA(subj).Id_Di.data(1,block_index,turn_index).rawdata;
                    
                    % get RTs
                    steps_tmp=DATA(subj).Id_Di.data(1,block_index,turn_index).rawdata(:,1);
                    RTs_tmp=DATA(subj).Id_Di.data(1,block_index,turn_index).rawdata(:,3);
                    [~,RT_temp]=bsliang_getRTlst(steps_tmp,RTs_tmp);
                    
                    % determind stored positions: block
                    if isequal(block_rangedmode,'_stored_')
                        this_block = block_index;
                    elseif isequal(block_rangedmode,'_disped_')
                        this_block = find(block_orders == block_index);
                    end
                    
                    % determind stored positions: turn
                    if isequal(turn_rangedmode,'_stored_')
                        this_turn = turn_index;
                    elseif isequal(turn_rangedmode,'_disped_')
                        this_turn = find(turn_orders == turn_index);
                    end
                    
                    if COND == 1
                        % Identification
                        [acc_curve,slope_max,width]=bsliang_plot_SNRdata_fitIDcurve(ACC_temp_raw,5,1:5,'beta_100out','_IDcurve_','_YQ_');
                        if dls_mode==1
                            ACCs(:,this_block,this_turn,subj) = acc_curve;
                        elseif dls_mode==2
                            ACCs(:,this_block,this_turn,subj) = width;
                        end
                        RTs(:,this_block,this_turn,subj) = RT_temp;
                        ACC_DIFF = bsliang_plot_SNRdata_fitIDcurve(ACC_temp_raw,5,1:5,'beta_100out','_slopecurve_','_YQ_');
                        ACC_DIFFs(:,this_block,this_turn,subj) = ACC_DIFF;
                        AUCs(1,this_block,this_turn,subj) =  polyarea([1 1:length(ACC_DIFF) length(ACC_DIFF)],[0 ACC_DIFF' 0]);
                        
                        if dls_mode==1
                            maxslops=find(ACC_DIFF==min(ACC_DIFF));
                            MAXSLOPEPOSs(1,this_block,this_turn,subj) = maxslops(1);
                        elseif dls_mode==2
                            MAXSLOPEPOSs(1,this_block,this_turn,subj) = abs(slope_max);
                        end
                        
                        Prof_Xu_Indexs(1,this_block,this_turn,subj) = bsliang_Prof_Xu_Index(ACC_temp_raw,[1 5]);
                    elseif COND == 2
                        % Discrimination
                        [dprimDI,cDI]=YQ_get_dprime_DI(ACC_temp_raw);
                        %ACCs(:,this_block,this_turn,subj) = dprimDI;
                        ACCs(:,this_block,this_turn,subj) = ACC_temp;
                        RTs(:,this_block,this_turn,subj) = RT_temp;
                    end   
                                    
                end
            end
        end
    end
end

if COND == 1
    % Identification
    DATAout.ACCs = ACCs;
    DATAout.RTs = RTs;
    DATAout.ACC_DIFFs = ACC_DIFFs;
    DATAout.AUCs = AUCs;
    DATAout.MAXSLOPEPOSs = MAXSLOPEPOSs;
    DATAout.Prof_Xu_Indexs = Prof_Xu_Indexs;
elseif COND == 2
    % Discrimination
    DATAout.ACCs = ACCs;
    DATAout.RTs = RTs;
end
subj_selected=logical(subj_selected);

function turn_indices = bsliang_select_turns(turn_orders,select_in_dispord,select_in_storord,logic)
        % turn_orders: 被试turns的呈现顺序
        % select_in_dispord： 选择进入分析的turns（呈现顺序）
        % select_in_storord： 选择进入分析的turns（储存顺序）
        % logic：'_and_', '_or_'：
        % 选择同时满足select_in_dispord和select_in_storord都需要满足的，还是选择只要满足其中一个就OK了
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
