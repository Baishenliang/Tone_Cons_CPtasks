function sound_final = bsliang_morphing_tone_adaptive(tone1sound,tone2sound,F0_range,perc_F0,phon_cont_sign,nosteps,votint_len,tone_cont_sign)

    %just a test
%     [tone1sound,~]=audioread('pa1_370ms_60dB_chVOT_5khzlp.wav');
%     [tone2sound,~]=audioread('pa2_370ms_60dB_upFreq_5khzlp.wav');
%     F0_range=[5,100];
%     perc_F0=0.5;
%     phon_cont_sign=7;
%     nosteps=6;
%     vot_cut_start=0.01991088580770039;
%     vot_end_point=0.09040660154655696;
%     votint_len=vot_end_point-vot_cut_start;
    
    %create STRAIGHT object
    tone1=createMobject;
    tone2=createMobject;

    %updateFieldOfMobject
    tone1=updateFieldOfMobject(tone1,'waveform',tone1sound);
    tone2=updateFieldOfMobject(tone2,'waveform',tone2sound);

    %executeSTRAIGHTanalysisM
    tone1 = executeSTRAIGHTanalysisM(tone1);
    tone2 = executeSTRAIGHTanalysisM(tone2);
    
    %make sure that F0 contours are aligned:
    tone1.F0(tone2.F0==0)=0;
    tone2.F0(tone1.F0==0)=0;
    
    %find the begining of F0 contour of tone1 and tone2 (as the marker of the start of voicing)
    tone1_pos=find(tone1.F0);
    tone1_beg=tone1_pos(1);
    
    tone2_pos=find(tone2.F0);
    tone2_beg=tone2_pos(1);    

    %addtemplate
    try
        load('input/tone1_para');
    catch
        displayMobject(tone1,'spectrogram','tone1');
        axis([0 400 0 7000]);
        rawanch = ginput;
        save('input/tone1_para.mat','rawanch');
    end
    tone1 = setAnchorFromRawAnchor(tone1,rawanch); 
    tone1.anchorTimeLocation=tone1.anchorTimeLocation-(nosteps+1-phon_cont_sign)*votint_len;

%     displayMobject(tone1,'anchorTimeLocation','tone1');
%     axis([0 400 0 7000]); 

    try
        load('input/tone2_para');
    catch
        displayMobject(tone2,'spectrogram','tone2');
        axis([0 400 0 7000]);
        rawanch = ginput;
        save('input/tone2_para.mat','rawanch');
    end
    tone2 = setAnchorFromRawAnchor(tone2,rawanch);
    tone2.anchorTimeLocation=tone2.anchorTimeLocation-(nosteps+1-phon_cont_sign)*votint_len;

    % displayMobject(tone2,'anchorTimeLocation','tone2');
    % axis([0 400 0 7000]); 

    % morphing
    
    
    lenpa1pa2=round(mean([length(tone1sound),length(tone2sound)]));
    
    % 下面这段代码是全函数的精华，让我慢慢解释：
    % 灵感来源：https://ww2.mathworks.cn/help/matlab/ref/fzero.html#btoc6lj-1-options
    % 用fzero求零点的方法，即便不知道函数表达式，也是可以求的
    
    %F0_range=[5,100];
    
    bsliang = @(perc_temp) bsliang_generatemorph_tone(tone1,tone2,perc_temp,tone1_beg,tone2_beg,lenpa1pa2,F0_range,'_test_',phon_cont_sign,tone_cont_sign)-perc_F0;
    % fun = @(x) funname(c,x)-A 
    %（其中funname为函数名，是个多参数函数，所以声明x为所求自变量，A为常数）
    % 这个的意思是：现在我需要求funname(c,x)==A方程的解x
    options = optimset('TolX',0.00001); %per_Rate=0~1, 0.001=27/1000 steps
    % 这个option的意思是取x误差允许的范围
    perc_Rate=fzero(bsliang,perc_F0,options);
    % x_out=fzero(fun,x_start,options)
    % 这个是求解指令，fun为函数，x_start为求解开始的x点，x_out是输出的零点
    % 由于在我们的计算中，输出的百分比（morphRate）应近似等于输入的百分比（F0百分比），这里选用perc_F0
    
    %现在我们进行500次生成来输出F0最接近所要求的F0的值：
    checknum=50;
    perc_F0_check=zeros(1,checknum);
    sound_check=cell(1,checknum);
    for i=1:checknum
        check_out=bsliang_generatemorph_tone(tone1,tone2,perc_Rate,tone1_beg,tone2_beg,lenpa1pa2,F0_range,'_generate_',phon_cont_sign,tone_cont_sign);
        perc_F0_check(1,i)=check_out.perc_F0;
        sound_check{1,i}=check_out.sound;
    end
    perc_Rate_check=perc_F0_check-perc_F0;
    disp(['P',num2str(phon_cont_sign),'T',num2str(tone_cont_sign),': Mean of F0diff:',num2str(mean(perc_Rate_check))]);
    disp(['P',num2str(phon_cont_sign),'T',num2str(tone_cont_sign),': Std of F0diff:',num2str(std(perc_Rate_check))]);
    [~,check_minI]=max(abs(perc_Rate_check)*(-1));
    disp(perc_Rate_check)
    disp(['P',num2str(phon_cont_sign),'T',num2str(tone_cont_sign),': Select the No.',num2str(check_minI),' signal']);
    sound_final=sound_check{1,check_minI};
    clear perc_F0_check sound_check