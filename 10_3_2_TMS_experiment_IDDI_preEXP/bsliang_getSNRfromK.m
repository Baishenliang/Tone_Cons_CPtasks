function SNR=bsliang_getSNRfromK(K)
         par_code_in=1;
         load DATA
         load(['ind_stimmat',filesep,num2str(par_code_in),'_par_EXPdata']);
         signalkk=par_EXPdata.T_old_BEHAV{1,1};
         [noisekk,~]=audioread(DATA(par_code_in).Id_Di.noise_filename{1,1});
        SNR=10*log10((rms(K*signalkk)/rms(noisekk))^2);
end