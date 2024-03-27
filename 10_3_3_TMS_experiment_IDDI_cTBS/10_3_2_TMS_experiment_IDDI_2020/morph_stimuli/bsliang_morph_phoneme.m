function sound=bsliang_morph_phoneme(sound1,sound2,tone_con,perc_Rate)

% sound1: phoneme [di] or [ba]
% sound2: phoneme [ti] or [pa]
% tone_con: condition of lexical tone 1(for tone55) or 2 (for tone35)
% perc_Rate: morphing rate

    %create STRAIGHT object
    tone1=createMobject;
    tone2=createMobject;

    %updateFieldOfMobject
    tone1=updateFieldOfMobject(tone1,'waveform',sound1);
    tone2=updateFieldOfMobject(tone2,'waveform',sound2);

    %executeSTRAIGHTanalysisM
    tone1 = executeSTRAIGHTanalysisM(tone1);
    tone2 = executeSTRAIGHTanalysisM(tone2);
    
    %load time_frequency parameter matrix
    phon1_para_Tag=['input/phon1_para_tone',num2str(tone_con)];
    try
        load(phon1_para_Tag);
    catch
        displayMobject(tone1,'spectrogram','sound1');
        axis([0 400 0 7000]);
        rawanch = ginput;
        save(phon1_para_Tag,'rawanch');
    end
    tone1 = setAnchorFromRawAnchor(tone1,rawanch);

    phon2_para_Tag=['input/phon2_para_tone',num2str(tone_con)];
    try
        load(phon2_para_Tag);
    catch
        displayMobject(tone2,'spectrogram','sound2');
        axis([0 400 0 7000]);
        rawanch = ginput;
        save(phon2_para_Tag,'rawanch');
    end
    tone2 = setAnchorFromRawAnchor(tone2,rawanch);
    
    sound_temp = timeFrequencySTRAIGHTmorphing(tone1,tone2,perc_Rate,'linear');
    sound = executeSTRAIGHTsynthesisM(sound_temp);
