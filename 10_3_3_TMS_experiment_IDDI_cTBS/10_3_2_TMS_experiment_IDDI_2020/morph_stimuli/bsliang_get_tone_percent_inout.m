function [tone_step_F0_perc,tone_step_meanF0_perc,tone_step_F0,tone_step_meanF0]=bsliang_get_tone_percent_inout(tone_step,sound_file_lst_in,sound_file_lst_out,avg_range)
    %�������Ե�ĳһtone step��ֵ�ɼ�������ֱ�ӱȽ�FO��������steps�����ķ���������tone step���ڵİٷ�λ
    %���𣺣�1��tone step / 178
    %�Լ���2���������ڷ��ֵ�һ��step�͵ڶ���step֮������������ת���㷨��Ҫ���Ӿ�ȷ�������ϣ�
    
    %���ڣ�2�����μ�F:\��Ҫ����\������ѧ��\�����֪ʵ��\�ڶ���_����������\Ԥʵ��ϳɵ�tone�����岻����_��0_015�ſ�ʼ����Ҫ��һ�¼��
    %���������\��������룬�μ�����������Ŀ¼��bsliang_sevensteps_Main
    
    %���ڵ�һ�������steps�кܴ�������ڻ�����STRAIGHT�汾������Щ���������á����ԣ�����ԭ������continuumҲ��һЩ���⡣
    %����������Ĺ������ǣ����ݽ���ͩ�ҳ�����tone�����޺�����steps���ҵ���֮���ڵ�step��������ֱ�Ӽ���F0��������ԭʼ�̼�����١�
    
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
    %                                        ��
    %                                      delta up = 0.6
    %                                        ��
    %-------- phon step (e.g., 9.4)-----------------
    %                                        ��
    %                                      delta down = 0.4
    %                                        �� 
    %-------- phon step down step (e.g., 9)---------
    
    %����Ҫע��һ��ϸ�ڣ���Ȼup��step����ֵ��Ҫ����down������up��Ӧ��F0�ǵ���down�ģ���ΪԽ��������ƽ��F0��Խ�͡�
    tone_step_F0 = tone_step_down_F0 - abs(tone_step_down_F0-tone_step_up_F0)*abs(tone_step-tone_step_down_step);
    tone_step_meanF0 = tone_step_down_meanF0 - abs(tone_step_down_meanF0-tone_step_up_meanF0)*abs(tone_step-tone_step_down_step); 
    
    tone1 = sound_file_lst_out{1};
    tone2 = sound_file_lst_out{end};
    
    [tone1_F0,tone1_meanF0] = bsliang_getF0(tone1,avg_range);
    [tone2_F0,tone2_meanF0] = bsliang_getF0(tone2,avg_range);
    
    %20190706��ӣ�����F0����̳��ȣ�
    min_F0_len = min([length(tone_step_F0),length(tone1_F0),length(tone2_F0)]);
    
    %���������ǵó���F0����������ռ�İٷ�λ����
    tone_step_F0_perc = abs(tone_step_F0(end-min_F0_len+1:end)-tone1_F0(end-min_F0_len+1:end))./abs(tone2_F0(end-min_F0_len+1:end)-tone1_F0(end-min_F0_len+1:end));
    tone_step_meanF0_perc = abs(tone_step_meanF0-tone1_meanF0)/abs(tone2_meanF0-tone1_meanF0);
    
%     F0=[tone1_F0;tone2_F0;tone_step_down_F0;tone_step_up_F0];
%     figure;
%     plot(1:size(F0,2),F0);

%     hold on
%     plot(avg_range(1,[1,end]),[0.1 0.1],'ro');
%     hold off

    
    
    
    
    