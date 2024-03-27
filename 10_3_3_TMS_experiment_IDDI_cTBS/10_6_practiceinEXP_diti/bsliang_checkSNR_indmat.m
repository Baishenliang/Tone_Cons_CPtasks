cd input
[noise_P,~]=audioread('P_m4dB_SSN.wav');
[noise_T,~]=audioread('T_m4dB_SSN.wav');
cd ../
cd ind_stimmat
for j=1:83
    try
        load([num2str(j),'_par_EXPdata.mat']);
        signal=par_EXPdata.T_old_BEHAV{1,1};
        10*log10((rms(signal)/rms(noise_P))^2)
        10*log10((rms(signal)/rms(noise_T))^2)
    catch
    end
end