function ba1_pa1_contin = bsliang_phoneme_ratedcontinuum_Rate(burst,asipration,sound1,sound2,tone_con,perc_lst,rms)
    stepsize=length(perc_lst); 
    ba1_pa1_contin=cell(1,stepsize);
    %ba1_pa1_contin_cat=[];
    for i=1:stepsize
        disp(['Now morphing step: ',num2str(i)]);
        perc_Rate=perc_lst(i);
        morphedSignal=bsliang_morph_phoneme(sound1,sound2,tone_con,perc_Rate);
        % adjust RMS of morphedSignal: same as sound1 and sound2
        sound_temp=morphedSignal/max(abs(morphedSignal))*0.99;
%         sound_temp=[burst;asipration(1:floor(size(asipration,1)*perc_Rate),1);sound_temp];
        [~,sound_t]=bsliang_connect_burst_vot_vowel_balanceRMS(burst,asipration,perc_Rate,sound_temp,rms);
        ba1_pa1_contin{1,i}=sound_t;
%         sound(sound_temp,morphedSignal.samplintFrequency);
%         pause((length(This_Rate)/morphedSignal.samplintFrequency)+0.5);
    end
    
%     sound1=sound1/max(abs(sound1))*0.99;
%     [~,first_vowel]=bsliang_connect_burst_vot_vowel_balanceRMS(burst,asipration,0,sound1,rms);
%     ba1_pa1_contin{1,1}=first_vowel;
%     sound2=sound2/max(abs(sound2))*0.99;
%     [~,second_vowel]=bsliang_connect_burst_vot_vowel_balanceRMS(burst,asipration,1,sound2,rms);
%     ba1_pa1_contin{1,end}=second_vowel;
%     ba1_pa1_contin_cat=ba1_pa1_contin{1,1}';
%     for i=2:stepsize-1
%         ba1_pa1_contin_cat=[ba1_pa1_contin_cat,zeros(1,1*fs),ba1_pa1_contin{1,i}'];
%     end
%     ba1_pa1_contin_cat=[ba1_pa1_contin_cat,zeros(1,1*fs),ba1_pa1_contin{1,end}'];