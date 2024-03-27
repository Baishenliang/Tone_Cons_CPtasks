function bsliang_morph_tone_continuum_sound(matrix,fs,nameTag)
    contin_cat=[];
    for i=1:size(matrix,2)
        sound_temp=matrix{i};
        sound_temp=sound_temp/max(abs(sound_temp));
        contin_cat=[contin_cat,zeros(1,0.5*fs),sound_temp'];
    end
    audiowrite(nameTag,contin_cat,fs);
    %bsliang_morph_tone_continuum_sound(all_morphed_stim_old{1},44100,'da1_da2_contin_cat.wav')