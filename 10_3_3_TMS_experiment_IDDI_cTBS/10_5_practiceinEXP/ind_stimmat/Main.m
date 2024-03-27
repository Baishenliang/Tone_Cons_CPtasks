function Main

load('old_par_EXPdata2dims\1_par_EXPdata');
par_EXPdata=bsliang_PTmatrix2PTcontin_Main(par_EXPdata);
save 1_par_EXPdata par_EXPdata
clear all

load('old_par_EXPdata2dims\2_par_EXPdata');
par_EXPdata=bsliang_PTmatrix2PTcontin_Main(par_EXPdata);
save 2_par_EXPdata par_EXPdata
clear all

load('old_par_EXPdata2dims\25_par_EXPdata');
par_EXPdata=bsliang_PTmatrix2PTcontin_Main(par_EXPdata);
save 25_par_EXPdata par_EXPdata
clear all

load('old_par_EXPdata2dims\26_par_EXPdata');
par_EXPdata=bsliang_PTmatrix2PTcontin_Main(par_EXPdata);
save 26_par_EXPdata par_EXPdata
clear all