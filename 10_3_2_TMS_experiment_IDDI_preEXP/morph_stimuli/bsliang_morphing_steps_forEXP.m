function all_morphed_stim_norm=bsliang_morphing_steps_forEXP(xs_perc,nosteps_phon,nosteps_tone,fs)

% load sound parts:
di55_burst=audioread('input/di55_burst.wav');
di55_vowel_ti55=audioread('input/di55_vowel_ti55.wav');
ti55_VOT=audioread('input/ti55_VOT.wav');
ti55_vowel=audioread('input/ti55_vowel.wav');

votdur=length(ti55_VOT)/fs;
votint_len=votdur/nosteps_phon;

%di35_burst=audioread('di35_burst.wav');
di35_vowel_ti35=audioread('input/di35_vowel_ti35.wav');
%ti35_VOT=audioread('ti35_VOT.wav');
ti35_vowel=audioread('input/ti35_vowel.wav');

%votdur=length(ti35_VOT)/fs;
%votint_len_tone2=votdur/nosteps_phon;

% % now bind sounds and test RMS:
% di55_t = [di55_burst;di55_vowel_ti55];
% di35_t = [di35_burst;di35_vowel_ti35];
% ti55_t = [di55_burst;ti55_VOT;ti55_vowel];
% ti35_t = [di35_burst;ti35_VOT;ti35_vowel];
% 
% rms(di55_t)
% rms(di35_t)
% rms(ti55_t)
% rms(ti35_t)

vowel_rms=mean([rms(di55_vowel_ti55),rms(ti55_vowel),rms(di35_vowel_ti35),rms(ti35_vowel)]);

%votint_len = (votint_len_tone1 + votint_len_tone2)/2;


di1_ti1_contin = bsliang_phoneme_ratedcontinuum_Rate(di55_burst,ti55_VOT,di55_vowel_ti55,ti55_vowel,1,xs_perc.phon_old,vowel_rms);
%sound(di1_ti1_contin_cat,fs);
% audiowrite('di1_ti1_contin_cat.wav',di1_ti1_contin_cat,fs);
% save di1_ti1_contin di1_ti1_contin

di2_ti2_contin = bsliang_phoneme_ratedcontinuum_Rate(di55_burst,ti55_VOT,di35_vowel_ti35,ti35_vowel,2,xs_perc.phon_old,vowel_rms);
%sound(di2_ti2_contin_cat,fs);
% audiowrite('di2_ti2_contin_cat.wav',di2_ti2_contin_cat,fs);
% save di2_ti2_contin di2_ti2_contin


%=====================（2）	生成声调连续体===============

%注意这个steps的问题，没这么简单啊：
%比如如果有5个steps:
%step1(0%)   step2(25%)   step3(50%)   step4(75%)   step5(100%)
%那么我应该生成的百分比就是：0% 25% 50% 75% 100%
%也就是：0:(1/(5-1)):1
%如果是N个steps，那就是：0:(1/(N-1)):1

% tone_F0_steps=xs_perc.tone_old;
% all_morphed_stim_old_p=cell(nosteps_phon+1,nosteps_tone+1);
% 
% for phon_step = 1:nosteps_phon+1
%     tone1sound=di1_ti1_contin{phon_step};
%     tone2sound=di2_ti2_contin{phon_step};
%     F0_range=bsliang_getvalue_F0range(tone1sound,tone2sound); 
%     parfor tone_step = 1:nosteps_tone+1
%         disp(['Now morphing P',num2str(phon_step),'T',num2str(tone_step)]);
%         perc_F0 = tone_F0_steps(tone_step);
%         all_morphed_stim_old_p{phon_step,tone_step}= bsliang_morphing_tone_adaptive(tone1sound,tone2sound,F0_range,perc_F0,phon_step,nosteps_phon,votint_len,tone_step);
%     end
% end
% 
% RMS_phon_tone_index = [sort(repmat(1:nosteps_phon+1,1,nosteps_tone+1));repmat(1:nosteps_tone+1,1,nosteps_phon+1)];
% 
% all_morphed_stim_old=[];
% for RMS_step=1:size(RMS_phon_tone_index,2)
%     
%     phon_step=RMS_phon_tone_index(1,RMS_step);
%     tone_step=RMS_phon_tone_index(2,RMS_step);
%         
%     tone1sound=di1_ti1_contin{phon_step};
%     tone2sound=di2_ti2_contin{phon_step};
%     
%     TP_temp=all_morphed_stim_old_p{phon_step,tone_step};
% 
%     TP_temp=0.99*TP_temp/max(abs(TP_temp));
%     
%     TP_perc = xs_perc.phon_old(phon_step);
%     
%     [sound_asp,sound_t]=bsliang_connect_burst_vot_vowel_balanceRMS(di55_burst,ti55_VOT,TP_perc,TP_temp,vowel_rms);
%     all_morphed_stim_old{1,phon_step}{1,tone_step}=[sound_asp;sound_t];
%         
%     
% end

% RMS_phon_tone_index = [1*ones(1,nosteps_tone+1),2:nosteps_phon,(nosteps_phon+1)*ones(1,nosteps_tone+1),2:nosteps_phon;1:nosteps_tone+1,ones(1,nosteps_phon-1),1:nosteps_tone+1,(nosteps_tone+1)*ones(1,nosteps_phon-1)];
RMS_phon_tone_index = [sort(repmat(1:nosteps_phon+1,1,nosteps_tone+1));repmat(1:nosteps_tone+1,1,nosteps_phon+1)];

%tone_F0_steps=0:1/nosteps_tone:1;
%[20190714:杜老师要求54stepstone连续体的二声一端落在自然二声一半的地方，因此改成这样：]
tone_F0_steps=xs_perc.tone_old*0.5;

all_morphed_stim_old_p=cell(1,size(RMS_phon_tone_index,2));


parfor RMS_step=1:size(RMS_phon_tone_index,2)
    
    phon_step=RMS_phon_tone_index(1,RMS_step);
    tone_step=RMS_phon_tone_index(2,RMS_step);
    
    tone1sound=di1_ti1_contin{phon_step};
    tone2sound=di2_ti2_contin{phon_step};
    
    F0_range=bsliang_getvalue_F0range(tone1sound,tone2sound); 
   
    disp(['Now morphing P',num2str(phon_step),'T',num2str(tone_step)]);
    
%    if tone_step~=1
        perc_F0 = tone_F0_steps(tone_step);
        all_morphed_stim_old_p{1,RMS_step} = bsliang_morphing_tone_adaptive(tone1sound,tone2sound,F0_range,perc_F0,phon_step,nosteps_phon,votint_len,tone_step);
%    elseif tone_step==1
%        all_morphed_stim_old_p{1,RMS_step} = tone1sound;
        %[20190714:杜老师要求54stepstone连续体的二声一端落在自然二声一半的地方，因此禁掉elseif：]
%   elseif tone_step==nosteps_tone+1
%       all_morphed_stim_old_p{1,RMS_step}= tone2sound;
%    end
    
end


all_morphed_stim_old=[];
% This is to add burst and VOT and balance the RMS
for RMS_step=1:size(RMS_phon_tone_index,2)
    
    phon_step=RMS_phon_tone_index(1,RMS_step);
    tone_step=RMS_phon_tone_index(2,RMS_step);
        
    TP_temp=all_morphed_stim_old_p{1,RMS_step};

    TP_temp=0.99*TP_temp/max(abs(TP_temp));
    TP_perc = xs_perc.phon_old(phon_step);
    [sound_asp,sound_t]=bsliang_connect_burst_vot_vowel_balanceRMS(di55_burst,ti55_VOT,TP_perc,TP_temp,vowel_rms);
    all_morphed_stim_old{1,phon_step}{1,tone_step}=[sound_asp;sound_t];
        
end

%20190711: 自从加了上面那一段之后（元音乘以一个，下面这一段平衡RMS的代码就只有放大的作用了，避免校正声强太尴尬）

all_morphed_stim=all_morphed_stim_old;

%normalize to "one":
for RMS_step=1:size(RMS_phon_tone_index,2)
    phon_stim=RMS_phon_tone_index(1,RMS_step);
    tone_stim=RMS_phon_tone_index(2,RMS_step);

    temp_raw_sound=all_morphed_stim{phon_stim}{tone_stim};
    temp_raw_sound_max=max(abs(temp_raw_sound));
    temp_new_sound=temp_raw_sound/temp_raw_sound_max;
    all_morphed_stim{phon_stim}{tone_stim}=temp_new_sound;
    
end

%get the "RMS" (represented by SQRT锟斤拷锟斤拷(yi)^2/N))
all_morphed_stim_RMS=[];
for RMS_step=1:size(RMS_phon_tone_index,2)
    phon_stim=RMS_phon_tone_index(1,RMS_step);
    tone_stim=RMS_phon_tone_index(2,RMS_step);
    
    temp_raw_sound=all_morphed_stim{phon_stim}{tone_stim}';
    all_morphed_stim_RMS=[all_morphed_stim_RMS,rms(temp_raw_sound)];
end

%get the target "RMS" value to which all stimuli can be transfered without
%any amplitude value above 1 or -1.
max_RMS=max(all_morphed_stim_RMS);
% min_RMS=min(all_morphed_stim_RMS);
Tag_RMS=max_RMS:-0.01:0;
final_k=1;
for k_try=1:length(Tag_RMS)
    thistry_max=0;
    for RMS_step=1:size(RMS_phon_tone_index,2)
        phon_stim=RMS_phon_tone_index(1,RMS_step);
        tone_stim=RMS_phon_tone_index(2,RMS_step);
        
        temp_raw_sound=all_morphed_stim{phon_stim}{tone_stim}';
        temp_beta=Tag_RMS(k_try)/rms(temp_raw_sound);
        temp_new_sound_max=max(abs(temp_beta*temp_raw_sound));
        if temp_new_sound_max>thistry_max
            thistry_max=temp_new_sound_max;
        end
        
    end
    disp(['This iteration step is: ',num2str(k_try)]);
    if (thistry_max<1)
        final_k=k_try;
        break;
    end
end

% rescale all the stimuli
Target_RMS=Tag_RMS(final_k);
all_morphed_stim_norm=all_morphed_stim;
for RMS_step=1:size(RMS_phon_tone_index,2)
    phon_stim=RMS_phon_tone_index(1,RMS_step);
    tone_stim=RMS_phon_tone_index(2,RMS_step);
    
    raw_sound=all_morphed_stim{phon_stim}{tone_stim};
    beta=Target_RMS/rms(raw_sound);
    all_morphed_stim_norm{phon_stim}{tone_stim}=beta*raw_sound;
end

% so now lets test it:
all_morphed_stim_RMS_test=[];
for RMS_step=1:size(RMS_phon_tone_index,2)
    phon_stim=RMS_phon_tone_index(1,RMS_step);
    tone_stim=RMS_phon_tone_index(2,RMS_step);
    
    temp_raw_sound_test=all_morphed_stim_norm{phon_stim}{tone_stim}';
    all_morphed_stim_RMS_test=[all_morphed_stim_RMS_test,rms(temp_raw_sound_test)];
end
std(all_morphed_stim_RMS_test)

% great,successful!