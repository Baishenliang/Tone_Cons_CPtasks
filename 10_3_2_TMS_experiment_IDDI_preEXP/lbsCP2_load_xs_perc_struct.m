function xs_perc_struct=lbsCP2_load_xs_perc_struct()
try
    load('xs_perc_struct.mat');
catch
    xs_perc_struct=[];
    lbsCP2_save_xs_perc_struct(xs_perc_struct);
end