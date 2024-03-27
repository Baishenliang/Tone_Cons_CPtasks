function lbsCP2_save_xs_perc_struct(xs_perc_struct)
    save xs_perc_struct xs_perc_struct
    save(['result_stimmat\xs_perc_struct_',strrep(strrep(strrep(datestr(now),':','_'),' ','_'),'-','_')],'xs_perc_struct');
    disp('===Successfully saved xs_perc_struct and have a copy of it.')