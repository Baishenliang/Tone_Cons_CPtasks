function par_EXPdata=lbsCP2_load_par_EXPdata()
try
    load('par_EXPdata.mat');
catch
    par_EXPdata=[];
    lbsCP2_save_par_EXPdata(par_EXPdata);
end