function out_data=bsliang_generatemorph(tone1,tone2,perc_Rate,tone1_beg,tone2_beg,lenpa1pa2,F0_range,outmode,phon_cont_sign,tone_cont_sign)
    
    %outmode:'_test_'：输出perc_F0(即通过Rate计算出来的F0比率)
            %'_generate_'：输出sound
    
    disp(['P',num2str(phon_cont_sign),'T',num2str(tone_cont_sign),':Zero point perRate=',num2str(perc_Rate)])
    sound_temp = timeFrequencySTRAIGHTmorphing(tone1,tone2,perc_Rate,'linear');
    sound = executeSTRAIGHTsynthesisM(sound_temp);

        %create STRAIGHT object
        tone_m=createMobject;

        %updateFieldOfMobject
        tone_m=updateFieldOfMobject(tone_m,'waveform',sound);

        %executeSTRAIGHTanalysisM
        tone_m = executeSTRAIGHTanalysisM(tone_m);

        %get the begining of F0 contour
        tone_m_pos=find(tone_m.F0);
        tone_m_beg=tone_m_pos(1);

        %calculate the lag of tone_m and align with tone1 and tone2
        tone_m_lag_F0=tone_m_beg-mean([tone1_beg,tone2_beg]);
        tone_m_lag=round((length(sound)/length(tone_m.F0))*tone_m_lag_F0);

        %change F0 and sound    
        if tone_m_lag>0 %late
            sound=sound(tone_m_lag+1:end);
            tone_m.F0=tone_m.F0(round(tone_m_lag_F0)+1:end);
        elseif tone_m_lag<0 %early
            sound=[zeros(tone_m_lag,1);sound];
            tone_m.F0=[zeros(1,tone_m_lag),tone_m.F0];
        end

%         tone_m_pos2=find(tone_m.F0);
%         tone_m_beg2=tone_m_pos2(1)+F0_range(1);

        %calculate the length difference of sound and F0
        sound_len_diff=lenpa1pa2-length(sound);

        if sound_len_diff>0 %shorter
            sound=[sound;zeros(abs(sound_len_diff),1)];
        elseif sound_len_diff<0 %longer
            sound=sound(1:end-abs(sound_len_diff));
        end

        F0_len_diff=round(mean([length(tone1.F0),length(tone2.F0)]))-length(tone_m.F0);
        if F0_len_diff>0 %shorter
            tone_m.F0=[tone_m.F0,zeros(1,abs(F0_len_diff))];
        elseif F0_len_diff<0 %longer
            tone_m.F0=tone_m.F0(1:end-abs(F0_len_diff));
        end    

        %just for test：ploting
         F0=[tone1.F0;tone_m.F0;tone2.F0];
    %     figure;
    %     subplot(4,2,1);
    %     plot(1:size(F0,2),F0(1,:));
    %     subplot(4,2,3);
    %     plot(1:size(F0,2),F0(2,:));
    %     subplot(4,2,5);
    %     plot(1:size(F0,2),F0(3,:));
    %     subplot(4,2,7);
    %     plot(1:size(F0,2),F0);
    %     subplot(4,2,2);
    %     plot(1:size(F0(:,F0_range(1):F0_range(2)),2),F0(1,F0_range(1):F0_range(2)));
    %     ylim([200,350]);
    %     subplot(4,2,4);
    %     plot(1:size(F0(:,F0_range(1):F0_range(2)),2),F0(2,F0_range(1):F0_range(2)));
    %     ylim([200,350]);
    %     subplot(4,2,6);
    %     plot(1:size(F0(:,F0_range(1):F0_range(2)),2),F0(3,F0_range(1):F0_range(2)));
    %     ylim([200,350]);
    %     subplot(4,2,8);
    %     plot(1:size(F0(:,F0_range(1):F0_range(2)),2),F0(:,F0_range(1):F0_range(2)));
    %     ylim([200,350]);

        %
        meanF0=mean(F0(:,F0_range(1):F0_range(2)),2);
        perc_F0=abs(meanF0(2)-meanF0(1))/abs(meanF0(3)-meanF0(1));
        
    if isequal(outmode,'_generate_')
        out_data.sound=sound;
        out_data.perc_F0=perc_F0;
    elseif isequal(outmode,'_test_')
        out_data=perc_F0;
    end
    
    end
    
    
    


    
    
    
    
    
    
    