function [ID_ACCs,DI_ACCs]=bsliang_reshapeDATA_Main_20191129()
%bsliang_reshapeDATA(DATA,COND,SUBJ_lst,blocks_stored,blocks_disped,block_rangedmode,turns_stored,turns_disped,turn_rangedmode,special_argu_turn)
% 杜老师强行让我重新画图： 就音位画一个组平均的identification curve和discrimination peak就行

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
TMSdisopos=1;

ID_K=[1 3];
DI_K=[5 7];

[PhrTMS_ID,PhrTMS_ID_subj_selected] = bsliang_reshapeDATA(DATA,1,SUBJ_lst,ID_K,1:8,'_stored_',1:4,1:4,'_stored_','_none_',dls_mode);

[PhrTMS_DI,PhrTMS_DI_subj_selected] = bsliang_reshapeDATA(DATA,2,SUBJ_lst,DI_K,1:8,'_stored_',1:4,1:4,'_stored_','_none_',dls_mode);

% Combine two dimensions
PhrTMS_ID=bsliang_combine_dimension(PhrTMS_ID,TMSdisopos,[1 2 3 4],'ID');
PhrTMS_DI=bsliang_combine_dimension(PhrTMS_DI,TMSdisopos,[1 2 3 4],'DI');

% Extract data from selected subjects
PhrTMS_ID=bsliang_takedata(PhrTMS_ID,PhrTMS_ID_subj_selected,'ID');
PhrTMS_DI=bsliang_takedata(PhrTMS_DI,PhrTMS_DI_subj_selected,'DI');

% Reduce dimensions
PhrTMS_ID=bsliang_simplify(PhrTMS_ID,'ID',TMSdisopos);
PhrTMS_DI=bsliang_simplify(PhrTMS_DI,'DI',TMSdisopos);

% Get ACCs
ID_ACCs=PhrTMS_ID.ACCs;
DI_ACCs=PhrTMS_DI.ACCs;

% Get ACCs
ID_ACCs=squeeze(mean(ID_ACCs(:,ID_K,:),2));
DI_ACCs=squeeze(mean(DI_ACCs(:,DI_K,:),2));

ID_ACCs_sd=std(ID_ACCs')/sqrt(size(PhrTMS_ID.ACCs,3));
DI_ACCs_sd=std(DI_ACCs')/sqrt(size(PhrTMS_DI.ACCs,3));

ID_ACCs_m=mean(ID_ACCs,2);
DI_ACCs_m=mean(DI_ACCs,2);

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
    OUT(:,:,newDIM(1),:)=(IN(:,:,oldDIM(1),:)+IN(:,:,oldDIM(2),:)+IN(:,:,oldDIM(3),:)+IN(:,:,oldDIM(4),:))/4;
    
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