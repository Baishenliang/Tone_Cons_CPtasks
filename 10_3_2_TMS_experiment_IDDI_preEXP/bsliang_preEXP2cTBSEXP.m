function bsliang_preEXP2cTBSEXP(subj_lst)
% ����Ԥʵ��󣬽����Ե�����Ū��cTBSʵ����ļ�����
% example: subj_lst=[1 2 3], ת�����Ϊ1 2 3�ı���
for subj=subj_lst
    
    cTBSFOLD=['..',filesep,'10_3_3_TMS_experiment_IDDI_cTBS',filesep,'10_3_2_TMS_experiment_IDDI_2020'];
    % step1: ���Ƹñ��Ե�DATA
    
    load DATA
    subjDATA=DATA(subj);
    disp(subjDATA.par_info.name);
    clear DATA
    
    cd(cTBSFOLD)
    
    load DATA
    if size(DATA,2)>=subj && ~isempty(DATA(subj).par_info)
        uiwait(msgbox(['�����ƶ�����',num2str(subj),',��Ϊ�����ļ��������Ա��⸲������']));
    else
        DATA(subj)=subjDATA;
    end
    save DATA DATA
    clear DATA
    
    cd(['..',filesep,'..',filesep,'10_3_2_TMS_experiment_IDDI_preEXP'])
    
    % step2: ���Ƹñ��Ե�ind_stimmat
    copyfile(['ind_stimmat',filesep,num2str(subj),'*'],[cTBSFOLD,filesep,'ind_stimmat'])
    
    % step3: �޸�order���ֶ�
end

open([cTBSFOLD,filesep,'bsliang_gainORDERnum.m']);