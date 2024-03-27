function RMS_try=bsliang_connect_burst_vot_vowel_balanceRMS_adaptive(burst,asipration,asp_Rate,vowel,k_vowel)
    disp(['now trying k_vowel:',num2str(k_vowel)]);
    sound_temp=[burst;asipration(1:floor(size(asipration,1)*asp_Rate),1);k_vowel*vowel];
    RMS_try=rms(sound_temp);