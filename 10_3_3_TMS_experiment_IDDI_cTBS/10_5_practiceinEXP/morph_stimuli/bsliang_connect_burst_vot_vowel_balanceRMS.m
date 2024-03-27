function [sound_asp,sound_vowel]=bsliang_connect_burst_vot_vowel_balanceRMS(burst,asipration,asp_Rate,vowel,rms)
    % get new syllable and balance RMS. I use a k to chang only the
    % amplitues of the vowel, because here the burst and VOT are assummed
    % to be unchanged, and if we get syllables with the same RMS, we
    % succeed to some extent.
     bsliang = @(k_vowel)bsliang_connect_burst_vot_vowel_balanceRMS_adaptive(burst,asipration,asp_Rate,vowel,k_vowel)-rms;
     options = optimset('TolX',0.00001);
     Kf_vowel=fzero(bsliang,[0 1],options);
     sound_asp = [burst;asipration(1:floor(size(asipration,1)*asp_Rate),1)];
     sound_vowel = Kf_vowel*vowel;