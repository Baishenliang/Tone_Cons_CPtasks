function [T_ID,P_ID,T_IDRT,P_IDRT,T_DI,P_DI,mode]=bsliang_get9stepsRTs(par,Nostep,mode)
% mode: whether seperate ambiguous and unambiguous
% mode = '_ALL_', integrate ambiguous and unambiguous
% mode = '_AMB_', only ambiguous condition
% mode = '_UNAMB_', only unambiguous condition

if isequal(mode,'_ALL_')
    select_index=1:Nostep;
elseif isnumeric(mode)
    select_index=mode;
    mode=['STEP',num2str(select_index)];
else
    if Nostep==5
        if isequal(mode,'_AMB_')
            %select_index=[2 3 4];
            select_index=3;
        elseif isequal(mode,'_UNAMB_')
            select_index=[1 5];
        end
    elseif  Nostep==7
        if isequal(mode,'_AMB_')
            %select_index=[3 4 5];
            select_index=4;
        elseif isequal(mode,'_UNAMB_')
            %select_index=[1 2 6 7];
            select_index=[1 7];
        end
    elseif  Nostep==9
        if isequal(mode,'_AMB_')
            %select_index=[3 4 5 6 7];
            select_index=5;
        elseif isequal(mode,'_UNAMB_')
            %select_index=[1 2 8 9];
            select_index=[1 9];
        end
    end
end

file_lst=dir('result_datamat\**.mat');
continue_loop=1;
file_id=1;
while continue_loop
    load(['result_datamat\',file_lst(file_id).name]);
    try
        datapar=DATA(par).def_range.data;
        Tlen=size(datapar(1).half_threshold,1);
        Plen=size(datapar(2).half_threshold,1);
        if (Tlen==Nostep) && (Plen==Nostep)
            disp(['Found the file: ',file_lst(file_id).name]);
            T_rawdata_raw=datapar(1).rawdata;
            P_rawdata_raw=datapar(2).rawdata;
            T_rawdata=[];
            P_rawdata=[];
            for sel_i=1:length(select_index)
                T_rawdata_temp=T_rawdata_raw(T_rawdata_raw(:,4)==select_index(sel_i),:);
                T_rawdata=[T_rawdata;T_rawdata_temp];
                P_rawdata_temp=P_rawdata_raw(P_rawdata_raw(:,4)==select_index(sel_i),:);
                P_rawdata=[P_rawdata;P_rawdata_temp];
            end
            T_IDRT_steps=T_rawdata(:,1);
            P_IDRT_steps=P_rawdata(:,1);
            T_IDRTs=T_rawdata(:,3);
            P_IDRTs=P_rawdata(:,3);
            T_s=T_rawdata(:,2);
            P_s=P_rawdata(:,2);
            [~,T_IDRT]=bsliang_getRTlst(T_IDRT_steps,T_IDRTs);
            [~,P_IDRT]=bsliang_getRTlst(P_IDRT_steps,P_IDRTs);
            [~,T_ID]=bsliang_getRTlst(T_IDRT_steps,T_s);
            [~,P_ID]=bsliang_getRTlst(P_IDRT_steps,P_s);
            T_ID=1-T_ID;
            P_ID=1-P_ID;
            continue_loop=0;
        end
    catch
    end
    file_id=file_id+1;
end

continue_loop=1;
file_id=1;
while continue_loop
    load(['result_datamat\',file_lst(file_id).name]);
    try
        datapar=DATA(par).def_range.data;
        T_DI=bsliang_getDi_scores(DATA(par).def_range.Di_stimcluster{3},datapar(3).rawdata);
        P_DI=bsliang_getDi_scores(DATA(par).def_range.Di_stimcluster{4},datapar(4).rawdata);
        T_DI=T_DI(:,2);
        P_DI=P_DI(:,2);
        disp(['Found the file: ',file_lst(file_id).name]);
        continue_loop=0;
    catch
    end
    file_id=file_id+1;
end
