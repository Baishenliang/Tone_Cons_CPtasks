function par_EXPdata_new=bsliang_PTmatrix2PTcontin_Main(par_EXPdata)

    T_old_BEHAV_new=bsliang_PTmatrix2PTcontin(par_EXPdata.T_old_BEHAV);
    P_old_BEHAV_new=bsliang_PTmatrix2PTcontin(par_EXPdata.P_old_BEHAV);
    par_EXPdata_new.T_old_BEHAV=T_old_BEHAV_new;
    par_EXPdata_new.P_old_BEHAV=P_old_BEHAV_new;