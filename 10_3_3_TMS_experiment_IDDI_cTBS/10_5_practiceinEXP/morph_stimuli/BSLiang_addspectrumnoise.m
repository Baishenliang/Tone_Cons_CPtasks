function [noisemasked_matrix,clear_matrix,noisemasked_noiseonly_matrix]=BSLiang_addspectrumnoise(org_matrix,SNR)
% ÎÒµÄ³ÌÐò°üÀïÓÐ¸ö°æ±¾µÄÌí¼ÓÔëÒô´úÂë£¬Ò»¸öÊÇ¡°µÚ¶þ²½_ÖÆ×÷Á¬ÐøÌå¡±Àïmorphing_20190125×îºóÃæÒ»¶Î£¬ÁíÒ»¸öÊÇÕâÒ»¶Î
% Õâ¶Î´úÂë¸ü¼ò½à£¬µ«ÊÇÖ»ÄÜÉúÒ»¸öÐÅÔë±ÈµÄ£¬morphing¿ÉÒÔ×öÁ¬ÐøÌå¡¤¡¤¡¤¡¤¡¤
% ¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤¡¤                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    
    %% µÚÒ»²½£¬¼ÓÔØÓïÆ×ÔëÒô
        [noisemask_raw,fs]=audioread('input/speech_noise_YD_4klp_44100sp.wav');
    
    %% µÚ¶þ²½£¬¼ÆËãÉùÒô³¤¶È£¨¼´ÓïÆ×ÔëÒô½ØÈ¡³¤¶È£©ÒÔ¼°RMS¾ØÕó
%         length_max=0;
        RMS_sound=zeros(size(org_matrix,1),size(org_matrix,2));
        RMS_noise=zeros(size(org_matrix,1),size(org_matrix,2));
        noisemask=cell(size(org_matrix,1),size(org_matrix,2));
        for matrix_row=1:size(org_matrix,1)
            for matrix_col=1:size(org_matrix,2)
                length_temp=length(org_matrix{matrix_row,matrix_col});
                disp(matrix_row)
                disp(matrix_col)
                disp(length_temp)
                RMS_sound(matrix_row,matrix_col)=rms(org_matrix{matrix_row,matrix_col});
%                 if length_temp>length_max
%                     length_max=length_temp;
%                 end
                %% µÚÈý²½£¬¸ù¾Ý×î´ó³¤¶È½ØÈ¡ÓïÆ×ÔëÒôÒÔ¼°ÔëÒôRMS
                    noisemask_temp=noisemask_raw(1:length_temp);

                    %rise-decay envelope
                    Ts = 1/44100;
                    rise_10ms=(0:Ts:0.010)*(1/0.010);
                    fall_10ms=(0.010:-Ts:0)*(1/0.010);

                    noisemask_temp(1:length(rise_10ms))=noisemask_temp(1:length(rise_10ms)).*rise_10ms';
                    noisemask_temp(end-length(fall_10ms)+1:end)=noisemask_temp(end-length(fall_10ms)+1:end).*fall_10ms';

                    RMS_noise(matrix_row,matrix_col)=rms(noisemask_temp);
                    noisemask{matrix_row,matrix_col}=noisemask_temp;
            end
        end
        
        
    %%  µÚËÄ²½£¬¼ÆËãÔëÒô·Å´óÏµÊýk¾ØÕó
        k_lst = sqrt(10^((-1)*SNR/10))*(RMS_sound./RMS_noise);
        %[20190415Ôö¼Ó]
        k_lst_mean = mean(mean(k_lst,1),2);
        noisemask_output = k_lst_mean*noisemask_raw; 
    %%  µÚÎå²½£¬½«ÔëÉùÌí¼ÓÖÁÔ­Ê¼ÉùÒôÀï,¾ÍÉú³ÉÔëÉùÑÚ±ÎµÄÉùÒôÀ²£¬²¢ÇÒ¼ÆËã³ö×î´ó·ùÖµ£¬ÓÃÒÔ±ÜÃâÏ÷·å
    
        SNR_check_lst=zeros(size(org_matrix,1),size(org_matrix,2));
        
        SNR_combined_check_lst=zeros(size(org_matrix,1),size(org_matrix,2));
        
        signal_largest_max=0;
        noisemasked_matrix = cell(size(org_matrix,1),size(org_matrix,2));
        noisemasked_noiseonly_matrix = cell(size(org_matrix,1),size(org_matrix,2));
        clear_matrix = cell(size(org_matrix,1),size(org_matrix,2));
        for matrix_row=1:size(org_matrix,1)
            for matrix_col=1:size(org_matrix,2)
                %sound_temp=[org_matrix{matrix_row,matrix_col};zeros(length(noisemask{matrix_row,matrix_col})-length(org_matrix{matrix_row,matrix_col}),1)];
                noisemasked_matrix{matrix_row,matrix_col}=org_matrix{matrix_row,matrix_col}+noisemask{matrix_row,matrix_col}*k_lst(matrix_row,matrix_col);
                noisemasked_noiseonly_matrix{matrix_row,matrix_col}=noisemask{matrix_row,matrix_col}*k_lst(matrix_row,matrix_col);
                %sound_temp=[];
                SNR_combined_check_lst(matrix_row,matrix_col)=bsliang_snr_c_s(noisemasked_matrix{matrix_row,matrix_col},org_matrix{matrix_row,matrix_col});
                
                 %check SNR
                try
                    SNR_check=snr(org_matrix{matrix_row,matrix_col},noisemask{matrix_row,matrix_col}*k_lst(matrix_row,matrix_col));
                catch
                    SNR_check=10*log10((rms(org_matrix{matrix_row,matrix_col})^2)/(rms(noisemask{matrix_row,matrix_col}*k_lst(matrix_row,matrix_col))^2));
                end
                
                SNR_check_lst(matrix_row,matrix_col)=SNR_check;
            
                signal_max_temp=max(abs(noisemasked_matrix{matrix_row,matrix_col}));
                if signal_max_temp > signal_largest_max
                    signal_largest_max = signal_max_temp;
                end
        
            end
        end
        
        
        %±ÜÃâÏ÷·åµÄÐ£Õý
        Check_max_amp=zeros(size(org_matrix,1),size(org_matrix,2));
        Check_RMS=zeros(size(org_matrix,1),size(org_matrix,2));
        Check_max_amp_noiseonly=zeros(size(org_matrix,1),size(org_matrix,2));
        Check_RMS_noiseonly=zeros(size(org_matrix,1),size(org_matrix,2));
        Check_max_amp_clear=zeros(size(org_matrix,1),size(org_matrix,2));
        Check_RMS_clear=zeros(size(org_matrix,1),size(org_matrix,2));
        SNR_combined_check_lst_2=zeros(size(org_matrix,1),size(org_matrix,2));

        %[20190415Ôö¼Ó]
        noisemask_output=noisemask_output/signal_largest_max;
        audiowrite('output/bsliang_continune_SSN_YD.wav',noisemask_output,fs);
        
        for matrix_row=1:size(org_matrix,1)
            for matrix_col=1:size(org_matrix,2)
                
                noisemasked_matrix{matrix_row,matrix_col}=noisemasked_matrix{matrix_row,matrix_col}/signal_largest_max;
                noisemasked_noiseonly_matrix{matrix_row,matrix_col}=noisemasked_noiseonly_matrix{matrix_row,matrix_col}/signal_largest_max;
                clear_matrix{matrix_row,matrix_col}=org_matrix{matrix_row,matrix_col}/signal_largest_max;
                
                Check_max_amp(matrix_row,matrix_col)=max(abs(noisemasked_matrix{matrix_row,matrix_col}));
                Check_max_amp_noiseonly(matrix_row,matrix_col)=max(abs(noisemasked_noiseonly_matrix{matrix_row,matrix_col}));
                Check_max_amp_clear(matrix_row,matrix_col)=max(abs(clear_matrix{matrix_row,matrix_col}));
                
                Check_RMS(matrix_row,matrix_col)=rms(noisemasked_matrix{matrix_row,matrix_col}); 
                Check_RMS_noiseonly(matrix_row,matrix_col)=rms(noisemasked_noiseonly_matrix{matrix_row,matrix_col});
                Check_RMS_clear(matrix_row,matrix_col)=rms(clear_matrix{matrix_row,matrix_col});
                
                SNR_combined_check_lst_2(matrix_row,matrix_col)=bsliang_snr_c_s(noisemasked_matrix{matrix_row,matrix_col},clear_matrix{matrix_row,matrix_col});
  
            end
        end
        
        disp('============================================================================================================')
        disp('                                   Now check the generated stimuli                                          ')
        disp('============================================================================================================')
        disp(' ')
        disp('=======================================For noised-masked stimuli============================================')
        
        disp('Peak check noisemasked_matrix (Should all less than 1) = ')
        disp(Check_max_amp)
        
        disp('Peak check noisemasked_matrix (Marked as 1 if larger than 1) = ')
        disp(Check_max_amp>1)
        
        disp('RMS check noisemasked_matrix (Should be the same) =')
        disp(Check_RMS)
        
        disp(['RMS noisemasked_matrix check mean value = ',num2str(mean(mean(Check_RMS,1),2))]);
        
        disp(['RMS noisemasked_matrix check std = ',num2str(std(reshape(Check_RMS,1,[])))]); 
        
        disp(' ')
        disp('=======================================For clear stimuli==============================================')
        
        disp('Peak check clear_matrix (Should all less than 1) = ')
        disp(Check_max_amp_clear)
        
        disp('Peak check clear_matrix (Marked as 1 if larger than 1) = ')
        disp(Check_max_amp_clear>1)
        
        disp('RMS check clear_matrix (Should be the same) =')
        disp(Check_RMS_clear)
        
        disp(['RMS clear_matrix check mean value = ',num2str(mean(mean(Check_RMS_clear,1),2))]);
        
        disp(['RMS clear_matrix check std = ',num2str(std(reshape(Check_RMS_clear,1,[])))]); 

         disp(' ')
        disp('=======================================For noise masks==============================================')
        
        disp('Peak check noise masks (Should all less than 1) = ')
        disp(Check_max_amp_noiseonly)
        
        disp('Peak check noise masks (Marked as 1 if larger than 1) = ')
        disp(Check_max_amp_noiseonly>1)
        
        disp('RMS check noise masks (Should be the same) =')
        disp(Check_RMS_noiseonly)
        
        disp(['RMS noise masks check mean value = ',num2str(mean(mean(Check_RMS_noiseonly,1),2))]);
        
        disp(['RMS noise masks check std = ',num2str(std(reshape(Check_RMS_noiseonly,1,[])))]); 
        
        disp(' ')
        disp('=================================To calculate SNR based on clear_matrix and noise masks==============================')
        disp(10*log10((Check_RMS_clear.*Check_RMS_clear)./(Check_RMS_noiseonly.*Check_RMS_noiseonly)));
         
        disp(' ')
        disp('==========================================SNR==================================================')
        
        %¹Û²ìÐÅÔë±ÈÊÇ·ñµ÷ÖÆÕýÈ·£º
        disp('SNR_check Matrix before amplitude correction (Generated from signal and noise) = ')
        disp(SNR_check_lst);
        
        disp('SNR_check Matrix before amplitude correction (Generated from noise-masked signal and noise) =')
        disp(SNR_combined_check_lst);

        disp('SNR_check Matrix after amplitude correction (Generated from noise-masked signal and noise) =')
        disp(SNR_combined_check_lst_2);        
  
