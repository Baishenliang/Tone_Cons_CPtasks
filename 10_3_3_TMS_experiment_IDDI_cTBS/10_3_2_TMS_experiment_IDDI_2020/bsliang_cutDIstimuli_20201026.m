cd ind_stimmat
DD = dir('*EXPdata*');
for fileID=1:size(DD,1)
    load(DD(fileID).name);
    for k=1:size(par_EXPdata.T_old_BEDIS,2)
        s=par_EXPdata.T_old_BEDIS{1,k};
        par_EXPdata.T_old_BEDIS{1,k}=[s(1:17640,1);s(17640+16273:end,1)]; % ¸ãµô369ms
        s=[];
        disp(k);
        s=par_EXPdata.P_old_BEDIS{1,k};
        par_EXPdata.P_old_BEDIS{1,k}=[s(1:17640,1);s(17640+16273:end,1)]; % ¸ãµô369ms
        s=[];
    end
    save(DD(fileID).name,'par_EXPdata');
end