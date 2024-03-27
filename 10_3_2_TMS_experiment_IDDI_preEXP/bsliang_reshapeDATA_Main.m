function bsliang_reshapeDATA_Main()
    %bsliang_reshapeDATA(DATA,COND,SUBJ_lst,blocks_stored,blocks_disped,block_rangedmode,turns_stored,turns_disped,turn_rangedmode,special_argu_turn)
    %all data mats are organized in a four-dimensional way of (data,blocks,turns,subjects)
    
    % [错误检查提示：2019年12月1日，发现rTMS模式下将bsliang_combine_dimension写错了（本来这个函数只支持写两个turn的维度进去，但是写了三个，因此中间那一列的没有算进去），后面改了才能看prof. Xu index]
    load('DATA.mat');
    SUBJ_lst=[7 10 12 18 38 39 41 51 55 59 67 70 78];
    
    ischeck=0; % Check the program(检查程序的方法：将position2的rTMS-position34的数据砍掉，看看结果是不是跟上一版的程序一样？)
    dls_mode=2;
    
    contrast_mode = 'rTMS';
    if isequal(contrast_mode, 'Sham')
        
        [LrTMS_m_Sham_ID_pos2,LrTMS_m_Sham_DI_pos2,TrTMS_m_Sham_ID_pos2,TrTMS_m_Sham_DI_pos2,Sham_LrTMS_ID_pos2,Sham_LrTMS_DI_pos2,Sham_TrTMS_ID_pos2,Sham_TrTMS_DI_pos2]=bsliang_compute_DATA(DATA,SUBJ_lst,2,'mean',dls_mode,contrast_mode);
        [LrTMS_m_Sham_ID_pos3,LrTMS_m_Sham_DI_pos3,TrTMS_m_Sham_ID_pos3,TrTMS_m_Sham_DI_pos3,Sham_LrTMS_ID_pos3,Sham_LrTMS_DI_pos3,Sham_TrTMS_ID_pos3,Sham_TrTMS_DI_pos3]=bsliang_compute_DATA(DATA,SUBJ_lst,3,'mean',dls_mode,contrast_mode);
        [LrTMS_m_Sham_ID_pos4,LrTMS_m_Sham_DI_pos4,TrTMS_m_Sham_ID_pos4,TrTMS_m_Sham_DI_pos4,Sham_LrTMS_ID_pos4,Sham_LrTMS_DI_pos4,Sham_TrTMS_ID_pos4,Sham_TrTMS_DI_pos4]=bsliang_compute_DATA(DATA,SUBJ_lst,4,'mean',dls_mode,contrast_mode);

        if ~ischeck
            LrTMS_m_Sham_ID = bsliang_combinemats(LrTMS_m_Sham_ID_pos2,LrTMS_m_Sham_ID_pos3,LrTMS_m_Sham_ID_pos4,'ID');
            LrTMS_m_Sham_DI = bsliang_combinemats(LrTMS_m_Sham_DI_pos2,LrTMS_m_Sham_DI_pos3,LrTMS_m_Sham_DI_pos4,'DI');
            TrTMS_m_Sham_ID = bsliang_combinemats(TrTMS_m_Sham_ID_pos2,TrTMS_m_Sham_ID_pos3,TrTMS_m_Sham_ID_pos4,'ID');
            TrTMS_m_Sham_DI = bsliang_combinemats(TrTMS_m_Sham_DI_pos2,TrTMS_m_Sham_DI_pos3,TrTMS_m_Sham_DI_pos4,'DI');
            Sham_LrTMS_ID = bsliang_combinemats(Sham_LrTMS_ID_pos2,Sham_LrTMS_ID_pos3,Sham_LrTMS_ID_pos4,'ID');
            Sham_LrTMS_DI = bsliang_combinemats(Sham_LrTMS_DI_pos2,Sham_LrTMS_DI_pos3,Sham_LrTMS_DI_pos4,'DI');
            Sham_TrTMS_ID = bsliang_combinemats(Sham_TrTMS_ID_pos2,Sham_TrTMS_ID_pos3,Sham_TrTMS_ID_pos4,'ID');
            Sham_TrTMS_DI = bsliang_combinemats(Sham_TrTMS_DI_pos2,Sham_TrTMS_DI_pos3,Sham_TrTMS_DI_pos4,'DI');
        elseif ischeck
            % 后来检查完毕了，发现图和结果都是跟上一版的【bsliang_TMSIDDI_results.m】里面的结果是一致的，算法有效。
            LrTMS_m_Sham_ID = bsliang_combinemats2(LrTMS_m_Sham_ID_pos3,LrTMS_m_Sham_ID_pos4,'ID');
            LrTMS_m_Sham_DI = bsliang_combinemats2(LrTMS_m_Sham_DI_pos3,LrTMS_m_Sham_DI_pos4,'DI');
            TrTMS_m_Sham_ID = bsliang_combinemats2(TrTMS_m_Sham_ID_pos3,TrTMS_m_Sham_ID_pos4,'ID');
            TrTMS_m_Sham_DI = bsliang_combinemats2(TrTMS_m_Sham_DI_pos3,TrTMS_m_Sham_DI_pos4,'DI');
            Sham_LrTMS_ID = bsliang_combinemats2(Sham_LrTMS_ID_pos3,Sham_LrTMS_ID_pos4,'ID');
            Sham_LrTMS_DI = bsliang_combinemats2(Sham_LrTMS_DI_pos3,Sham_LrTMS_DI_pos4,'DI');
            Sham_TrTMS_ID = bsliang_combinemats2(Sham_TrTMS_ID_pos3,Sham_TrTMS_ID_pos4,'ID');
            Sham_TrTMS_DI = bsliang_combinemats2(Sham_TrTMS_DI_pos3,Sham_TrTMS_DI_pos4,'DI');
        end
    elseif isequal(contrast_mode, 'rTMS')
        [LrTMS_m_Sham_ID,LrTMS_m_Sham_DI,TrTMS_m_Sham_ID,TrTMS_m_Sham_DI,Sham_LrTMS_ID,Sham_LrTMS_DI,Sham_TrTMS_ID,Sham_TrTMS_DI]=bsliang_compute_DATA(DATA,SUBJ_lst,2,'mean',dls_mode,contrast_mode);
    end
    
    TMS_Sham_DATA_ID = bsliang_tocell(LrTMS_m_Sham_ID,TrTMS_m_Sham_ID,'ID');
    TMS_Sham_DATA_DI = bsliang_tocell(LrTMS_m_Sham_DI,TrTMS_m_Sham_DI,'DI');

    Sham_rTMS_ID = bsliang_tocell(Sham_LrTMS_ID,Sham_TrTMS_ID,'ID');
    Sham_rTMS_DI = bsliang_tocell(Sham_LrTMS_DI,Sham_TrTMS_DI,'DI');
    

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

    bsliang_plot_datas(TMS_Sham_DATA_ID.ACCs,Sham_rTMS_ID.ACCs)  % 【dlsmode=1】 Mean Reaction Time plots (for Identification scores) | 【dlsmode=2】BOUNDARY WIDTH
    bsliang_plot_datas(TMS_Sham_DATA_ID.RTs,Sham_rTMS_ID.RTs)  % Mean Reaction Time plots (for Identification scores)
    bsliang_plot_datas(TMS_Sham_DATA_ID.AUCs,Sham_rTMS_ID.AUCs) % Area under the curve (for the Identification slope curves)
    bsliang_plot_datas(TMS_Sham_DATA_ID.MAXSLOPEPOSs,Sham_rTMS_ID.MAXSLOPEPOSs) % 【dlsmode=1】Max slope position (for the Identification slope curves) | 【dlsmode=2】Value of the Max slope
    bsliang_plot_datas(TMS_Sham_DATA_ID.Prof_Xu_Indexs,Sham_rTMS_ID.Prof_Xu_Indexs) % Xu Index (for Identification scores)
    
    bsliang_plot_datas(TMS_Sham_DATA_DI.ACCs,Sham_rTMS_DI.ACCs) % Peak value (Mid-mean(Edge)) (for Discrimination scores)
    bsliang_plot_datas(TMS_Sham_DATA_DI.RTs,Sham_rTMS_DI.RTs) % Mean Reaction Time plots (for Discrimination scores)
    
    %% 杜老师2019年11月17日新添加的东西：分析第一次来是Sham的被试的顺序效应：
    [Sham_pos1_m_pos34_ID]=bsliang_reshapeDATA_Main_shameff(DATA,SUBJ_lst,dls_mode);
    mean(Sham_pos1_m_pos34_ID.RTs(1:4,:),2)
    Sham_pos1_m_pos34_ID.ACCs
    
    
function [LrTMS_m_Sham_ID,LrTMS_m_Sham_DI,TrTMS_m_Sham_ID,TrTMS_m_Sham_DI,Sham_LrTMS_ID,Sham_LrTMS_DI,Sham_TrTMS_ID,Sham_TrTMS_DI]=bsliang_compute_DATA(DATA,SUBJ_lst,TMSdisopos,meanmid,dls_mode,contrast_mode)
    %% For position 2
    
    block_disp_index=1:8; %纳入处于什么顺序的blocks（这个顺序是TMS刺激之后呈现的顺序，越早理论上TMS的效应会越强）
    %contrast_mode='rTMS'; % 'Sham': 减去sham条件； 'rTMS': 减去另一个rTMS条件
    
    if isequal(contrast_mode,'Sham')
        % LrTMS data in position2
        [LrTMS_ID,LrTMS_ID_subj_selected] = bsliang_reshapeDATA(DATA,1,SUBJ_lst,1:4,block_disp_index,'_stored_',1,TMSdisopos,'_disped_',['_LrTMS_pos',num2str(TMSdisopos),'_'],dls_mode);
        % squeeze(mean(LrTMS_ID.RTs(:,1:4,2,LrTMS_ID_subj_selected),1))
        [LrTMS_DI,LrTMS_DI_subj_selected] = bsliang_reshapeDATA(DATA,2,SUBJ_lst,5:8,block_disp_index,'_stored_',1,TMSdisopos,'_disped_',['_LrTMS_pos',num2str(TMSdisopos),'_'],dls_mode);
        % squeeze(mean(LrTMS_DI.RTs(:,5:8,2,LrTMS_DI_subj_selected),1))

        % TrTMS data in position2
        [TrTMS_ID,TrTMS_ID_subj_selected] = bsliang_reshapeDATA(DATA,1,SUBJ_lst,1:4,block_disp_index,'_stored_',3,TMSdisopos,'_disped_',['_TrTMS_pos',num2str(TMSdisopos),'_'],dls_mode);
        % squeeze(mean(TrTMS_ID.RTs(:,1:4,2,TrTMS_ID_subj_selected),1))
        [TrTMS_DI,TrTMS_DI_subj_selected] = bsliang_reshapeDATA(DATA,2,SUBJ_lst,5:8,block_disp_index,'_stored_',3,TMSdisopos,'_disped_',['_TrTMS_pos',num2str(TMSdisopos),'_'],dls_mode);
    elseif isequal(contrast_mode,'rTMS')
        % LrTMS data in position2
        [LrTMS_ID,LrTMS_ID_subj_selected] = bsliang_reshapeDATA(DATA,1,SUBJ_lst,1:4,block_disp_index,'_stored_',1,[2 3 4],'_disped_','_no_sham_pos2_',dls_mode);
        % squeeze(mean(LrTMS_ID.RTs(:,1:4,2,LrTMS_ID_subj_selected),1))
        [LrTMS_DI,LrTMS_DI_subj_selected] = bsliang_reshapeDATA(DATA,2,SUBJ_lst,5:8,block_disp_index,'_stored_',1,[2 3 4],'_disped_','_no_sham_pos2_',dls_mode);
        % squeeze(mean(LrTMS_DI.RTs(:,5:8,2,LrTMS_DI_subj_selected),1))
        
        % Combine two dimensions
        LrTMS_ID=bsliang_combine_dimension(LrTMS_ID,TMSdisopos,[2 3 4],'ID');
        LrTMS_DI=bsliang_combine_dimension(LrTMS_DI,TMSdisopos,[2 3 4],'DI');
        
        % TrTMS data in position2
        [TrTMS_ID,TrTMS_ID_subj_selected] = bsliang_reshapeDATA(DATA,1,SUBJ_lst,1:4,block_disp_index,'_stored_',3,[2 3 4],'_disped_','_no_sham_pos2_',dls_mode);
        % squeeze(mean(TrTMS_ID.RTs(:,1:4,2,TrTMS_ID_subj_selected),1))
        [TrTMS_DI,TrTMS_DI_subj_selected] = bsliang_reshapeDATA(DATA,2,SUBJ_lst,5:8,block_disp_index,'_stored_',3,[2 3 4],'_disped_','_no_sham_pos2_',dls_mode);
        
        % Combine two dimensions
        TrTMS_ID=bsliang_combine_dimension(TrTMS_ID,TMSdisopos,[2 3 4],'ID');
        TrTMS_DI=bsliang_combine_dimension(TrTMS_DI,TMSdisopos,[2 3 4],'DI');
    
    end
    
    % Sham_LrTMS data in position2
    [Sham_LrTMS_ID,~] = bsliang_reshapeDATA(DATA,1,SUBJ_lst,1:4,block_disp_index,'_stored_',[2 4],[3 4],'_disped_',['_LrTMS_pos',num2str(TMSdisopos),'_'],dls_mode);
    [Sham_LrTMS_DI,~] = bsliang_reshapeDATA(DATA,2,SUBJ_lst,5:8,block_disp_index,'_stored_',[2 4],[3 4],'_disped_',['_LrTMS_pos',num2str(TMSdisopos),'_'],dls_mode);
    
    % Combine two dimensions
    Sham_LrTMS_ID=bsliang_combine_dimension(Sham_LrTMS_ID,TMSdisopos,[3 4],'ID');
    Sham_LrTMS_DI=bsliang_combine_dimension(Sham_LrTMS_DI,TMSdisopos,[3 4],'DI');

    % Sham_TrTMS data in position2
    [Sham_TrTMS_ID,~] = bsliang_reshapeDATA(DATA,1,SUBJ_lst,1:4,block_disp_index,'_stored_',[2 4],[3 4],'_disped_',['_TrTMS_pos',num2str(TMSdisopos),'_'],dls_mode);
    [Sham_TrTMS_DI,~] = bsliang_reshapeDATA(DATA,2,SUBJ_lst,5:8,block_disp_index,'_stored_',[2 4],[3 4],'_disped_',['_TrTMS_pos',num2str(TMSdisopos),'_'],dls_mode);
    
    % Combine two dimensions
    Sham_TrTMS_ID=bsliang_combine_dimension(Sham_TrTMS_ID,TMSdisopos,[3 4],'ID');
    Sham_TrTMS_DI=bsliang_combine_dimension(Sham_TrTMS_DI,TMSdisopos,[3 4],'DI');    
    
    % Do Sham contrast
    if isequal(contrast_mode,'Sham')
        LrTMS_m_Sham_ID=bsliang_everysubtract(LrTMS_ID,Sham_LrTMS_ID,'ID');
        LrTMS_m_Sham_DI=bsliang_everysubtract(LrTMS_DI,Sham_LrTMS_DI,'DI');
        TrTMS_m_Sham_ID=bsliang_everysubtract(TrTMS_ID,Sham_TrTMS_ID,'ID');
        TrTMS_m_Sham_DI=bsliang_everysubtract(TrTMS_DI,Sham_TrTMS_DI,'DI');
    elseif isequal(contrast_mode,'rTMS')
%         LrTMS_m_Sham_ID=bsliang_everysubtract(LrTMS_ID,TrTMS_ID,'ID');
%         LrTMS_m_Sham_DI=bsliang_everysubtract(LrTMS_DI,TrTMS_DI,'DI');
%         TrTMS_m_Sham_ID=bsliang_everysubtract(TrTMS_ID,LrTMS_ID,'ID');
%         TrTMS_m_Sham_DI=bsliang_everysubtract(TrTMS_DI,LrTMS_DI,'DI');
          LrTMS_m_Sham_ID=LrTMS_ID;
          LrTMS_m_Sham_DI=LrTMS_DI;
          TrTMS_m_Sham_ID=TrTMS_ID;
          TrTMS_m_Sham_DI=TrTMS_DI;
    end
    
    % Extract data from selected subjects
    LrTMS_m_Sham_ID=bsliang_takedata(LrTMS_m_Sham_ID,LrTMS_ID_subj_selected,'ID');
    LrTMS_m_Sham_DI=bsliang_takedata(LrTMS_m_Sham_DI,LrTMS_DI_subj_selected,'DI');
    TrTMS_m_Sham_ID=bsliang_takedata(TrTMS_m_Sham_ID,TrTMS_ID_subj_selected,'ID');
    TrTMS_m_Sham_DI=bsliang_takedata(TrTMS_m_Sham_DI,TrTMS_DI_subj_selected,'DI');   
    
    % Reduce dimensions
    LrTMS_m_Sham_ID=bsliang_simplify(LrTMS_m_Sham_ID,'ID',meanmid,TMSdisopos);
    LrTMS_m_Sham_DI=bsliang_simplify(LrTMS_m_Sham_DI,'DI',meanmid,TMSdisopos);
    TrTMS_m_Sham_ID=bsliang_simplify(TrTMS_m_Sham_ID,'ID',meanmid,TMSdisopos);
    TrTMS_m_Sham_DI=bsliang_simplify(TrTMS_m_Sham_DI,'DI',meanmid,TMSdisopos); 
    
    % For shams:
    Sham_LrTMS_ID=bsliang_takedata(Sham_LrTMS_ID,LrTMS_ID_subj_selected,'ID');
    Sham_LrTMS_DI=bsliang_takedata(Sham_LrTMS_DI,LrTMS_DI_subj_selected,'DI');
    Sham_TrTMS_ID=bsliang_takedata(Sham_TrTMS_ID,TrTMS_ID_subj_selected,'ID');
    Sham_TrTMS_DI=bsliang_takedata(Sham_TrTMS_DI,TrTMS_DI_subj_selected,'DI');  
    
    Sham_LrTMS_ID=bsliang_simplify(Sham_LrTMS_ID,'ID',meanmid,TMSdisopos);
    Sham_LrTMS_DI=bsliang_simplify(Sham_LrTMS_DI,'DI',meanmid,TMSdisopos);
    Sham_TrTMS_ID=bsliang_simplify(Sham_TrTMS_ID,'ID',meanmid,TMSdisopos);
    Sham_TrTMS_DI=bsliang_simplify(Sham_TrTMS_DI,'DI',meanmid,TMSdisopos); 
    
    
    
    
function OUT=bsliang_everysubtract(rTMS,Sham,mode)
    OUT=[];
    OUT.ACCs=rTMS.ACCs-Sham.ACCs;
    OUT.RTs=rTMS.RTs-Sham.RTs;
    if isequal(mode,'ID')
        OUT.ACC_DIFFs=rTMS.ACC_DIFFs-Sham.ACC_DIFFs;
        OUT.AUCs=rTMS.AUCs-Sham.AUCs;
        OUT.MAXSLOPEPOSs=rTMS.MAXSLOPEPOSs-Sham.MAXSLOPEPOSs;
        OUT.Prof_Xu_Indexs=rTMS.Prof_Xu_Indexs-Sham.Prof_Xu_Indexs;
    end
    
function OUT=bsliang_combine_dimension(IN,newDIM,oldDIM,mode)
    OUT=[];
    OUT.ACCs=bsliang_combine_dimension_sub(IN.ACCs,newDIM,oldDIM);
    OUT.RTs=bsliang_combine_dimension_sub(IN.RTs,newDIM,oldDIM);
    if isequal(mode,'ID')
        OUT.ACC_DIFFs=bsliang_combine_dimension_sub(IN.ACC_DIFFs,newDIM,oldDIM);
        OUT.AUCs=bsliang_combine_dimension_sub(IN.AUCs,newDIM,oldDIM);
        OUT.MAXSLOPEPOSs=bsliang_combine_dimension_sub(IN.MAXSLOPEPOSs,newDIM,oldDIM);
        OUT.Prof_Xu_Indexs=bsliang_combine_dimension_sub(IN.Prof_Xu_Indexs,newDIM,oldDIM);
    end
    
function OUT=bsliang_combine_dimension_sub(IN,newDIM,oldDIM)
    OUT=IN;
    if length(oldDIM)==2
        OUT(:,:,newDIM(1),:)=IN(:,:,oldDIM(1),:)+IN(:,:,oldDIM(2),:);
    elseif length(oldDIM)==3
        OUT(:,:,newDIM(1),:)=IN(:,:,oldDIM(1),:)+IN(:,:,oldDIM(2),:)+IN(:,:,oldDIM(3),:);
    end
%     OUT(:,:,oldDIM,:)=0;
    
function OUT=bsliang_takedata(IN,subj_selected,mode)
    OUT=[];
    OUT.ACCs=IN.ACCs(:,:,:,subj_selected);
    OUT.RTs=IN.RTs(:,:,:,subj_selected);
    if isequal(mode,'ID')
        OUT.ACC_DIFFs=IN.ACC_DIFFs(:,:,:,subj_selected);
        OUT.AUCs=IN.AUCs(:,:,:,subj_selected);
        OUT.MAXSLOPEPOSs=IN.MAXSLOPEPOSs(:,:,:,subj_selected);
        OUT.Prof_Xu_Indexs=IN.Prof_Xu_Indexs(:,:,:,subj_selected);
    end
    
function OUT=bsliang_simplify(IN,mode,meanmid,TMSdisopos)
    OUT=IN;
    if isequal(meanmid,'mean')
        OUT.RTs=squeeze(mean(IN.RTs(:,:,TMSdisopos,:),1));
        if isequal(mode,'ID')
            OUT.ACCs=squeeze(mean(IN.ACCs(:,:,TMSdisopos,:),1));
            OUT.ACC_DIFFs=squeeze(mean(IN.ACC_DIFFs(:,:,TMSdisopos,:),1));
            OUT.AUCs=squeeze(IN.AUCs(:,:,TMSdisopos,:));
            OUT.MAXSLOPEPOSs=squeeze(IN.MAXSLOPEPOSs(:,:,TMSdisopos,:));
            OUT.Prof_Xu_Indexs=squeeze(IN.Prof_Xu_Indexs(:,:,TMSdisopos,:));
        elseif isequal(mode,'DI')
            OUT.ACCs=squeeze(IN.ACCs(2,:,TMSdisopos,:))-(squeeze(IN.ACCs(1,:,TMSdisopos,:))+squeeze(IN.ACCs(3,:,TMSdisopos,:)))/2; % for Discrimination ACC,我们求的是peak点哈
            %OUT.ACCs=squeeze(IN.ACCs(2,:,TMSdisopos,:)); % for Discrimination ACC,我们求的是peak点哈
            %OUT.ACCs=(squeeze(IN.ACCs(1,:,TMSdisopos,:))+squeeze(IN.ACCs(3,:,TMSdisopos,:)))/2; % for Discrimination ACC,我们求的是peak点哈
        end
    elseif isequal(meanmid,'mid')
        OUT.ACCs=squeeze(IN.ACCs(2,:,TMSdisopos,:))-(squeeze(IN.ACCs(1,:,TMSdisopos,:))+squeeze(IN.ACCs(3,:,TMSdisopos,:)))/2; % for Discrimination ACC
        OUT.RTs=squeeze(IN.RTs((1+end)/2,:,TMSdisopos,:)); % for Identification RT
        if isequal(mode,'ID')
            OUT.ACC_DIFFs=squeeze(IN.ACC_DIFFs((1+end)/2,:,TMSdisopos,:));
            OUT.AUCs=squeeze(IN.AUCs(:,:,TMSdisopos,:));
            OUT.MAXSLOPEPOSs=squeeze(IN.MAXSLOPEPOSs(:,:,TMSdisopos,:));
            OUT.Prof_Xu_Indexs=squeeze(IN.Prof_Xu_Indexs(:,:,TMSdisopos,:));
        end
    end
    
function OUT=bsliang_combinemats(IN1,IN2,IN3,mode)
    OUT=[];
    OUT.ACCs=[IN1.ACCs,IN2.ACCs,IN3.ACCs];
    OUT.RTs=[IN1.RTs,IN2.RTs,IN3.RTs];
    if isequal(mode,'ID')
        OUT.ACC_DIFFs=[IN1.ACC_DIFFs,IN2.ACC_DIFFs,IN3.ACC_DIFFs];
        OUT.AUCs=[IN1.AUCs,IN2.AUCs,IN3.AUCs];
        OUT.MAXSLOPEPOSs=[IN1.MAXSLOPEPOSs,IN2.MAXSLOPEPOSs,IN3.MAXSLOPEPOSs];
        OUT.Prof_Xu_Indexs=[IN1.Prof_Xu_Indexs,IN2.Prof_Xu_Indexs,IN3.Prof_Xu_Indexs];
    end
    
function OUT=bsliang_combinemats2(IN1,IN2,mode)
    OUT=[];
    OUT.ACCs=[IN1.ACCs,IN2.ACCs];
    OUT.RTs=[IN1.RTs,IN2.RTs];
    if isequal(mode,'ID')
        OUT.ACC_DIFFs=[IN1.ACC_DIFFs,IN2.ACC_DIFFs];
        OUT.AUCs=[IN1.AUCs,IN2.AUCs];
        OUT.MAXSLOPEPOSs=[IN1.MAXSLOPEPOSs,IN2.MAXSLOPEPOSs];
        OUT.Prof_Xu_Indexs=[IN1.Prof_Xu_Indexs,IN2.Prof_Xu_Indexs];
    end
    
function OUT=bsliang_tocell(IN1,IN2,mode)
    OUT=[];
    if isequal(mode,'ID')
        index_add=0;
        OUT.ACC_DIFFs=bsliang_tocellsub(IN1.ACC_DIFFs,IN2.ACC_DIFFs,index_add);
        OUT.AUCs=bsliang_tocellsub(IN1.AUCs,IN2.AUCs,index_add);
        OUT.MAXSLOPEPOSs=bsliang_tocellsub(IN1.MAXSLOPEPOSs,IN2.MAXSLOPEPOSs,index_add);
        OUT.Prof_Xu_Indexs=bsliang_tocellsub(IN1.Prof_Xu_Indexs,IN2.Prof_Xu_Indexs,index_add);
    elseif isequal(mode,'DI')
        index_add=4;
    end
    OUT.ACCs=bsliang_tocellsub(IN1.ACCs,IN2.ACCs,index_add);
    OUT.RTs=bsliang_tocellsub(IN1.RTs,IN2.RTs,index_add);
    
    
function OUT=bsliang_tocellsub(IN1,IN2,index_add)
    if size(IN1,2)>size(IN2,2)
        IN2=[IN2,mean(IN2,2)];
    elseif size(IN1,2)<size(IN2,2)
        IN1=[IN1,mean(IN1,2)];
    end
    OUT={[reshape(IN1(1+index_add:4+index_add,:),1,[])',reshape(IN2(1+index_add:4+index_add,:),1,[])'],...
         [IN1(1+index_add,:)',IN2(1+index_add,:)'],...
         [IN1(2+index_add,:)',IN2(2+index_add,:)'],...
         [IN1(3+index_add,:)',IN2(3+index_add,:)'],...
         [IN1(4+index_add,:)',IN2(4+index_add,:)']};

function bsliang_plot_datas(TMS_Sham_DATA,Sham_DATA)
    block_labels2={'POOLED','T CLEAR ID','P CLEAR ID','T NOISE ID','P NOISE ID'};
    figure;
    for cond_i=1:5

        subplot(3,5,cond_i);
        
        % way1: boxplot
%        boxplot(TMS_Sham_DATA{1,cond_i})
        
        % way2: individualized line plots
        plot(TMS_Sham_DATA{1,cond_i}','o-','Color',[0.5 0.5 0.5]);
        hold on
        plot(mean(TMS_Sham_DATA{1,cond_i},1)','ko-','LineWidth',2);
        set(gca,'Xtick',[1 2]);
        xlim([0.5 2.5]);

        % way3: boxplot + individualized points
%         gretna_plot_dot(TMS_Sham_DATA(1,cond_i),block_labels2(cond_i),{'Larynx-Sham','Tongue-Sham'},'sem');
        
%         h1_tmp=ranksum(TMS_Sham_DATA{1,cond_i}(:,1),0);
%         h2_tmp=ranksum(TMS_Sham_DATA{1,cond_i}(:,2),0);
        enh1_tmp=sum(TMS_Sham_DATA{1,cond_i}(:,1)>0);
        enh2_tmp=sum(TMS_Sham_DATA{1,cond_i}(:,2)>0);
        size_tmp=size(TMS_Sham_DATA{1,cond_i},1);
        p1_tmp=chi2test([enh1_tmp,size_tmp-enh1_tmp;size_tmp/2,size_tmp/2]);
        p2_tmp=chi2test([enh2_tmp,size_tmp-enh2_tmp;size_tmp/2,size_tmp/2]);

        if p1_tmp<0.05
            text(1,mean(TMS_Sham_DATA{1,cond_i}(:,1))+2*std(TMS_Sham_DATA{1,cond_i}(:,1)),'*','FontSize',30);
        end
        if p2_tmp<0.05
            text(2,mean(TMS_Sham_DATA{1,cond_i}(:,2))+2*std(TMS_Sham_DATA{1,cond_i}(:,2)),'*','FontSize',30);
        end
        title(block_labels2{cond_i});
%         if cond_i == 5
%              title('反应时: 噪声下音位识别(Id)任务(rTMS-Sham)');
%              ylabel('反应时(s)');
%         end
        
       % ylim([-0.25 0.25]);
       
        set(gca,'XTickLabel',{['喉部 ',num2str(enh1_tmp),'/',num2str(size_tmp)],['舌部 ',num2str(enh2_tmp),'/',num2str(size_tmp)]});
        %set(gca,'XTickLabel',{['Larynx ',num2str(enh1_tmp),'/',num2str(size_tmp)],['Tongue ',num2str(enh2_tmp),'/',num2str(size_tmp)]});

        for condi_add=[5 10]
            subplot(3,5,cond_i+condi_add);
            X = TMS_Sham_DATA{1,cond_i}(:,condi_add/5);
            Y = Sham_DATA{1,cond_i}(:,condi_add/5);
            p = polyfit(X,Y,1);
            f = polyval(p,X); 
            plot(X,Y,'bo','MarkerFaceColor',[0.8 0.8 1],'MarkerSize',3);
            hold on
            plot(X,f,'-','Color',[0.8 0.5 0.5],'LineWidth',2);
            [Rcro,Pcro]=corrcoef(X,Y);
            %xlabel({['Y = ',num2str(round(p(1),3)),'X + ',num2str(round(p(2),3)),' R^2 = ',num2str(round(1-sum((Y-f).^2)/((length(Y)-1)*var(Y)),3))],['r = ',num2str(round(Rcro(2),3)),' p = ',num2str(round(Pcro(2),5))]});
            xlabel('Discrimination Peak (rTMS-Sham)');
            ylabel('Discrimination Peak (Sham)')
            if cond_i == 1 && condi_add==5
                 title('Larynx rTMS: Pooled');
            elseif cond_i == 1 && condi_add==10
                 title('Tongue rTMS: Pooled');
            end
        end

    end
    
function [Sham_pos1_m_pos34_ID]=bsliang_reshapeDATA_Main_shameff(DATA,SUBJ_lst,dls_mode)

    %bsliang_reshapeDATA(DATA,COND,SUBJ_lst,blocks_stored,blocks_disped,block_rangedmode,turns_stored,turns_disped,turn_rangedmode,special_argu_turn)
    
    %[[[[[[[[[[[[[[[[[[[[[杜老师后来改成了pos2
    %sham了，记得改回去！！！！！！！！！！！！！！！！！！！！！！！！！！]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
    
    % get raw data
    [Sham_pos1_ID,Sham_pos1_ID_subj_selected] = bsliang_reshapeDATA(DATA,1,SUBJ_lst,1:4,1:8,'_stored_',[2 4],2,'_disped_','_Sham_pos2_',dls_mode);
    
    [Sham_pos34_ID,Sham_pos34_ID_subj_selected] = bsliang_reshapeDATA(DATA,1,SUBJ_lst,1:4,1:8,'_stored_',[2 4],[3 4],'_disped_','_Sham_pos2_',dls_mode);

    % combine two dimensions
    Sham_pos34_ID=bsliang_combine_dimension(Sham_pos34_ID,2,[3 4],'ID');

    % do contrast
    Sham_pos1_m_pos34_ID=bsliang_everysubtract(Sham_pos1_ID,Sham_pos34_ID,'ID');

    % Extract data from selected subjects
    Sham_pos1_m_pos34_ID=bsliang_takedata(Sham_pos1_m_pos34_ID,Sham_pos1_ID_subj_selected,'ID');
%     Sham_pos34_ID=bsliang_takedata(Sham_pos34_ID,Sham_pos34_ID_subj_selected,'ID');
    
    % Reduce dimensions
    Sham_pos1_m_pos34_ID=bsliang_simplify(Sham_pos1_m_pos34_ID,'ID','mean',2);
%     Sham_pos34_ID=bsliang_simplify(Sham_pos34_ID,'ID','mean',1);