function [par_EXPdata,xs_perc_struct]=bsliang_fivesteps_Main(nosteps_phon_raw,nosteps_tone_raw,xs_perc)

    nosteps_phon=nosteps_phon_raw-1;
    nosteps_tone=nosteps_tone_raw-1;
    
    fs=44100;
    
    xs_perc_struct.xs_perc=xs_perc;

        all_morphed_stim_old_norm=bsliang_morphing_steps_forEXP(xs_perc,nosteps_phon,nosteps_tone,fs);

        for phon=1:nosteps_phon+1
            for tone=1:nosteps_tone+1
                BEHAV_old_stim_mat{phon,tone}=all_morphed_stim_old_norm{1,phon}{1,tone};
        %         BEHAV_young_stim_mat{phon,tone}=all_morphed_stim_young_norm{1,phon}{1,tone};
            end
        end

        clear all_morphed_stim_old_norm phon tone %all_morphed_stim_young_norm

        % �����ǽ��м���Ĵ��룬ƽʱע�͵��ͺ�
        %     BEHAV_old_stim_mat_morphtest = bsliang_morphongtest(BEHAV_old_stim_mat,'_old_');
        %     BEHAV_young_stim_mat_morphtest = bsliang_morphongtest(BEHAV_young_stim_mat,'_young_');
        %     save BEHAV_old_stim_mat_morphtest BEHAV_old_stim_mat_morphtest
        %     save BEHAV_young_stim_mat_morphtest BEHAV_young_stim_mat_morphtest

        %% ���Ĳ������������8dB��������
        [BEHAV_old_stim_mat_noise,BEHAV_old_stim_clear_mat] = BSLiang_addspectrumnoise(BEHAV_old_stim_mat,8);
        BEHAV_old_stim_mat = BEHAV_old_stim_clear_mat;

        %listen:
        % for phon=1:5
        % for tone=1:5
        %     kk=BEHAV_old_stim_mat_noise{phon,tone};
        % sound(kk(end-10000:end-6000),44100);
        % pause(4000/44100)
        % end
        % end

        %[BEHAV_young_stim_mat_noise,BEHAV_young_stim_clear_mat] = BSLiang_addspectrumnoise(BEHAV_young_stim_mat,-8);
        %BEHAV_old_stim_mat = BEHAV_young_stim_clear_mat
        %% ����14*2�������̼���
        % par_con={'old','young'};
        % con={'phon','tone'};
        % for par_con_i=1:2
        %     if par_con_i==1
        %         matrix = BEHAV_old_stim_mat;
        %     else
        %         matrix = BEHAV_young_stim_mat;
        %     end
        %     for con_i=1:2
        %         for step=1:5
        %             if con_i==1
        %                 
        %                 list = matrix{step,}
        %             elseif
        %             end
        %             [~,~]=BSLiang_writeaudio(list,5,con{1,con_i},par_con{1,par_con_i},step,44100);
        %         end
        %     end
        % end


        %% ���岽���������5��steps��ѡȡ������Щ�̼���Ϊ�Ե�ʵ����ϣ�

        %[20190617:�ѱ����save�ĵ����浽һ��structurt�˰ɡ�Ȼ�������ļ��ṹ��ô��ȽϷ��㡣]

        EEG_old_stim = BSLiang_getEEGfromBEHAVstim(BEHAV_old_stim_mat);
        % EEG_young_stim = BSLiang_getEEGfromBEHAVstim(BEHAV_young_stim_mat);
        EEG_old_stim_noise = BSLiang_getEEGfromBEHAVstim(BEHAV_old_stim_mat_noise);
        % EEG_young_stim_noise = BSLiang_getEEGfromBEHAVstim(BEHAV_young_stim_mat_noise);

        par_EXPdata.EEG_old_stim=EEG_old_stim;
        par_EXPdata.EEG_old_stim_noise=EEG_old_stim_noise;

%         save EEG_old_stim EEG_old_stim
        % save EEG_young_stim EEG_young_stim
%         save EEG_old_stim_noise EEG_old_stim_noise
        % save EEG_young_stim_noise EEG_young_stim_noise

        %% ����������5*5����ת��Ϊ��Ϊʵ���õ�4��49�д̼�����
        [stim_continuum,~] = BSLiang_BEHAVmatrix_into_list(BEHAV_old_stim_mat);
%         save T_old_BEHAV stim_continuum
        par_EXPdata.T_old_BEHAV=stim_continuum;

        [~,stim_continuum] = BSLiang_BEHAVmatrix_into_list(BEHAV_old_stim_mat);
%         save T_old_BEDIS stim_continuum
        par_EXPdata.T_old_BEDIS=stim_continuum;

        [stim_continuum,~] = BSLiang_BEHAVmatrix_into_list(BEHAV_old_stim_mat');
%         save P_old_BEHAV stim_continuum
        par_EXPdata.P_old_BEHAV=stim_continuum;

        [~,stim_continuum] = BSLiang_BEHAVmatrix_into_list(BEHAV_old_stim_mat');
%         save P_old_BEDIS stim_continuum
        par_EXPdata.P_old_BEDIS=stim_continuum;

        % stim_continuum = BSLiang_BEHAVmatrix_into_list(BEHAV_young_stim_mat);
        % save T_young_BEHAV stim_continuum
        % 
        % stim_continuum = BSLiang_BEHAVmatrix_into_list(BEHAV_young_stim_mat');
        % save P_young_BEHAV stim_continuum

        stim_continuum = BSLiang_BEHAVmatrix_into_list(BEHAV_old_stim_mat_noise);
%         save T_old_noise_BEHAV stim_continuum
        par_EXPdata.T_old_noise_BEHAV=stim_continuum;

        stim_continuum = BSLiang_BEHAVmatrix_into_list(BEHAV_old_stim_mat_noise');
%         save P_old_noise_BEHAV stim_continuum
        par_EXPdata.P_old_noise_BEHAV=stim_continuum;

        % stim_continuum = BSLiang_BEHAVmatrix_into_list(BEHAV_young_stim_mat_noise);
        % save T_young_noise_BEHAV stim_continuum
        % 
        % stim_continuum = BSLiang_BEHAVmatrix_into_list(BEHAV_young_stim_mat_noise');

end



