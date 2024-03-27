function [ID_ACCs,DI_ACCs]=bsliang_reshapeDATA_Main_20191201()
%bsliang_reshapeDATA(DATA,COND,SUBJ_lst,blocks_stored,blocks_disped,block_rangedmode,turns_stored,turns_disped,turn_rangedmode,special_argu_turn)
% 杜老师强行让我重新画图： 音位Identification任务(无噪声)计算Bias（这个改为bar图吧，加上sham，三个bar)


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
%    Di     D       P_NOISE_DI      8

load('DATA.mat');
SUBJ_lst=[7 10 12 18 38 39 41 51 55 59 67 70 78];
    
dls_mode=1;

[PH_ID_C_Lary_TMS_ID,PH_ID_C_Lary_TMS_ID_subj_selected] = bsliang_reshapeDATA(DATA,1,SUBJ_lst,2,1:8,'_stored_',1,2:4,'_stored_','_no_sham_pos2_',dls_mode);
[PH_ID_C_Tong_TMS_ID,PH_ID_C_Tong_TMS_ID_subj_selected] = bsliang_reshapeDATA(DATA,1,SUBJ_lst,2,1:8,'_stored_',3,2:4,'_stored_','_no_sham_pos2_',dls_mode);
[PH_ID_C_Sham_ID,PH_ID_C_Sham_ID_subj_selected] = bsliang_reshapeDATA(DATA,1,SUBJ_lst,2,1:8,'_stored_',[2 4],[3 4],'_stored_','_no_sham_pos2_',dls_mode);

% Combine two dimensions
% PH_ID_C_Lary_TMS_ID=bsliang_combine_dimension(PH_ID_C_Lary_TMS_ID,1,[2 3 4],'ID');
% PH_ID_C_Tong_TMS_ID=bsliang_combine_dimension(PH_ID_C_Tong_TMS_ID,3,[2 3 4],'ID');
PH_ID_C_Sham_ID=bsliang_combine_dimension(PH_ID_C_Sham_ID,1,[2 4],'ID');


% Extract data from selected subjects
PH_ID_C_Lary_TMS_ID=bsliang_takedata(PH_ID_C_Lary_TMS_ID,PH_ID_C_Lary_TMS_ID_subj_selected,'ID');
PH_ID_C_Tong_TMS_ID=bsliang_takedata(PH_ID_C_Tong_TMS_ID,PH_ID_C_Tong_TMS_ID_subj_selected,'ID');
PH_ID_C_Sham_ID=bsliang_takedata(PH_ID_C_Sham_ID,PH_ID_C_Sham_ID_subj_selected,'ID');

% Reduce dimensions
PH_ID_C_Lary_TMS_ID=bsliang_simplify(PH_ID_C_Lary_TMS_ID,'ID',1);
PH_ID_C_Tong_TMS_ID=bsliang_simplify(PH_ID_C_Tong_TMS_ID,'ID',3);
PH_ID_C_Sham_ID=bsliang_simplify(PH_ID_C_Sham_ID,'ID',1);


% Get BIAS
PH_ID_C_Lary_TMS_ID_BIASs=PH_ID_C_Lary_TMS_ID.Prof_Xu_Indexs(2,:);
PH_ID_C_Tong_TMS_ID_BIASs=PH_ID_C_Tong_TMS_ID.Prof_Xu_Indexs(2,:);
PH_ID_C_Sham_ID_BIASs=PH_ID_C_Sham_ID.Prof_Xu_Indexs(2,:);

figure;
plot([PH_ID_C_Lary_TMS_ID_BIASs;PH_ID_C_Tong_TMS_ID_BIASs]);
hold on
boxplot(2,PH_ID_C_Lary_TMS_ID_BIASs)
boxplot(3,PH_ID_C_Tong_TMS_ID_BIASs)

%
figure;
yyaxis left
errorbar(1:5,ID_ACCs_m,ID_ACCs_sd,'Color',[0.5 0.5 0.5],'LineWidth',2);
hold on
plot(1:5,ID_ACCs_m,'-','Color',[0.5 0.5 0.8],'LineWidth',6)
ylim([0 1]);
ylabel('Proportion of Identifying level tone (0~1)','FontSize',20);
set(gca,'YColor',[0.2 0.2 0.2]);
yyaxis right
errorbar(2:4,DI_ACCs_m,DI_ACCs_sd,'Color',[0.5 0.5 0.5],'LineWidth',2);
hold on
plot(2:4,DI_ACCs_m,'-','Color',[0.8 0.5 0.5],'LineWidth',6);
ylim([0.5 0.85]);
ylabel('Discrimination Scores (0~1)','FontSize',20);
set(gca,'YColor',[0.2 0.2 0.2]);
set(gca,'XTick',[1 2 3 4 5],'FontSize',20);
set(gca,'XTickLabels',{'Level','step2','step3','step4','Rise'});
title('Tone Judgement: Behavorial Results','FontSize',25);
xlabel('Tone Continua','FontSize',20);


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
    OUT(:,:,newDIM(1),:)=IN(:,:,oldDIM(1),:)+IN(:,:,oldDIM(2),:);
    
function OUT=bsliang_simplify(IN,mode,TMSdisopos)
    OUT=IN;
    OUT.RTs=squeeze(IN.RTs(:,:,TMSdisopos,:));
    if isequal(mode,'ID')
        OUT.ACCs=squeeze(IN.ACCs(:,:,TMSdisopos,:));
        OUT.ACC_DIFFs=squeeze(IN.ACC_DIFFs(:,:,TMSdisopos,:));
        OUT.AUCs=squeeze(IN.AUCs(:,:,TMSdisopos,:));
        OUT.MAXSLOPEPOSs=squeeze(IN.MAXSLOPEPOSs(:,:,TMSdisopos,:));
        OUT.Prof_Xu_Indexs=squeeze(IN.Prof_Xu_Indexs(:,:,TMSdisopos,:));
    elseif isequal(mode,'DI')
        OUT.ACCs=squeeze(IN.ACCs(:,:,TMSdisopos,:)); % for Discrimination ACC,我们求的是peak点哈
    end
    
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