function EEG_stim = BSLiang_getEEGfromBEHAVstim(BEHAV_stim)
    %�����е�7*7 steps��ѡȡEEGʵ����Ҫ��between��within�Ĵ̼�
    %       Stand	Phon	Tone	Both
    %Within	P3T3	P1T3	P3T1	P1T1
    %Between		P5T3	P3T5	P5T5

    EEG_stim.P3T3 = BEHAV_stim{3,3};
    EEG_stim.P1T3 = BEHAV_stim{1,3};
    EEG_stim.P5T3 = BEHAV_stim{5,3};
    EEG_stim.P3T1 = BEHAV_stim{3,1};
    EEG_stim.P3T5 = BEHAV_stim{3,5};
    EEG_stim.P1T1 = BEHAV_stim{1,1};
    EEG_stim.P5T5 = BEHAV_stim{5,5};