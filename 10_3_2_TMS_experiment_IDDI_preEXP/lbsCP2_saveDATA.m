function lbsCP2_saveDATA(DATA)
    save DATA DATA
    save(['result_datamat\DATA_',strrep(strrep(strrep(datestr(now),':','_'),' ','_'),'-','_')],'DATA');
    disp('===Successfully saved DATA and have a copy of it.')