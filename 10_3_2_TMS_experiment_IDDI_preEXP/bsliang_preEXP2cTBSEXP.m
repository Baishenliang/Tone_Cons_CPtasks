function bsliang_preEXP2cTBSEXP(subj_lst)
% 做完预实验后，将被试的数据弄到cTBS实验的文件夹里
% example: subj_lst=[1 2 3], 转换编号为1 2 3的被试
for subj=subj_lst
    
    cTBSFOLD=['..',filesep,'10_3_3_TMS_experiment_IDDI_cTBS',filesep,'10_3_2_TMS_experiment_IDDI_2020'];
    % step1: 复制该被试的DATA
    
    load DATA
    subjDATA=DATA(subj);
    disp(subjDATA.par_info.name);
    clear DATA
    
    cd(cTBSFOLD)
    
    load DATA
    if size(DATA,2)>=subj && ~isempty(DATA(subj).par_info)
        uiwait(msgbox(['不能移动被试',num2str(subj),',因为已有文件，请检查以避免覆盖数据']));
    else
        DATA(subj)=subjDATA;
    end
    save DATA DATA
    clear DATA
    
    cd(['..',filesep,'..',filesep,'10_3_2_TMS_experiment_IDDI_preEXP'])
    
    % step2: 复制该被试的ind_stimmat
    copyfile(['ind_stimmat',filesep,num2str(subj),'*'],[cTBSFOLD,filesep,'ind_stimmat'])
    
    % step3: 修改order，手动
end

open([cTBSFOLD,filesep,'bsliang_gainORDERnum.m']);