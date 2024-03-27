function [tone_step_F0_perc,tone_step_meanF0_perc,tone_step_F0,tone_step_meanF0]=bsliang_get_tone_percent_inout(tone_step,sound_file_lst_in,sound_file_lst_out,avg_range)
    %给出被试的某一tone step阈值成绩，根据直接比较FO（而不是steps数）的方法来计算tone step所在的百分位
    %比起：（1）tone step / 178
    %以及（2）后面由于发现第一个step和第二个step之间间距更大而采用转换算法都要更加精确（理论上）
    
    %对于（2），参见F:\重要资料\博二上学期\范畴感知实验\第二步_制作连续体\预实验合成的tone连续体不均匀_从0_015才开始所以要做一下检测
    %里面的资料\，具体代码，参见本函数所在目录的bsliang_sevensteps_Main
    
    %由于第一版的生成steps有很大的误差，现在怀疑是STRAIGHT版本过旧有些事情做不好。所以，可能原来生成continuum也有一些问题。
    %这个函数做的工作就是，根据姜欣桐找出来的tone的上限和下限steps来找到与之相邻的step的声音，直接计算F0，看看跟原始刺激差多少。
    
    %[20190708] Now, we change the strategy, in order that the new 5*5
    %matrix (or the 7*7 matrix) is generated not based on the steps from the
    %preliminary experiments, but the F0 and VOT ranges, which are
    %universal in different experimental materials.
    %[20190708] To reach this purpose, we firstly transform the [step
    %numbers from 54*54(or 178) matrix in the pre experiment] to [real F0
    %and VOT values] and the calculate the [percentages of F0 and VOT in the new matrix]
    
    %sound_file_lst_in: the stim continuum from the preliminary experiment
    %sound_file_lst_out: the stim continuum that generate the matrix for
    %the formal experiment.
    
    %For most of the time, sound_file_lst_in and sound_file_lst_out are the
    %same, but sometimes they are different.
    
    % [ba1_ba2,pa1_pa2]
    tone_step_up_step=ceil(tone_step);
    tone_step_down_step=floor(tone_step);
    
    tone_step_up=sound_file_lst_in{1,tone_step_up_step};
    [tone_step_up_F0,tone_step_up_meanF0] = bsliang_getF0(tone_step_up,avg_range);
    
    tone_step_down=sound_file_lst_in{1,tone_step_down_step};
    [tone_step_down_F0,tone_step_down_meanF0] = bsliang_getF0(tone_step_down,avg_range);    % An illustration:
    
    %-------- phon step up step (e.g., 10)---------
    %                                        ↑
    %                                      delta up = 0.6
    %                                        ↓
    %-------- phon step (e.g., 9.4)-----------------
    %                                        ↑
    %                                      delta down = 0.4
    %                                        ↓ 
    %-------- phon step down step (e.g., 9)---------
    
    %下面要注意一个细节，虽然up在step的数值上要高于down，但是up对应的F0是低于down的，因为越往二声，平均F0就越低。
    tone_step_F0 = tone_step_down_F0 - abs(tone_step_down_F0-tone_step_up_F0)*abs(tone_step-tone_step_down_step);
    tone_step_meanF0 = tone_step_down_meanF0 - abs(tone_step_down_meanF0-tone_step_up_meanF0)*abs(tone_step-tone_step_down_step); 
    
    tone1 = sound_file_lst_out{1};
    tone2 = sound_file_lst_out{end};
    
    [tone1_F0,tone1_meanF0] = bsliang_getF0(tone1,avg_range);
    [tone2_F0,tone2_meanF0] = bsliang_getF0(tone2,avg_range);
    
    %20190706添加：计算F0的最短长度：
    min_F0_len = min([length(tone_step_F0),length(tone1_F0),length(tone2_F0)]);
    
    %下面计算的是得出的F0在连续体中占的百分位数：
    tone_step_F0_perc = abs(tone_step_F0(end-min_F0_len+1:end)-tone1_F0(end-min_F0_len+1:end))./abs(tone2_F0(end-min_F0_len+1:end)-tone1_F0(end-min_F0_len+1:end));
    tone_step_meanF0_perc = abs(tone_step_meanF0-tone1_meanF0)/abs(tone2_meanF0-tone1_meanF0);
    
%     F0=[tone1_F0;tone2_F0;tone_step_down_F0;tone_step_up_F0];
%     figure;
%     plot(1:size(F0,2),F0);

%     hold on
%     plot(avg_range(1,[1,end]),[0.1 0.1],'ro');
%     hold off

    
    
    
    
    