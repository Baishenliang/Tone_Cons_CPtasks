function lbsCP2_save_par_EXPdata(par_EXPdata)
    save par_EXPdata par_EXPdata
    save(['result_stimmat\par_EXPdata_',strrep(strrep(strrep(datestr(now),':','_'),' ','_'),'-','_')],'par_EXPdata');
    disp('===Successfully saved par_EXPdata and have a copy of it.')