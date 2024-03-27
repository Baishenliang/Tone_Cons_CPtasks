function [F0,meanF0] = bsliang_getF0(tone,avg_range)
    
    tone1=createMobject;
    tone1=updateFieldOfMobject(tone1,'waveform',tone);
    tone1 = executeSTRAIGHTanalysisM(tone1);
    meanF0=mean(tone1.F0(1,avg_range(1):avg_range(2)));
    F0 = tone1.F0;