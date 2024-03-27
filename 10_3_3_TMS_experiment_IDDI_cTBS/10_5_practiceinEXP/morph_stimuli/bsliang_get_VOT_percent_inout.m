function [phon_step_VOT_perc,phon_step_VOT]=bsliang_get_VOT_percent_inout(phon_step,sound_file_lst_in,sound_file_lst_out,fs)

    %[20190714]�������������û����ģ�������Ϊget_VOT���㷨���Ȳ���������У��VOT�ĺ�����Ҳ���������������ʱ���á��ȴ�get_VOT���ȱ�ߺ��ٿ���ʹ�����������
    %��ʵ��VOT�Ǹ��ݰٷֱ����ɵģ��������ʲô���ȵ�����ġ�ͬʱ�����VOT���ȴ��㷨�����ʱת��Ϊ�˹���顣

    %sound_file_lst_in: the stim continuum from the preliminary experiment
    %sound_file_lst_out: the stim continuum that generate the matrix for
    %the formal experiment.
    
    %For most of the time, sound_file_lst_in and sound_file_lst_out are the
    %same, but sometimes they are different.
        
    % [di1_ti1,di2_ti2]
    phon_step_up_step=ceil(phon_step);
    phon_step_down_step=floor(phon_step);
    
    phon_step_up=sound_file_lst_in{1,phon_step_up_step};
    phon_step_up_VOT = bsliang_getVOT(phon_step_up,fs);
    
    phon_step_down=sound_file_lst_in{1,phon_step_down_step};
    phon_step_down_VOT = bsliang_getVOT(phon_step_down,fs);
        
    % An illustration:
    
    %-------- phon step up step (e.g., 10)---------
    %                                        ��
    %                                      delta up = 0.6
    %                                        ��
    %-------- phon step (e.g., 9.4)-----------------
    %                                        ��
    %                                      delta down = 0.4
    %                                        �� 
    %-------- phon step down step (e.g., 9)---------
    
    
    %����Ҫע��һ��ϸ�ڣ�up��step����ֵ��Ҫ����down��up��Ӧ��VOT�ǳ���down�ģ�������F0�෴�ģ���������������Ҳ���෴�ġ�
    phon_step_VOT = phon_step_down_VOT + abs(phon_step_down_VOT-phon_step_up_VOT)*abs(phon_step-phon_step_down_step);
    
    phon1 = sound_file_lst_out{1};
    phon2 = sound_file_lst_out{end};
    
    phon1_VOT = bsliang_getVOT(phon1,fs);
    phon2_VOT = bsliang_getVOT(phon2,fs);
    
    %20190706��ӣ�����VOT����̳��ȣ�
%     min_VOT_len = min([length(phon_step_VOT),length(phon1_VOT),length(phon2_VOT)]);
    
    %���������ǵó���VOT����������ռ�İٷ�λ����
    phon_step_VOT_perc = abs(phon_step_VOT-phon1_VOT)/abs(phon2_VOT-phon1_VOT);
    
%     VOT=[phon1_VOT;phon2_VOT;phon_step_down_VOT;phon_step_up_VOT];
%     figure;
%     plot(1:size(VOT,2),VOT);

%     hold on
%     plot(fs(1,[1,end]),[0.1 0.1],'ro');
%     hold off

    
    
    
    
    